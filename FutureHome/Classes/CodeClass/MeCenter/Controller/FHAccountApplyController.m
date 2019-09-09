//
//  FHAccountApplyController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账号申请

#import "FHAccountApplyController.h"
#import "FHAccountApplyListController.h"

@interface FHAccountApplyController ()

@end

@implementation FHAccountApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatSelectView];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"开通账户";
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

- (void)fh_creatSelectView {
    [self setTabBarFrame:CGRectMake(0, MainSizeHeight , SCREEN_WIDTH, 35)
        contentViewFrame:CGRectMake(0, MainSizeHeight + 35 , SCREEN_WIDTH, SCREEN_HEIGHT  - 35 - MainSizeHeight)];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = HEX_COLOR(0x1296db);
    self.tabBar.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.tabBar.itemTitleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.tabBar.itemSelectedBgColor = HEX_COLOR(0x1296db);
    if (KIsiPhoneX) {
        [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(33, 33, 0, 33) tapSwitchAnimated:YES];
    } else {
        [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(33, 31, 0, 31) tapSwitchAnimated:YES];
    }
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.tabBar addSubview:bottomLine];
    [self initViewControllers];
}

- (void)initViewControllers {
    FHAccountApplyListController *messageVC = [[FHAccountApplyListController alloc] init];
    messageVC.yp_tabItemTitle = @"商业物业";
    
    FHAccountApplyListController *groupVC = [[FHAccountApplyListController alloc] init];
    groupVC.yp_tabItemTitle = @"业主账号";
    
    FHAccountApplyListController *hotVC = [[FHAccountApplyListController alloc] init];
    hotVC.yp_tabItemTitle = @"生鲜账号";
    
    FHAccountApplyListController *friendVC = [[FHAccountApplyListController alloc] init];
    friendVC.yp_tabItemTitle = @"商业账号";
    
    FHAccountApplyListController *followVC = [[FHAccountApplyListController alloc] init];
    followVC.yp_tabItemTitle = @"医药账号";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,friendVC,followVC, nil];
}

@end
