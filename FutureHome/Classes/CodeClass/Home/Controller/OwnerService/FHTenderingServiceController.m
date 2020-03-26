//
//  FHTenderingServiceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/26.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  招标服务界面

#import "FHTenderingServiceController.h"
#import "FHNoticeListModel.h"
#import "FHWebViewController.h"
#import "FHBaseAnnouncementListController.h"

@interface FHTenderingServiceController ()

@end

@implementation FHTenderingServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    FHBaseAnnouncementListController *an = [[FHBaseAnnouncementListController alloc] init];
    an.titleString = @"招标服务";
    an.webTitleString = @"招标服务";
    an.hidesBottomBarWhenPushed = YES;
    an.isHaveSectionView = YES;
    an.ID = 10;
    an.type = 2;
    an.isHaveSelectView = YES;
    an.property_id = self.property_id;
    [self.view addSubview:an.view];
    [self addChildViewController:an];
    
}



@end
