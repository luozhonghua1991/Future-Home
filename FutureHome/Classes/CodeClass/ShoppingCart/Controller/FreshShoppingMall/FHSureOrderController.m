//
//  FHSureOrderController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/17
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHSureOrderController.h"
#import "FHWatingOrderCell.h"
#import "HYJFAddressAdministrationController.h"
#import "FHInvoiceListController.h"
#import "BRPlaceholderTextView.h"
#import "FHInvoiceListController.h"
#import "HYJFAddressAdministrationController.h"

@interface FHSureOrderController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 物流label */
@property (nonatomic, strong) UILabel *logisticsLabel;
/** 支付方式label */
@property (nonatomic, strong) UILabel *payTypeLabel;
/** 发票label */
@property (nonatomic, strong) UILabel *invoiceLabel;
/** 地址label */
@property (nonatomic, strong) UILabel *addressLabel;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL isSelectBtn;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL isSelectAddress;
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;

@end

@implementation FHSureOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelectBtn = NO;
    [self fh_creatNav];
    [self creatBottomBtn];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHWatingOrderCell class] forCellReuseIdentifier:NSStringFromClass([FHWatingOrderCell class])];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"确认订单";
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
    UIView *whiteBttomView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50))];
    [self.view addSubview:whiteBttomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [whiteBttomView addSubview:lineView];
    
    UILabel *allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 150, ZH_SCALE_SCREEN_Height(50))];
    allPriceLabel.font = [UIFont systemFontOfSize:14];
    allPriceLabel.text = @"支付金额: ￥145";
    allPriceLabel.textColor = [UIColor redColor];
    allPriceLabel.textAlignment = NSTextAlignmentLeft;
    [whiteBttomView addSubview:allPriceLabel];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(SCREEN_WIDTH - 150,0, 150, ZH_SCALE_SCREEN_Height(50));
    bottomBtn.backgroundColor = [UIColor redColor];
    [bottomBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [completedBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBttomView addSubview:bottomBtn];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 5;
    } else {
        return 2;
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
        return 40.0f;
    } else {
        if (indexPath.row == 0) {
            return 40.0f;
        } else {
            return 100.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.row ==0) {
            cell.textLabel.text = @"物流方式";
            cell.detailTextLabel.text = @"请选择物流方式 >";
            self.logisticsLabel = cell.detailTextLabel;
        } else if (indexPath.row ==1) {
            cell.textLabel.text = @"是否开票";
            UISwitch *selectSeitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/375*48, SCREEN_HEIGHT/667*30)];
            [selectSeitch setOn:self.isSelectBtn animated:NO];
            cell.accessoryView = selectSeitch;
            [selectSeitch addTarget:self action:@selector(selectSeitchOnClick) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row ==2) {
            cell.textLabel.text = @"开票单位";
            cell.detailTextLabel.text = @"请选择开票单位 >";
            self.invoiceLabel = cell.detailTextLabel;
        } else {
            cell.textLabel.text = @"收货地址";
            cell.detailTextLabel.text = @"请选择收货地址 >";
            self.addressLabel = cell.detailTextLabel;
        }
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *ID = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支付方式";
            cell.detailTextLabel.text = @"请选择支付方式 >";
        } else {
            self.businessDescriptionTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
            [cell addSubview:self.businessDescriptionTextView];
        }
        return cell;
    }
    FHWatingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHWatingOrderCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  多选按钮控制
 */
- (void)selectSeitchOnClick {
    self.isSelectBtn = !self.isSelectBtn;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"未来生鲜-龙湖U城店";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
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
    topRightLabel.text = @"￥10";
    topRightLabel.textColor = [UIColor blackColor];
    topRightLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:topRightLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lineView];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 10, 40)];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.text = @"合计 : 370";
    bottomLabel.textColor = [UIColor blackColor];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:bottomLabel];
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [ZJNormalPickerView zj_showStringPickerWithTitle:@"物流方式" dataSource:@[@"快递到家",@"预定前往",@"实时配送"] defaultSelValue:@"" isAutoSelect: NO resultBlock:^(id selectValue, NSInteger index) {
                NSLog(@"index---%ld",index);
                self.logisticsLabel.text = selectValue;
                if ([selectValue isEqualToString:@"预定前往"]) {
                    self.isSelectAddress = NO;
                } else {
                    self.isSelectAddress = YES;
                }
            } cancelBlock:^{
                
            }];
        }
        if (indexPath.row == 3) {
            /** 地址选择 */
            if (!self.isSelectAddress) {
                [self.view makeToast:@"你不能进行选择地址"];
                return;
            }
            HYJFAddressAdministrationController *vx = [[HYJFAddressAdministrationController alloc] init];
            vx.isHaveNavBar = YES;
            vx.hidesBottomBarWhenPushed = YES;
            vx.selectResultBlock = ^(HYJFAllAddressModel * _Nonnull addressModel) {
                self.addressLabel.text = addressModel.address;
            };
            [self.navigationController pushViewController:vx animated:YES];
        } else if (indexPath.row == 2) {
            if (!self.isSelectBtn) {
                [self.view makeToast:@"你不能进行选择发票"];
                return;
            }
            /** 发票选择 */
            FHInvoiceListController *vx = [[FHInvoiceListController alloc] init];
            vx.isHaveNavBar = YES;
            vx.hidesBottomBarWhenPushed = YES;
            vx.selectResultBlock = ^(FHInvoiceModel * _Nonnull invoiceModel) {
                self.invoiceLabel.text = invoiceModel.companyname;
            };
            [self.navigationController pushViewController:vx animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [ZJNormalPickerView zj_showStringPickerWithTitle:@"支付方式" dataSource:@[@"微信支付",@"支付宝支付"] defaultSelValue:@"" isAutoSelect: NO resultBlock:^(id selectValue, NSInteger index) {
                NSLog(@"index---%ld",index);
                self.payTypeLabel.text = selectValue;
            } cancelBlock:^{
                
            }];
        } else {
            
        }
    }
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
