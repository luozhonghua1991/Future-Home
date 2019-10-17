//
//  FHAccountApplyListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账户申请列表

#import "FHAccountApplyListController.h"
#import "FHBuinessAccountApplicationController.h"

@interface FHAccountApplyListController ()
/** 账号申请按钮 */
@property (nonatomic, strong) UIButton *accountApplyBtn;
/** 标题 */
@property (nonatomic, copy) NSString *titleStr;
/** 提示语label */
@property (nonatomic, strong) UILabel *logoLabel;

@end

@implementation FHAccountApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.yp_tabItemTitle isEqualToString:@"商业物业"]) {
        self.titleStr = @"开通商业物业服务平台账户";
    } else if ([self.yp_tabItemTitle isEqualToString:@"业主账号"]) {
        self.titleStr = @"联合开通社区服务/物业服务平台账户";
    } else if ([self.yp_tabItemTitle isEqualToString:@"生鲜账号"]) {
        self.titleStr = @"开通生鲜服务平台账户";
    } else if ([self.yp_tabItemTitle isEqualToString:@"商业账号"]) {
        self.titleStr = @"开通商业服务平台账户";
    } else if ([self.yp_tabItemTitle isEqualToString:@"医药账号"]) {
        self.titleStr = @"开通医药药品服务平台账户";
    }
    self.accountApplyBtn.frame = CGRectMake(0, 200, 350, 50);
    self.accountApplyBtn.centerX = self.view.width / 2;
    [self.view addSubview:self.accountApplyBtn];
    [self.view addSubview:self.logoLabel];
}


#pragma mark — event
- (void)accountApplyBtnClick {
    if ([self.yp_tabItemTitle isEqualToString:@"商业物业"]) {
        [self viewControllerPushOther:@"FHBuinessAccountApplicationController"];
    } else if ([self.yp_tabItemTitle isEqualToString:@"业主账号"]) {
        [self viewControllerPushOther:@"FHProprietaryAccountController"];
    } else if ([self.yp_tabItemTitle isEqualToString:@"生鲜账号"]) {
        [self viewControllerPushOther:@"FHFreshServiceAccountController"];
    } else if ([self.yp_tabItemTitle isEqualToString:@"商业账号"]) {
        [self viewControllerPushOther:@"FHNormalBuinsesAccountController"];
    } else if ([self.yp_tabItemTitle isEqualToString:@"医药账号"]) {
        [self viewControllerPushOther:@"FHMedicinalServiceController"];
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
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 225, SCREEN_WIDTH, 13)];
        _logoLabel.textAlignment = NSTextAlignmentCenter;
        _logoLabel.font = [UIFont systemFontOfSize:13];
        _logoLabel.text = @"账号管理平台PC端登录网址：http://182.61.48.137/";
        _logoLabel.textColor = [UIColor lightGrayColor];
    }
    return _logoLabel;
}

@end
