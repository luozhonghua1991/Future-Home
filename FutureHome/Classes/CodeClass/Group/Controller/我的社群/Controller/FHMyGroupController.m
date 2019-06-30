//
//  FHMyGroupController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved
//  我的社群

#import "FHMyGroupController.h"

@interface FHMyGroupController ()

@end

@implementation FHMyGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self setTabBarFrame:CGRectMake(0, 44 , SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 44 + 44 , SCREEN_WIDTH, SCREEN_HEIGHT  - 44 - 44)];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor blueColor];
    self.tabBar.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.tabBar.itemTitleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    if (KIsiPhoneX) {
        [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 33, 0, 33) tapSwitchAnimated:YES];
    } else {
        [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 31, 0, 31) tapSwitchAnimated:YES];
    }
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    [self initViewControllers];
}

- (void)initViewControllers {
    
//    RWColumnTypeController *controller1 = [[RWColumnTypeController alloc] init];
//    controller1.yp_tabItemTitle = @"DOTA2";
//
//    RWColumnTypeController *controller4 = [[RWColumnTypeController alloc] init];
//    controller4.yp_tabItemTitle = @"CSGO";
//    controller4.gameID = 2;
//
//    RWColumnTypeController *controller5 = [[RWColumnTypeController alloc] init];
//    controller5.yp_tabItemTitle = @"LOL";
//    controller5.gameID = 3;
//
//    RWColumnTypeController *controller6 = [[RWColumnTypeController alloc] init];
//    controller6.yp_tabItemTitle = @"王者荣耀";
//    controller6.gameID = 4;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller3, controller4,controller5,controller6, nil];
    
}


@end
