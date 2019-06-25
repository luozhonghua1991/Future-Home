//
//  FHHomePageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  主页

#import "FHHomePageController.h"

@interface FHHomePageController ()

@end

@implementation FHHomePageController


#pragma mark — privite
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}

- (void)setNav {
    CGFloat H = MainNavgationBarHeight;
    NSLog(@"%f",H);
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
}

@end
