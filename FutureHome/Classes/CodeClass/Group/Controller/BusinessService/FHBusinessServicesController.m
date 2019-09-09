//
//  FHBusinessServicesController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商业服务

#import "FHBusinessServicesController.h"
#import "FHCollectListViewController.h"
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
    FHCollectListViewController *videosVC = [[FHCollectListViewController alloc] init];
    videosVC.yp_tabItemTitle = @"生鲜收藏";
    
    FHCollectListViewController *videos1VC = [[FHCollectListViewController alloc] init];
    videos1VC.yp_tabItemTitle = @"商业收藏";
    
    FHCollectListViewController *videos2VC = [[FHCollectListViewController alloc] init];
    videos2VC.yp_tabItemTitle = @"医药收藏";
    
//  FHSearchBelowController *photoVC = [[FHSearchBelowController alloc] init];
    FHCollectListViewController *photoVC = [[FHCollectListViewController alloc] init];
    photoVC.yp_tabItemTitle = @"查找附近";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:videosVC,videos1VC,videos2VC,photoVC, nil];
    
}


@end
