//
//  FHOrderDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  订单详情界面

#import "FHOrderDetailController.h"
#import "FHWatingOrderCell.h"
#import "FHOrderListModel.h"
#import "BRPlaceholderTextView.h"

@interface FHOrderDetailController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 用户名字 */
@property (nonatomic, copy) NSString *nameString;
/** 地址 */
@property (nonatomic, copy) NSString *addressString;
/** 物流方式 */
@property (nonatomic, copy) NSString *typeString;
/** 公司名字 */
@property (nonatomic, copy) NSString *companyNameString;
/** 店铺名字 */
@property (nonatomic, copy) NSString *shopNameStirng;
/** 订单编号 */
@property (nonatomic, copy) NSString *orderCodeString;
/** 支付类型 */
@property (nonatomic, copy) NSString *payMentTypeString;
/** 订单备注 */
@property (nonatomic, copy) NSString *orederInfoStirng;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *goodArrs;
/** 总价 */
@property (nonatomic, assign) CGFloat totalMoneyString;
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;

@end

@implementation FHOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodArrs = [[NSMutableArray alloc] init];
    [self fh_creatNav];
    [self creatBottomBtn];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHWatingOrderCell class] forCellReuseIdentifier:NSStringFromClass([FHWatingOrderCell class])];
    [self getRequest];
}

- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.order_id,@"order_id", nil];
    [AFNetWorkTool get:@"shop/getSingOrder" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.orderCodeString = responseObj[@"data"][@"order_number"];
            weakSelf.shopNameStirng = responseObj[@"data"][@"shopname"];
            weakSelf.nameString = responseObj[@"data"][@"buyuser"];
            weakSelf.addressString = responseObj[@"data"][@"detailedaddress"];
            weakSelf.companyNameString = responseObj[@"data"][@"companyname"];
            weakSelf.totalMoneyString = [responseObj[@"data"][@"total_money"] floatValue];
            weakSelf.orederInfoStirng = responseObj[@"data"][@"remark"];
            if ([responseObj[@"data"][@"type"] integerValue] == 1) {
                weakSelf.typeString = @"快递到家";
            } else if ([responseObj[@"data"][@"type"] integerValue] == 2) {
                weakSelf.typeString = @"预定前往";
            } else if ([responseObj[@"data"][@"type"] integerValue] == 3) {
                weakSelf.typeString = @"实时配送";
            }
            NSInteger payString  = [responseObj[@"data"][@"pay_way"] integerValue];
            if (payString == 1) {
                weakSelf.payMentTypeString = @"支付宝支付";
            } else if (payString == 2) {
                weakSelf.payMentTypeString = @"微信支付";
            }
            weakSelf.goodArrs = [FHOrderListModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"goods"]];
            [weakSelf.homeTable reloadData];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"订单详情";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatBottomBtn {
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    bottomBtn.backgroundColor = HEX_COLOR(0x1296db);
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [completedBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *typeString;
    if (self.status == 1) {
        typeString = @"待付款";
    } else if (self.status == 2) {
        typeString = @"确认收货";
    } else if (self.status == 3) {
        if ([self.listModel.iscomment isEqualToString:@"0"]) {
            typeString = @"待评价";
        } else if ([self.listModel.iscomment isEqualToString:@"1"]) {
            [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            typeString = @"已评价";
        }
    } else if (self.status == 4) {
        if ([self.listModel.status integerValue] >= 2) {
            if ([self.listModel.status integerValue] == 6) {
                typeString = @"退款成功";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else if ([self.listModel.status integerValue] == 7) {
                typeString = @"拒绝退款";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else if ([self.listModel.status integerValue] == 4) {
                typeString = @"已完成";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else {
                typeString = @"退货退款";
            }
        }
    }
    [bottomBtn setTitle:typeString forState:UIControlStateNormal];
    
    [self.view addSubview:bottomBtn];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return self.goodArrs.count;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 90.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 90.0f;
    } else if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 90.0f;
        }
        return 40.0f;
    } else {
        if (indexPath.row == 2) {
            return 110.0f;
        }
        return 40.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.shopNameStirng;
    [view addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.text = @"配送费";
    topLabel.textColor = [UIColor blackColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:topLabel];
    
    UILabel *topRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10, 40)];
    topRightLabel.font = [UIFont systemFontOfSize:13];
    topRightLabel.text = @"￥0";
    topRightLabel.textColor = [UIColor blackColor];
    topRightLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:topRightLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lineView];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 10, 40)];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.text = [NSString stringWithFormat:@"合计 : %.2f",self.totalMoneyString];
    bottomLabel.textColor = [UIColor blackColor];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:bottomLabel];
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            static NSString *ID = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"姓名: %@",self.nameString];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"地址: %@",self.addressString];
            return cell;
        } else {
            static NSString *ID = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"物流方式";
                cell.detailTextLabel.text = self.typeString;
            } else {
                cell.textLabel.text = @"开票单位";
                if (IsStringEmpty(self.companyNameString)) {
                    cell.detailTextLabel.text = @"无需开票";
                } else {
                    cell.detailTextLabel.text = self.companyNameString;
                }
            }
            return cell;
        }
    } else if (indexPath.section == 2) {
        static NSString *ID = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"订单编号";
            cell.detailTextLabel.text = self.orderCodeString;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"支付方式";
            cell.detailTextLabel.text = self.payMentTypeString;
        } else {
            self.businessDescriptionTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
            if (IsStringEmpty(self.orederInfoStirng)) {
                self.businessDescriptionTextView.text = @"暂无备注";
            } else {
                self.businessDescriptionTextView.text = [NSString stringWithFormat:@"备注信息 : %@",self.orederInfoStirng];
            }
            [cell addSubview:self.businessDescriptionTextView];
        }
        return cell;
    }
    FHWatingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHWatingOrderCell class])];
    cell.orderModel = self.goodArrs[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - ZH_SCALE_SCREEN_Height(50)) style:UITableViewStyleGrouped];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] init];
        _businessDescriptionTextView.layer.borderWidth = 1;
        _businessDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"信息备注 备注信息(非必填)";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:0 legth:14]];
        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
}

@end
