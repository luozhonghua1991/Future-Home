//
//  FHRentalAndSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  房屋租售

#import "FHRentalAndSaleController.h"
#import "FHHouseSaleController.h"

@interface FHRentalAndSaleController ()

@end

@implementation FHRentalAndSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initViewControllers {
    FHHouseSaleController *messageVC = [[FHHouseSaleController alloc] init];
    messageVC.yp_tabItemTitle = @"房屋出售";
    messageVC.type = 0;
    
    FHHouseSaleController *groupVC = [[FHHouseSaleController alloc] init];
    groupVC.yp_tabItemTitle = @"房屋出租";
    groupVC.type = 1;
    
    FHHouseSaleController *hotVC = [[FHHouseSaleController alloc] init];
    hotVC.yp_tabItemTitle = @"车位出售";
    hotVC.type = 2;
    
    FHHouseSaleController *VC = [[FHHouseSaleController alloc] init];
    VC.yp_tabItemTitle = @"车位出租";
    VC.type = 3;
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,VC, nil];
    
}

@end
