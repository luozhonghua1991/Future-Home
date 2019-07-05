//
//  FHPublicServiceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  公共服务

#import "FHPublicServiceController.h"
#import "FHSearchBelowController.h"
#import "FHSearchCategoryController.h"

@interface FHPublicServiceController ()

@end

@implementation FHPublicServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
   
    FHSearchBelowController *photoVC = [[FHSearchBelowController alloc] init];
    photoVC.yp_tabItemTitle = @"关注列表";
    
    FHSearchCategoryController *followVC = [[FHSearchCategoryController alloc] init];
    followVC.yp_tabItemTitle = @"查找附近";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:photoVC,followVC, nil];
    
}

@end
