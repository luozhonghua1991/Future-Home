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
    messageVC.webTitleString = @"儿童心理健康";
    messageVC.isHaveSelectView = YES;
    messageVC.type = self.type;
    messageVC.ID = 1;
    
    FHBaseAnnouncementListController *groupVC = [[FHBaseAnnouncementListController alloc] init];
    groupVC.yp_tabItemTitle = @"青少年心理健康";
    groupVC.webTitleString = @"青少年心理健康";
    groupVC.isHaveSelectView = YES;
    groupVC.type = self.type;
    groupVC.ID = 2;
    
    FHBaseAnnouncementListController *hotVC = [[FHBaseAnnouncementListController alloc] init];
    hotVC.yp_tabItemTitle = @"成年人心理健康";
    hotVC.webTitleString = @"成年人心理健康";
    hotVC.isHaveSelectView = YES;
    hotVC.type = self.type;
    hotVC.ID = 3;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
