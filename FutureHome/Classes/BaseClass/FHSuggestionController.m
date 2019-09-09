//
//  FHSuggestionController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  投诉建议

#import "FHSuggestionController.h"
#import "FHComplaintsSuggestionsController.h"
#import "FHCircleHotPointController.h"

@interface FHSuggestionController ()

@end

@implementation FHSuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViewControllers {
    FHCircleHotPointController *messageVC = [[FHCircleHotPointController alloc] init];
    messageVC.yp_tabItemTitle = @"全部列表";
    
    FHCircleHotPointController *groupVC = [[FHCircleHotPointController alloc] init];
    groupVC.yp_tabItemTitle = @"答复消息";

    FHComplaintsSuggestionsController *hotVC = [[FHComplaintsSuggestionsController alloc] init];
    hotVC.yp_tabItemTitle = @"投诉建议";

    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end