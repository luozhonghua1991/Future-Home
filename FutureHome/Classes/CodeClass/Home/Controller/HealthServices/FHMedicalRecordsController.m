//
//  FHMedicalRecordsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  医疗档案主界面

#import "FHMedicalRecordsController.h"
#import "FHMedicalRecordsListController.h"

@interface FHMedicalRecordsController ()

@end

@implementation FHMedicalRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initViewControllers {
    FHMedicalRecordsListController *messageVC = [[FHMedicalRecordsListController alloc] init];
    messageVC.yp_tabItemTitle = @"成员列表";
    
    FHMedicalRecordsListController *groupVC = [[FHMedicalRecordsListController alloc] init];
    groupVC.yp_tabItemTitle = @"医疗记录";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC, nil];
}

@end
