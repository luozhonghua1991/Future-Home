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
    
    FHBaseAnnouncementListController *groupVC = [[FHBaseAnnouncementListController alloc] init];
    groupVC.yp_tabItemTitle = @"申请通道";
//    groupVC.isNoHaveHeaderView = YES;
    groupVC.isHaveSelectView = YES;
    groupVC.isHaveSectionView = YES;
    
    FHBaseAnnouncementListController *hotVC = [[FHBaseAnnouncementListController alloc] init];
    hotVC.yp_tabItemTitle = @"业委海选";
//    hotVC.isNoHaveHeaderView = YES;
    hotVC.isHaveSelectView = YES;
    hotVC.isHaveSectionView = YES;
    
    FHBaseAnnouncementListController *hoVC = [[FHBaseAnnouncementListController alloc] init];
    hoVC.yp_tabItemTitle = @"岗位选举";
//    hoVC.isNoHaveHeaderView = YES;
    hoVC.isHaveSelectView = YES;
    hoVC.isHaveSectionView = YES;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,hoVC, nil];
}

@end
