//
//  FHMentalHealthController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  心理健康界面

#import "FHMentalHealthController.h"

@implementation FHMentalHealthController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHBaseAnnouncementListController *messageVC = [[FHBaseAnnouncementListController alloc] init];
    messageVC.yp_tabItemTitle = @"儿童心理健康";
    messageVC.isHaveSelectView = YES;
    
    FHBaseAnnouncementListController *groupVC = [[FHBaseAnnouncementListController alloc] init];
    groupVC.yp_tabItemTitle = @"青少年心理健康";
    groupVC.isHaveSelectView = YES;
    
    FHBaseAnnouncementListController *hotVC = [[FHBaseAnnouncementListController alloc] init];
    hotVC.yp_tabItemTitle = @"成年人心理健康";
    hotVC.isHaveSelectView = YES;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
