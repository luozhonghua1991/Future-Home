//
//  FHDecorationAndMaintenanceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  装修维修

#import "FHDecorationAndMaintenanceController.h"

@interface FHDecorationAndMaintenanceController ()

@end

@implementation FHDecorationAndMaintenanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViewControllers {
    FHBaseAnnouncementListController *messageVC = [[FHBaseAnnouncementListController alloc] init];
    messageVC.yp_tabItemTitle = @"装修须知";
    messageVC.isHaveSelectView = YES;
    
    messageVC.type = 1;
    messageVC.property_id = self.property_id;
    messageVC.ID = 13;
    
    FHBaseAnnouncementListController *groupVC = [[FHBaseAnnouncementListController alloc] init];
    groupVC.yp_tabItemTitle = @"维修须知";
    groupVC.isHaveSelectView = YES;
    
    groupVC.type = 1;
    groupVC.property_id = self.property_id;
    groupVC.ID = 14;
    
    FHBaseAnnouncementListController *hotVC = [[FHBaseAnnouncementListController alloc] init];
    hotVC.yp_tabItemTitle = @"搬家须知";
    hotVC.isHaveSelectView = YES;
    
    hotVC.type = 1;
    hotVC.property_id = self.property_id;
    hotVC.ID = 15;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
