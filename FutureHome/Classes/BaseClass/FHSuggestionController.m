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
#import "FHSuggestionListController.h"

@interface FHSuggestionController ()

@end

@implementation FHSuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initViewControllers {
    FHSuggestionListController *messageVC = [[FHSuggestionListController alloc] init];
    messageVC.yp_tabItemTitle = @"全部列表";
    messageVC.property_id = self.property_id;
    messageVC.type = self.type;
    messageVC.isSelf = NO;
    
    FHSuggestionListController *groupVC = [[FHSuggestionListController alloc] init];
    groupVC.yp_tabItemTitle = @"我的投诉建议";
    groupVC.property_id = self.property_id;
    groupVC.type = self.type;
    groupVC.isSelf = YES;

    FHComplaintsSuggestionsController *hotVC = [[FHComplaintsSuggestionsController alloc] init];
    hotVC.yp_tabItemTitle = @"投诉建议";
    hotVC.type = self.type;
    hotVC.property_id = self.property_id;

    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
