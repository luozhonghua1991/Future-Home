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

@interface FHFreshShoppingMallController ()

@end

@implementation FHFreshShoppingMallController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHWaitOrderController *messageVC = [[FHWaitOrderController alloc] init];
    messageVC.yp_tabItemTitle = @"待付款";
    
    FHWaitGetController *groupVC = [[FHWaitGetController alloc] init];
    groupVC.yp_tabItemTitle = @"待收货";
    
    FHWaitAppraiseController *hotVC = [[FHWaitAppraiseController alloc] init];
    hotVC.yp_tabItemTitle = @"待评价";
    
    FHAfterSaleController *friendVC = [[FHAfterSaleController alloc] init];
    friendVC.yp_tabItemTitle = @"退换/售后";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,friendVC, nil];
    
}

@end
