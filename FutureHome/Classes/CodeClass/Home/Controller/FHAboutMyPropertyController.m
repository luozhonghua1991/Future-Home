//
//  FHAboutMyPropertyController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHAboutMyPropertyController.h"
#import "FHOwnerCertificationController.h"
#import "FHRentalSaleController.h"
#import "FHReleaseManagementController.h"

@interface FHAboutMyPropertyController ()

@end

@implementation FHAboutMyPropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewControllers {
    FHOwnerCertificationController *messageVC = [[FHOwnerCertificationController alloc] init];
    messageVC.yp_tabItemTitle = @"业主认证";
    messageVC.property_id = self.property_id;
    
    FHRentalSaleController *groupVC = [[FHRentalSaleController alloc] init];
    groupVC.yp_tabItemTitle = @"出租出售";
    groupVC.property_id = self.property_id;
    
    FHReleaseManagementController *hotVC = [[FHReleaseManagementController alloc] init];
    hotVC.yp_tabItemTitle = @"发布管理";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
