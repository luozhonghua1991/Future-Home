//
//  FHPersonTrendsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  用户动态界面

#import "FHPersonTrendsController.h"
#import "FHCircleHotPointController.h"
#import "FHMyVideosController.h"
#import "FHMyPhotoController.h"
#import "FHMyVideosController.h"
#import "FHFriendLisController.h"

@interface FHPersonTrendsController ()

@end

@implementation FHPersonTrendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self fh_creatSelectView];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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
    [SingleManager shareManager].isSelectPerson = NO;
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
    FHCircleHotPointController *hotVC = [[FHCircleHotPointController alloc] init];
    hotVC.yp_tabItemTitle = @"云动态";
    hotVC.isHaveHeaderView = YES;
    hotVC.personType = self.personType;
    hotVC.personID = self.user_id;
    
    FHMyVideosController *photoVC = [[FHMyVideosController alloc] init];
    photoVC.yp_tabItemTitle = @"视频";
    photoVC.user_id = self.user_id;
    
    FHMyPhotoController *followVC = [[FHMyPhotoController alloc] init];
    followVC.yp_tabItemTitle = @"相册";
    followVC.user_id = self.user_id;
    
    FHFriendLisController *follow1VC = [[FHFriendLisController alloc] init];
    follow1VC.yp_tabItemTitle = @"关注";
    follow1VC.user_id = self.user_id;
    
    FHFriendLisController *fansVC = [[FHFriendLisController alloc] init];
    fansVC.yp_tabItemTitle = @"粉丝";
    fansVC.user_id = self.user_id;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:hotVC, photoVC,followVC,follow1VC,fansVC, nil];
}

@end
