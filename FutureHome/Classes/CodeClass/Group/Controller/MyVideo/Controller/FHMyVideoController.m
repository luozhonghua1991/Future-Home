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

@interface FHMyVideoController ()

@end

@implementation FHMyVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHMyVideosController *videosVC = [[FHMyVideosController alloc] init];
    videosVC.yp_tabItemTitle = @"我的视频";
    
    FHMyPhotoController *photoVC = [[FHMyPhotoController alloc] init];
    photoVC.yp_tabItemTitle = @"我的相册";
    
    FHFollowVideoController *followVC = [[FHFollowVideoController alloc] init];
    followVC.yp_tabItemTitle = @"收藏视频";
    
    FHOtherFollowController *friendVC = [[FHOtherFollowController alloc] init];
    friendVC.yp_tabItemTitle = @"其他收藏";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:videosVC, photoVC,followVC,friendVC, nil];
    
}

@end
