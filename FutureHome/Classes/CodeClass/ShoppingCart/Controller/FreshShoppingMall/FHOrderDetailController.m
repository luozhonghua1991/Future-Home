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
#import "FHReturnRefundController.h"
#import "FHGoodsCommitController.h"
#import "FHCommonPaySelectView.h"
#import "FHAppDelegate.h"
#import "LeoPayManager.h"

@interface FHOrderDetailController () <UITableViewDelegate,UITableViewDataSource,FHCommonPaySelectViewDelegate>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 手机号码 */
@property (nonatomic, copy) NSString *phoneString;
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
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommonPaySelectView *payView;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger payType;
/** 下单时间 */
@property (nonatomic, copy) NSString *add_time;
/** 支付时间 */
@property (nonatomic, copy) NSString *pay_time;

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
                               self.order_id,@"order_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool get:@"shop/getSingOrder" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.add_time = responseObj[@"data"][@"add_time"];
            weakSelf.pay_time = responseObj[@"data"][@"pay_time"];
            weakSelf.phoneString = responseObj[@"data"][@"buyphone"];
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
    [bottomBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *typeString;
    if (self.status == 1) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        cancelBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH / 2 - 1, ZH_SCALE_SCREEN_Height(50));
        cancelBtn.backgroundColor = HEX_COLOR(0x1296db);
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.view addSubview:cancelBtn];
        
        typeString = @"待付款";
        bottomBtn.frame = CGRectMake(MaxX(cancelBtn) + 1 ,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH / 2, ZH_SCALE_SCREEN_Height(50));
        
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
                typeString = @"退款成功，款项已原路退回";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else if ([self.listModel.status integerValue] == 7) {
                typeString = @"退款失败，原因证据理由不合理";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else if ([self.listModel.status integerValue] == 4) {
                typeString = @"订单已完成";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else if ([self.listModel.status integerValue] == 5) {
                typeString = @"退款申请中，待商家确认";
                [bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
            } else {
                typeString = @"申请退款";
            }
        }
    }
    [bottomBtn setTitle:typeString forState:UIControlStateNormal];
    
    [self.view addSubview:bottomBtn];
}

/** 取消订单 */
- (void)cancelBtnClick {
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定要取消订单吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            /** 确定删除 */
            [weakSelf cancelOrderWithRequest];
        }
    }];
}

- (void)cancelOrderWithRequest {
    /** 取消订单 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.listModel.id,@"order_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool post:@"shop/cancelOrder" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"取消订单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


/** 确认收货 */
- (void)addInvoiceBtnClick {
    if (self.status == 2) {
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确认收货吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 确认收货 */
                WS(weakSelf);
                Account *account = [AccountStorage readAccount];
                NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @(account.user_id),@"user_id",
                                           weakSelf.listModel.id,@"order_id",
                                           [SingleManager shareManager].ordertype,@"ordertype",nil];
                [AFNetWorkTool post:@"shop/confirmgoods" params:paramsDic success:^(id responseObj) {
                    if ([responseObj[@"code"] integerValue] == 1) {
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [weakSelf.view makeToast:responseObj[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [weakSelf.homeTable reloadData];
                }];
            }
        }];
    } else if (self.status == 4) {
        /** 退货退款操作 */
        if ([self.listModel.status integerValue] >= 2) {
            if ([self.listModel.status isEqualToString:@"6"]||
                [self.listModel.status isEqualToString:@"7"]||
                [self.listModel.status isEqualToString:@"4"]||
                [self.listModel.status isEqualToString:@"5"]) {
            } else {
                /** 退货退款操作 */
                FHReturnRefundController *vc = [[FHReturnRefundController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.orderID = self.listModel.id;
                vc.totolePrice = [NSString stringWithFormat:@"￥%.2f",[self.listModel.pay_money floatValue]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else if (self.status == 3) {
        if ([self.listModel.iscomment isEqualToString:@"0"]) {
            FHGoodsCommitController *commit = [[FHGoodsCommitController alloc] init];
            commit.hidesBottomBarWhenPushed = YES;
            commit.orderID = self.listModel.id;
            [self.navigationController pushViewController:commit animated:YES];
        }
    } else if (self.status == 1) {
        /** 代付款 */
        [self creatPayViewWithPrice:self.listModel.pay_money];
        [self showPayView];
    }
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak FHOrderDetailController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
}

- (void)creatPayViewWithPrice:(NSString *)price {
    if (!self.payView) {
        self.payView = [[FHCommonPaySelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260) andNSString:[NSString stringWithFormat:@"在线支付支付价格为:￥%@",self.listModel.pay_money]];
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
                               self.listModel.id,@"order_id",
                               @(self.payType),@"pay_way",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    
    [AFNetWorkTool post:@"shop/orderPaid" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if ([responseObj[@"data"][@"type"] integerValue] == 1) {
                /** 支付宝支付 */
                if ([responseObj[@"data"][@"code"] integerValue] == 1) {
                    if (weakSelf.payType == 1) {
                        /** 支付宝支付 */
                        LeoPayManager *manager = [LeoPayManager getInstance];
                        [manager aliPayOrder: responseObj[@"data"][@"alipay"] scheme:@"alisdkdemo" respBlock:^(NSInteger respCode, NSString *respMsg) {
                            if (respCode == 0) {
                                /** 支付成功 */
                                WS(weakSelf);
                                [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"购买成功" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
                            } else {
                                [self.view makeToast:respMsg];
                            }
                        }];
                    }
                } else {
                    [self.view makeToast:responseObj[@"data"][@"msg"]];
                }
            } else if ([responseObj[@"data"][@"type"] integerValue] == 2) {
                /** 微信支付 */
                if ([responseObj[@"data"][@"code"] integerValue] == 1) {
                    LeoPayManager *manager = [LeoPayManager getInstance];
                    [manager wechatPayWithAppId:responseObj[@"data"][@"weixin"][@"appid"] partnerId:responseObj[@"data"][@"weixin"][@"partnerid"] prepayId:responseObj[@"data"][@"weixin"][@"prepay_id"] package:responseObj[@"data"][@"weixin"][@"package"] nonceStr:responseObj[@"data"][@"weixin"][@"nonce_str"] timeStamp:responseObj[@"data"][@"weixin"][@"timestamp"] sign:responseObj[@"data"][@"weixin"][@"sign"] respBlock:^(NSInteger respCode, NSString *respMsg) {
                        //处理支付结果
                        if (respCode == 0) {
                            /** 支付成功 */
                            WS(weakSelf);
                            [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"购买成功" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        } else {
                            [self.view makeToast:respMsg];
                        }
                    }];
                } else {
                    [self.view makeToast:responseObj[@"data"][@"msg"]];
                }
            }
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
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
        if (self.status == 1) {
            return 4;
        } else {
            return 5;
        }
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
        if (self.status == 1) {
            if (indexPath.row == 3) {
                return 110.0f;
            } else {
                return 40.0f;
            }
        } else {
            if (indexPath.row == 4) {
                return 110.0f;
            } else {
                return 40.0f;
            }
        }
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
            cell.textLabel.text = [NSString stringWithFormat:@"姓名: %@                                      %@",self.nameString,self.phoneString];
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
        if (self.status == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"下单时间";
                cell.detailTextLabel.text = self.add_time;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"订单编号";
                cell.detailTextLabel.text = self.orderCodeString;
            } else if (indexPath.row == 2) {
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
        } else {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"下单时间";
                cell.detailTextLabel.text = self.add_time;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"订单编号";
                cell.detailTextLabel.text = self.orderCodeString;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"支付方式";
                cell.detailTextLabel.text = self.payMentTypeString;
            }  else if (indexPath.row == 3) {
                cell.textLabel.text = @"支付时间";
                cell.detailTextLabel.text = self.pay_time;
            } else {
                self.businessDescriptionTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
                if (IsStringEmpty(self.orederInfoStirng)) {
                    self.businessDescriptionTextView.text = @"暂无备注";
                } else {
                    self.businessDescriptionTextView.text = [NSString stringWithFormat:@"备注信息 : %@",self.orederInfoStirng];
                }
                [cell addSubview:self.businessDescriptionTextView];
            }
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
        _businessDescriptionTextView.font = [UIFont systemFontOfSize:15];
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
