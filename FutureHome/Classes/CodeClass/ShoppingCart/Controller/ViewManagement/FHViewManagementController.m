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
#import "HYJFAddressAdministrationController.h"

@interface FHViewManagementController ()

@end

@implementation FHViewManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViewControllers {
    HYJFAddressAdministrationController *messageVC = [[HYJFAddressAdministrationController alloc] init];
    messageVC.yp_tabItemTitle = @"地址管理";
    
    FHInvoiceListController *friendVC = [[FHInvoiceListController alloc] init];
    friendVC.yp_tabItemTitle = @"发票管理";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC,friendVC, nil];
    
}

@end
