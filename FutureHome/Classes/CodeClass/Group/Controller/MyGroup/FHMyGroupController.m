//
//  FHMyGroupController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/29.
//  Copyright © 2019 同熙传媒. All rights reserved
//  我的社群

#import "FHMyGroupController.h"
#import "FHMessageController.h"
#import "FHGroupMessageController.h"
#import "FHCircleHotPointController.h"
#import "FHFriendLisController.h"

@interface FHMyGroupController ()

@end

@implementation FHMyGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHMessageController *messageVC = [[FHMessageController alloc] init];
    messageVC.yp_tabItemTitle = @"对话";

    FHGroupMessageController *groupVC = [[FHGroupMessageController alloc] init];
    groupVC.yp_tabItemTitle = @"群聊";

    FHCircleHotPointController *hotVC = [[FHCircleHotPointController alloc] init];
    hotVC.yp_tabItemTitle = @"圈内热点";

    FHFriendLisController *friendVC = [[FHFriendLisController alloc] init];
    friendVC.yp_tabItemTitle = @"好友列表";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,friendVC, nil];
    
}


@end
