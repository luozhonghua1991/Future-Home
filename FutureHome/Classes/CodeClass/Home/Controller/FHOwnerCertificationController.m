//
//  FHOwnerCertificationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHOwnerCertificationController.h"

@interface FHOwnerCertificationController ()

@end

@implementation FHOwnerCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(10, ScreenHeight / 2 - 30, ScreenWidth - 20, 50);
    _button.backgroundColor = HEX_COLOR(0x1296db);
    _button.layer.cornerRadius = 25;
    _button.layer.masksToBounds = YES;
    _button.clipsToBounds = YES;
    [_button setTitle:@"前往认证业主信息" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(goOwnerCertification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)goOwnerCertification {
    /** 去业主认证 */
    [self viewControllerPushOther:@"FHOwnerCertificationViewController"];
}


@end
