//
//  FHGroupController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHGroupController.h"

@interface FHGroupController () <UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
}

@end

@implementation FHGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社群";
    [self fh_setMainScrollView];
}


#pragma mark — privite
- (void)fh_setMainScrollView {
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-SCREEN_HEIGHT/667 *50)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces =NO;
//    [self.view insertSubview:mainScrollView belowSubview:navigationView];
//    NSArray *views = @[self.dationVC.view, self.findingVC.view,self.rankingVC.view];
//    self.viewControllers = @[self.dationVC,self.findingVC,self.rankingVC];
//    for (int i = 0; i < self.viewControllers.count; i++){
//        //添加背景，把三个VC的view贴到mainScrollView上面
//        UIView *pageView = views[i];
//        pageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
//        [mainScrollView addSubview:pageView];
//    }
//    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * (self.viewControllers.count), 0);
}

@end
