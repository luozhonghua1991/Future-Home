//
//  FHGoodsListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商品列表VC

#import "FHGoodsListController.h"
#import "GNRLinkageTableView.h"
#import "GNRShoppingBar.h"

@interface FHGoodsListController () <CAAnimationDelegate>
@property (nonatomic,strong) CALayer *dotLayer;//小圆点
@property (nonatomic,assign) CGFloat endPointX;
@property (nonatomic,assign) CGFloat endPointY;
@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic, strong)GNRLinkageTableView * goodsListView;
@property (nonatomic, strong)GNRShoppingBar * shoppingBar;

@end

@implementation FHGoodsListController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.goodsListView];
//    [self initData];
    [self.view addSubview:self.shoppingBar];
}

@end
