//
//  FHSafeController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  安全消防

#import "FHSafeController.h"
#import "FHBaseAnnouncementListController.h"

@interface FHSafeController ()

@end

@implementation FHSafeController

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
    titleLabel.text = @"安保消防";
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
    FHBaseAnnouncementListController *messageVC = [[FHBaseAnnouncementListController alloc] init];
    messageVC.yp_tabItemTitle = @"监控检查";
    messageVC.webTitleString = @"监控检查";
    messageVC.isHaveSelectView = YES;
    messageVC.type = 1;
    messageVC.ID = 5;
    messageVC.property_id = self.property_id;
    
    FHBaseAnnouncementListController *groupVC = [[FHBaseAnnouncementListController alloc] init];
    groupVC.yp_tabItemTitle = @"安全巡逻";
    groupVC.webTitleString = @"安全巡逻";
    groupVC.isHaveSelectView = YES;
    groupVC.type = 1;
    groupVC.ID = 6;
    groupVC.property_id = self.property_id;
    
    FHBaseAnnouncementListController *hotVC = [[FHBaseAnnouncementListController alloc] init];
    hotVC.yp_tabItemTitle = @"突发应急";
    hotVC.webTitleString = @"突发应急";
    hotVC.isHaveSelectView = YES;
    hotVC.type = 1;
    hotVC.ID = 7;
    hotVC.property_id = self.property_id;
    
    FHBaseAnnouncementListController *safeVC = [[FHBaseAnnouncementListController alloc] init];
    safeVC.yp_tabItemTitle = @"消防管理";
    safeVC.webTitleString = @"消防管理";
    safeVC.isHaveSelectView = YES;
    safeVC.type = 1;
    safeVC.ID = 8;
    safeVC.property_id = self.property_id;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,safeVC, nil];
}


@end
