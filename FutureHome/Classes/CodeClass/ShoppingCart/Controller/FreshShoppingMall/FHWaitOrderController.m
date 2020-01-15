//
//  FHWaitOrderController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  待付款

#import "FHWaitOrderController.h"
#import "FHWatingOrderCell.h"
#import "FHOrderDetailController.h"
#import "FHNewWatiingOrderCell.h"
#import "FHGoodsListModel.h"
#import "FHCommonPaySelectView.h"
#import "FHAppDelegate.h"
#import "FHReturnRefundController.h"
#import "FHGoodsCommitController.h"
#import "LeoPayManager.h"

@interface FHWaitOrderController () <UITableViewDelegate,UITableViewDataSource,FHCommonPaySelectViewDelegate>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 数据列表 */
@property (nonatomic, strong) NSMutableArray *dataListArrs;

@property (nonatomic, strong) FHCommonPaySelectView *payView;
/** 支付类型 1 支付宝 2 微信*/
@property (nonatomic, assign) NSInteger payType;
/** 订单id */
@property (nonatomic, copy) NSString *orderID;


@end

@implementation FHWaitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataListArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHNewWatiingOrderCell class] forCellReuseIdentifier:NSStringFromClass([FHNewWatiingOrderCell class])];
    [self.view addSubview:self.homeTable];
    [self loadInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadInit];
}

#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.homeTable.mj_footer resetNoMoreData];
    
    [self getRequestLoadHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getRequestLoadHead:NO];
    } else {
        [self.homeTable.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.homeTable.mj_header;
    MJRefreshFooter *footer = self.homeTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

- (void)getRequestLoadHead:(BOOL)isHead {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.status),@"status",
                               @"20",@"limit",
                               @(curPage),@"page",
                               self.order_type,@"order_type",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    
    [AFNetWorkTool get:@"shop/getOrderList" params:paramsDic success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [weakSelf.dataListArrs removeAllObjects];
            }
            [weakSelf endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [weakSelf.dataListArrs addObjectsFromArray:[FHGoodsListModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
            [weakSelf.homeTable reloadData];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf endRefreshAction];
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHNewWatiingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHNewWatiingOrderCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IS_NULL_ARRAY(self.dataListArrs)) {
        FHGoodsListModel *listModel = self.dataListArrs[indexPath.row];
        cell.listModel = listModel;
        cell.goodsImgArrs = listModel.covers;
        cell.typeBtn.tag = indexPath.row;
        NSString *typeString;
        if (self.status == 1) {
            typeString = @"待付款";
            cell.statueBtn.hidden = NO;
            cell.statueBtn.tag = indexPath.row;
            [cell.statueBtn addTarget:self action:@selector(statueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
             [cell.typeBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        } else if (self.status == 2) {
            typeString = @"确认收货";
            [cell.typeBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        } else if (self.status == 3) {
            if ([listModel.iscomment isEqualToString:@"0"]) {
                typeString = @"待评价";
                [cell.typeBtn setBackgroundColor:HEX_COLOR(0x1296db)];
            } else if ([listModel.iscomment isEqualToString:@"1"]) {
                [cell.typeBtn setBackgroundColor:[UIColor lightGrayColor]];
                typeString = @"已评价";
            }
        } else if (self.status == 4) {
            if ([listModel.status integerValue] >= 2) {
                if ([listModel.status integerValue] == 6) {
                    typeString = @"退款成功";
                    [cell.typeBtn setBackgroundColor:[UIColor lightGrayColor]];
                } else if ([listModel.status integerValue] == 7) {
                    typeString = @"拒绝退款";
                    [cell.typeBtn setBackgroundColor:[UIColor lightGrayColor]];
                } else if ([listModel.status integerValue] == 4) {
                    typeString = @"已完成";
                    [cell.typeBtn setBackgroundColor:[UIColor lightGrayColor]];
                } else if ([listModel.status integerValue] == 5) {
                    typeString = @"退款中";
                    [cell.typeBtn setBackgroundColor:[UIColor lightGrayColor]];
                } else {
                    typeString = @"退货退款";
                    [cell.typeBtn setBackgroundColor:HEX_COLOR(0x1296db)];
                }
            }
        }
        [cell.typeBtn setTitle:typeString forState:UIControlStateNormal];
        [cell.typeBtn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHGoodsListModel *listModel = self.dataListArrs[indexPath.row];
    FHOrderDetailController *detail = [[FHOrderDetailController alloc] init];
    detail.status = self.status;
    detail.hidesBottomBarWhenPushed = YES;
    detail.order_id = listModel.id;
    detail.listModel = listModel;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)typeClick:(UIButton *)sender {
    FHGoodsListModel *listModel = self.dataListArrs[sender.tag];
    if (self.status == 1) {
        /** 待付款 */
        self.orderID = listModel.id;
        [self creatPayViewWithPrice:listModel.pay_money];
        [self showPayView];
    } else if (self.status == 2) {
        /** 待收货 */
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确认收货吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 确认收货 */
                WS(weakSelf);
                Account *account = [AccountStorage readAccount];
                NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @(account.user_id),@"user_id",
                                           listModel.id,@"order_id",
                                           [SingleManager shareManager].ordertype,@"ordertype",nil];
                [AFNetWorkTool post:@"shop/confirmgoods" params:paramsDic success:^(id responseObj) {
                    if ([responseObj[@"code"] integerValue] == 1) {
                        [weakSelf.view makeToast:@"确认收货成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf loadInit];
                            [weakSelf.homeTable reloadData];
                        });
                    } else {
                        [weakSelf.view makeToast:responseObj[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [weakSelf.homeTable reloadData];
                }];
            }
        }];
    } else if (self.status == 3){
        /** 待评价 和 已经评价 */
        if ([listModel.iscomment isEqualToString:@"0"]) {
            /** 待评价的操作 */
            FHGoodsCommitController *commit = [[FHGoodsCommitController alloc] init];
            commit.hidesBottomBarWhenPushed = YES;
            commit.orderID = listModel.id;
            [self.navigationController pushViewController:commit animated:YES];
        }
    } else if (self.status == 4){
        /** 退货相关的 */
        if ([listModel.status integerValue] >= 2) {
            if ([listModel.status isEqualToString:@"6"]||
                [listModel.status isEqualToString:@"7"]||
                [listModel.status isEqualToString:@"4"]||
                [listModel.status isEqualToString:@"5"]) {
            } else {
               /** 退货退款操作 */
                FHReturnRefundController *vc = [[FHReturnRefundController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.orderID = listModel.id;
                vc.totolePrice = [NSString stringWithFormat:@"￥%.2f",[listModel.pay_money floatValue]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

/** 取消订单 */
- (void)statueBtnClick:(UIButton *)sender {
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定要取消订单吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            /** 确定删除 */
            [weakSelf cancelOrderWithSelectindex:sender.tag];
        }
    }];
}


- (void)cancelOrderWithSelectindex:(NSInteger )indexPath {
    FHGoodsListModel *listModel = self.dataListArrs[indexPath];
    /** 取消订单 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               listModel.id,@"order_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool post:@"shop/cancelOrder" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"取消订单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadInit];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"暂无相关数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:167/255.0 green:181/255.0 blue:194/255.0 alpha:1/1.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak FHWaitOrderController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
}

- (void)creatPayViewWithPrice:(NSString *)price {
    if (!self.payView) {
        self.payView = [[FHCommonPaySelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260) andNSString:[NSString stringWithFormat:@"在线支付支付价格为:￥%@",price]];
        _payView.delegate = self;
    }
    FHAppDelegate *delegate  = (FHAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
}

- (void)fh_selectPayTypeWIthTag:(NSInteger)selectType {
    /** 请求支付宝签名 */
    self.payType = selectType;
    /** 待付款的操作 */
    [self sureOrderRequest];
}

- (void)sureOrderRequest {
    /** 待付款的下单 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.orderID,@"order_id",
                               @(self.payType),@"pay_way",
                               nil];
    
    [AFNetWorkTool post:@"shop/orderPaid" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (weakSelf.payType == 1) {
                /** 支付宝支付 */
                LeoPayManager *manager = [LeoPayManager getInstance];
                [manager aliPayOrder: responseObj[@"data"][@"alipay"] scheme:@"alisdkdemo" respBlock:^(NSInteger respCode, NSString *respMsg) {
                    if (respCode == 0) {
                        /** 支付成功 */
                        WS(weakSelf);
                        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"付款成功" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                            if (buttonIndex == 0) {
                                [weakSelf loadInit];
                            }
                        }];
                    } else if (respCode == -2) {
                        [self.view makeToast:respMsg];
                    }
                }];
            }
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.emptyDataSetSource = self;
        _homeTable.emptyDataSetDelegate = self;
        _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
        _homeTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}


@end
