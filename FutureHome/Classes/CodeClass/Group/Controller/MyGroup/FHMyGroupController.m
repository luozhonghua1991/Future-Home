//
//  FHMyGroupController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved
//  我的社群

#import "FHMyGroupController.h"
#import "FHMessageController.h"
#import "FHGroupMessageListController.h"
#import "FHCircleHotPointController.h"
#import "FHFriendLisController.h"

@interface FHMyGroupController ()

@end

@implementation FHMyGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveToGroup) name:@"GoGroupController" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GoGroupController" object:nil];
    
}

- (void)moveToGroup {
    
}

- (void)initViewControllers {
    FHMessageController *messageVC = [[FHMessageController alloc] init];
    messageVC.yp_tabItemTitle = @"对话";

    FHGroupMessageListController *groupVC = [[FHGroupMessageListController alloc] init];
    groupVC.yp_tabItemTitle = @"群聊";

    FHCircleHotPointController *hotVC = [[FHCircleHotPointController alloc] init];
    hotVC.yp_tabItemTitle = @"圈热点";
    hotVC.isHaveTabbar = YES;
    hotVC.isHaveHeaderView = YES;

    FHFriendLisController *followVC = [[FHFriendLisController alloc] init];
    followVC.yp_tabItemTitle = @"关注";
    
    FHFriendLisController *fansVC = [[FHFriendLisController alloc] init];
    fansVC.yp_tabItemTitle = @"粉丝";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,followVC,fansVC, nil];
}


@end
