//
//  FHMainCertificationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/20.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHMainCertificationController.h"

@interface FHMainCertificationController ()

/** 审核的状态 0 未实名 1未通过 2待审核 3已实名认证*/
@property (nonatomic, assign) NSInteger statues;
/** 状态按钮 */
@property (nonatomic, strong) UIButton *statuesBtn;


@end

@implementation FHMainCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               nil];
    [AFNetWorkTool get:@"userCenter/isRealname" params:paramsDic success:^(id responseObj) {
        /** data 0 未实名 1未通过 2待审核 3已实名认证 */
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.statues = [responseObj[@"data"] integerValue];
            [self creatBtn];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"实名认证";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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

- (void)creatBtn {
    /** 0 未实名 1未通过 2待审核 3已实名认证 */
    if (self.statues == 0) {
        [self.statuesBtn setTitle:@"未实名认证,点击去认证" forState:UIControlStateNormal];
    } else if (self.statues == 1) {
        [self.statuesBtn setTitle:@"实名认证未通过,请再次提交" forState:UIControlStateNormal];
    } else if (self.statues == 2) {
        [self.statuesBtn setTitle:@"实名认证审核中" forState:UIControlStateNormal];
    } else if (self.statues == 3) {
        [self.statuesBtn setTitle:@"已通过实名认证" forState:UIControlStateNormal];
    }
    [self.view addSubview:self.statuesBtn];
}

- (void)statuesBtnClick {
    if (self.statues == 0) {
         [self viewControllerPushOther:@"FHCertificationController"];
    } else if (self.statues == 1) {
         [self viewControllerPushOther:@"FHCertificationController"];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark — setter && getter
- (UIButton *)statuesBtn {
    if (!_statuesBtn) {
        _statuesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statuesBtn.frame = CGRectMake(30, SCREEN_HEIGHT / 2, SCREEN_WIDTH - 60, 50);
        _statuesBtn.backgroundColor = HEX_COLOR(0x1296db);
        [_statuesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_statuesBtn addTarget:self action:@selector(statuesBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statuesBtn;
}

@end
