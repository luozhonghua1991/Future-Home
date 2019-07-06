//
//  FHBusinessServicesController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商业服务

#import "FHBusinessServicesController.h"
#import "FHFollowListController.h"
#import "FHSearchBelowController.h"
#import "FHSearchCategoryController.h"
#import "FHMessageHistoryController.h"

@interface FHBusinessServicesController ()

@end

@implementation FHBusinessServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHFollowListController *videosVC = [[FHFollowListController alloc] init];
    videosVC.yp_tabItemTitle = @"关注列表";
    
    FHSearchBelowController *photoVC = [[FHSearchBelowController alloc] init];
    photoVC.yp_tabItemTitle = @"查找附近";
    
//    FHSearchCategoryController *followVC = [[FHSearchCategoryController alloc] init];
//    followVC.yp_tabItemTitle = @"分类查找";
//
//    FHMessageHistoryController *friendVC = [[FHMessageHistoryController alloc] init];
//    friendVC.yp_tabItemTitle = @"对话记录";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:videosVC, photoVC, nil];
    
}


@end
