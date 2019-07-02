//
//  FHViewManagementController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  查看管理

#import "FHViewManagementController.h"
#import "FHAddressManagerController.h"
#import "FHNormalManagerController.h"
#import "FHSpecialManagerController.h"
#import "FHInvoiceListController.h"

@interface FHViewManagementController ()

@end

@implementation FHViewManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViewControllers {
    FHAddressManagerController *messageVC = [[FHAddressManagerController alloc] init];
    messageVC.yp_tabItemTitle = @"地址管理";
    
    FHNormalManagerController *groupVC = [[FHNormalManagerController alloc] init];
    groupVC.yp_tabItemTitle = @"普票管理";
    
    FHSpecialManagerController *hotVC = [[FHSpecialManagerController alloc] init];
    hotVC.yp_tabItemTitle = @"专票管理";
    
    FHInvoiceListController *friendVC = [[FHInvoiceListController alloc] init];
    friendVC.yp_tabItemTitle = @"发票列表";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,friendVC, nil];
    
}

@end