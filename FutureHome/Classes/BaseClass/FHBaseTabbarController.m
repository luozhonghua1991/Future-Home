//
//  FHBaseTabbarController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  翻页效果的基类VC
#import "FHBaseTabbarController.h"

@interface FHBaseTabbarController ()

@end

@implementation FHBaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self setTabBarFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 44)
        contentViewFrame:CGRectMake(0, 0 + 44 , SCREEN_WIDTH, SCREEN_HEIGHT  - 44)];
    self.tabBar.backgroundColor = [UIColor greenColor];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor blueColor];
    self.tabBar.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
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
    
}

@end
