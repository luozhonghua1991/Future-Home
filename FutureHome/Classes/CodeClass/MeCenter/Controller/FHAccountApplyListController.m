//
//  FHAccountApplyListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账户申请列表

#import "FHAccountApplyListController.h"
#import "FHBuinessAccountApplicationController.h"
#import "FHLosProtocolModel.h"
#import "FHBuinessAccountApplicationController.h"
#import "FHProprietaryAccountController.h"
#import "FHFreshServiceAccountController.h"
#import "FHNormalBuinsesAccountController.h"
#import "FHMedicinalServiceController.h"

@interface FHAccountApplyListController ()
/** 账号申请按钮 */
@property (nonatomic, strong) UIButton *accountApplyBtn;
/** 标题 */
@property (nonatomic, copy) NSString *titleStr;
/** 提示语label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 提示数组 */
@property (nonatomic, strong) NSMutableArray *tipsArrs;

/** 里面的注释 */
@property (nonatomic, copy) NSString *tips2;
/** 跳转的链接 */
@property (nonatomic, copy) NSString *protocol;
/** 折扣率 */
@property (nonatomic, copy) NSString *discount;
/** 开通物业费价格 */
@property (nonatomic, copy) NSString *open;
/** 折扣价 */
@property (nonatomic, copy) NSString *price;

@end

@implementation FHAccountApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAgreementTip];
}

- (void)getAgreementTip {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",nil];
    
    [AFNetWorkTool get:@"future/getIosprotocol" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.tipsArrs = [[NSMutableArray alloc] init];
            weakSelf.tipsArrs = [FHLosProtocolModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            [weakSelf setDataWithArr:self.tipsArrs];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)setDataWithArr:(NSArray *)arr {
        FHLosProtocolModel *protocolModel;
    if ([self.yp_tabItemTitle isEqualToString:@"商业物业"]) {
        self.titleStr = @"开通商业物业服务平台账户";
        protocolModel = arr[0];
        [self setDataWithModel:protocolModel];
    } else if ([self.yp_tabItemTitle isEqualToString:@"业主账号"]) {
        self.titleStr = @"联合开通业主服务/物业服务平台账户";
        protocolModel = arr[1];
        [self setDataWithModel:protocolModel];
    } else if ([self.yp_tabItemTitle isEqualToString:@"生鲜账号"]) {
        self.titleStr = @"开通生鲜服务平台账户";
        protocolModel = arr[2];
        [self setDataWithModel:protocolModel];
    } else if ([self.yp_tabItemTitle isEqualToString:@"社交电商"]) {
        self.titleStr = @"开通商业服务平台账户";
        protocolModel = arr[3];
        [self setDataWithModel:protocolModel];
    } else if ([self.yp_tabItemTitle isEqualToString:@"企业账号"]) {
        self.titleStr = @"开通企业服务平台账户";
        protocolModel = arr[4];
        [self setDataWithModel:protocolModel];
    }
    
    self.accountApplyBtn.frame = CGRectMake(0, 200, 350, 50);
    self.accountApplyBtn.centerX = self.view.width / 2;
    [self.view addSubview:self.accountApplyBtn];
    [self.view addSubview:self.logoLabel];
}

- (void)setDataWithModel:(FHLosProtocolModel *)protocolModel {
    self.logoLabel.text = protocolModel.tip1;
    CGSize szie = [UIlabelTool sizeWithString:protocolModel.tip1 font:self.logoLabel.font];
    self.logoLabel.frame = CGRectMake(20, SCREEN_HEIGHT - 140 - szie.height, SCREEN_WIDTH - 40, szie.height);
    self.tips2 = protocolModel.tip2;
    self.protocol = protocolModel.protocol;
    self.discount = protocolModel.discount;
    self.open = protocolModel.open;
    self.price = protocolModel.price;
}


#pragma mark — event
- (void)accountApplyBtnClick {
    if ([self.yp_tabItemTitle isEqualToString:@"商业物业"]) {
        FHBuinessAccountApplicationController *vc = [[FHBuinessAccountApplicationController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.yp_tabItemTitle isEqualToString:@"业主账号"]) {
        FHProprietaryAccountController *vc = [[FHProprietaryAccountController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.yp_tabItemTitle isEqualToString:@"生鲜账号"]) {
        FHFreshServiceAccountController *vc = [[FHFreshServiceAccountController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.yp_tabItemTitle isEqualToString:@"社交电商"]) {
        FHNormalBuinsesAccountController *vc = [[FHNormalBuinsesAccountController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.yp_tabItemTitle isEqualToString:@"企业账号"]) {
        FHMedicinalServiceController *vc = [[FHMedicinalServiceController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark — setter && getter
- (UIButton *)accountApplyBtn {
    if (!_accountApplyBtn) {
        _accountApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountApplyBtn setTitle:self.titleStr forState:UIControlStateNormal];
        [_accountApplyBtn addTarget:self action:@selector(accountApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _accountApplyBtn.backgroundColor = HEX_COLOR(0x1296db);
        _accountApplyBtn.layer.cornerRadius = 5;
        _accountApplyBtn.layer.masksToBounds = YES;
        _accountApplyBtn.clipsToBounds = YES;
    }
    return _accountApplyBtn;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 240, SCREEN_WIDTH - 40, 100)];
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:14];
        _logoLabel.numberOfLines = 0;
        _logoLabel.textColor = HEX_COLOR(0x5E5E5E);
    }
    return _logoLabel;
}

@end
