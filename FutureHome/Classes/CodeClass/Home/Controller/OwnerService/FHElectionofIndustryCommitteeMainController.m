//
//  FHElectionofIndustryCommitteeMainController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  业委选举界面

#import "FHElectionofIndustryCommitteeMainController.h"
#import "FHBaseAnnouncementListController.h"

@interface FHElectionofIndustryCommitteeMainController ()

@end

@implementation FHElectionofIndustryCommitteeMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViewControllers {
    FHBaseAnnouncementListController *messageVC = [[FHBaseAnnouncementListController alloc] init];
    messageVC.yp_tabItemTitle = @"选举管理";
//    messageVC.isNoHaveHeaderView = YES;
    messageVC.isHaveSelectView = YES;
    
    messageVC.property_id = self.property_id;
    messageVC.type = 2;
    messageVC.ID = 5;
    
    FHBaseAnnouncementListController *groupVC = [[FHBaseAnnouncementListController alloc] init];
    groupVC.yp_tabItemTitle = @"申请通道";
//    groupVC.isNoHaveHeaderView = YES;
    groupVC.isHaveSelectView = YES;
    groupVC.isHaveSectionView = YES;
    
    groupVC.property_id = self.property_id;
    groupVC.type = 2;
    groupVC.ID = 6;
    
    FHBaseAnnouncementListController *hotVC = [[FHBaseAnnouncementListController alloc] init];
    hotVC.yp_tabItemTitle = @"业委海选";
//    hotVC.isNoHaveHeaderView = YES;
    hotVC.isHaveSelectView = YES;
    hotVC.isHaveSectionView = YES;
    
    hotVC.property_id = self.property_id;
    hotVC.type = 2;
    hotVC.ID = 7;
    
    FHBaseAnnouncementListController *hoVC = [[FHBaseAnnouncementListController alloc] init];
    hoVC.yp_tabItemTitle = @"岗位选举";
//    hoVC.isNoHaveHeaderView = YES;
    hoVC.isHaveSelectView = YES;
    hoVC.isHaveSectionView = YES;
    
    hoVC.property_id = self.property_id;
    hoVC.type = 2;
    hoVC.ID = 8;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,hoVC, nil];
}

@end
