//
//  FHFreshShoppingMallController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  生鲜商城

#import "FHFreshShoppingMallController.h"
#import "FHWaitOrderController.h"
#import "FHWaitGetController.h"
#import "FHWaitAppraiseController.h"
#import "FHAfterSaleController.h"
#import "FHGoodsListController.h"

@interface FHFreshShoppingMallController ()

@end

@implementation FHFreshShoppingMallController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHWaitOrderController *messageVC = [[FHWaitOrderController alloc] init];
    messageVC.yp_tabItemTitle = @"待付款";
    messageVC.type = 0;
    messageVC.status = 1;
    
    FHWaitOrderController *groupVC = [[FHWaitOrderController alloc] init];
    groupVC.yp_tabItemTitle = @"待收货";
    groupVC.type = 1;
    groupVC.status = 2;
    
    FHWaitOrderController *hotVC = [[FHWaitOrderController alloc] init];
    hotVC.yp_tabItemTitle = @"待评价";
    hotVC.type = 2;
    hotVC.status = 3;
    
    FHWaitOrderController *friendVC = [[FHWaitOrderController alloc] init];
    friendVC.yp_tabItemTitle = @"售后/全部";
    friendVC.type = 3;
    friendVC.status = 4;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,friendVC, nil];
    
}

@end
