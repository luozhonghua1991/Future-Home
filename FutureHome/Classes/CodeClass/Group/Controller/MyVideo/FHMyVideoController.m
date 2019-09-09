//
//  FHMyVideoController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  我的视界

#import "FHMyVideoController.h"
#import "BaseViewController.h"
#import "FHMyVideosController.h"
#import "FHMyPhotoController.h"
#import "FHFollowVideoController.h"
#import "FHOtherFollowController.h"
#import "FHCircleHotPointController.h"
#import "FHMyVideosController.h"

@interface FHMyVideoController ()

@end

@implementation FHMyVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHCircleHotPointController *videosVC = [[FHCircleHotPointController alloc] init];
    videosVC.yp_tabItemTitle = @"动态";
    videosVC.isHaveHeaderView = YES;
    videosVC.isHaveTabbar = YES;
    
    FHMyVideosController *photoVC = [[FHMyVideosController alloc] init];
    photoVC.yp_tabItemTitle = @"视频";
    
    FHMyPhotoController *followVC = [[FHMyPhotoController alloc] init];
    followVC.yp_tabItemTitle = @"相册";
    
    FHOtherFollowController *friendVC = [[FHOtherFollowController alloc] init];
    friendVC.yp_tabItemTitle = @"收藏";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:videosVC, photoVC,followVC,friendVC, nil];
    
}

@end
