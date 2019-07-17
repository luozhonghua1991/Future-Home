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


@end

@implementation FHAccountApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.yp_tabItemTitle isEqualToString:@"商业物业申请"]) {
        self.titleStr = @"进入申请商业物业服务平台账号";
    } else if ([self.yp_tabItemTitle isEqualToString:@"业主账号申请"]) {
        self.titleStr = @"进入联合申请业委服务/物业服务平台账号";
    } else if ([self.yp_tabItemTitle isEqualToString:@"生鲜账号申请"]) {
        self.titleStr = @"进入申请生鲜服务平台账号";
    } else if ([self.yp_tabItemTitle isEqualToString:@"商业账号申请"]) {
        self.titleStr = @"进入申请商业服务平台账号";
    } else if ([self.yp_tabItemTitle isEqualToString:@"医药账号申请"]) {
        self.titleStr = @"进入申请医药药品服务平台账号";
    }
    self.accountApplyBtn.frame = CGRectMake(0, 200, 350, 50);
    self.accountApplyBtn.centerX = self.view.width / 2;
    [self.view addSubview:self.accountApplyBtn];
}


#pragma mark — event
- (void)accountApplyBtnClick {
    if ([self.yp_tabItemTitle isEqualToString:@"商业物业申请"]) {
        FHBuinessAccountApplicationController *account = [[FHBuinessAccountApplicationController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    } else if ([self.yp_tabItemTitle isEqualToString:@"业主账号申请"]) {
//        account.accountType = @"";
    } else if ([self.yp_tabItemTitle isEqualToString:@"生鲜账号申请"]) {
//        account.accountType = @"";
    } else if ([self.yp_tabItemTitle isEqualToString:@"商业账号申请"]) {
//       account.accountType = @"";
    } else if ([self.yp_tabItemTitle isEqualToString:@"医药账号申请"]) {
//        account.accountType = @"";
    }
    
    
}


#pragma mark — setter && getter
- (UIButton *)accountApplyBtn {
    if (!_accountApplyBtn) {
        _accountApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountApplyBtn setTitle:self.titleStr forState:UIControlStateNormal];
        [_accountApplyBtn addTarget:self action:@selector(accountApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _accountApplyBtn.backgroundColor = [UIColor redColor];
    }
    return _accountApplyBtn;
}
@end
