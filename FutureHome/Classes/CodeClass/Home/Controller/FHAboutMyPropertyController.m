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
#import "FHAuthModel.h"

@interface FHAboutMyPropertyController ()
/** <#strong属性注释#> */
@property (nonatomic, strong) FHAuthModel *authModel;

@end

@implementation FHAboutMyPropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(weakSelf.property_id),@"property_id",
                               nil];
    [AFNetWorkTool get:@"property/isAuth" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.authModel = [FHAuthModel mj_objectWithKeyValues:responseObj[@"data"]];
        }
        [self initSetViewControllers];
    } failure:^(NSError *error) {
        
    }];
}

- (void)initSetViewControllers {
    FHOwnerCertificationController *messageVC = [[FHOwnerCertificationController alloc] init];
    messageVC.yp_tabItemTitle = @"业主认证";
    messageVC.authModel = self.authModel;
    messageVC.property_id = self.property_id;
    
    FHRentalSaleController *groupVC = [[FHRentalSaleController alloc] init];
    groupVC.yp_tabItemTitle = @"出租出售";
    groupVC.property_id = self.property_id;
    groupVC.authModel = self.authModel;
    
    FHReleaseManagementController *hotVC = [[FHReleaseManagementController alloc] init];
    hotVC.yp_tabItemTitle = @"发布管理";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
