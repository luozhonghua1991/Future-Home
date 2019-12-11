//
//  FHShopingCartController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  购物车

#import "FHShopingCartController.h"
#import "FHFreshShoppingMallController.h"
#import "FHBuinessListController.h"
#import "FHLittleShopListController.h"
#import "FHViewManagementController.h"
#import "FHSureOrderController.h"

@interface FHShopingCartController () <UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
    UIButton *freshShoppingMallBtn;
    UIButton *buinessListBtn;
    UIButton *littleShopListBtn;
    UIButton *viewManagementBtn;
}

/** 生鲜商城订单 */
@property (nonatomic, strong) FHFreshShoppingMallController *freshShoppingMall;
/** 社交商业订单 */
@property (nonatomic, strong) FHBuinessListController  *buinessList;
/** 微商城订单 */
@property (nonatomic, strong) FHLittleShopListController *littleShopList;
/** 查看管理 */
@property (nonatomic, strong) FHViewManagementController *viewManager;
/** 选择导航View */
@property (nonatomic, strong) UIView *selectNavView;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

@end

@implementation FHShopingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    [self fh_setSelectNavView];
    [self fh_creatSelectBtn];
    [self fh_setMainScrollView];
}

#pragma mark — privite
- (void)fh_creatNav {
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"购物车";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fh_setSelectNavView {
    [self.view addSubview:self.selectNavView];
}

- (void)fh_creatSelectBtn {
    //生鲜商城订单 社交商业订单 微商城订单 查看管理
    CGSize size1 = [UIlabelTool sizeWithString:@"生鲜商城" font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    freshShoppingMallBtn = [self creatBtnWithFrame:CGRectMake(ZH_SCALE_SCREEN_Width(25),3, size1.width, self.selectNavView.frame.size.height)title:@"生鲜商城" tag:1];
    [freshShoppingMallBtn setTitleColor:HEX_COLOR(0x0000FF) forState:UIControlStateNormal];
    
    CGSize size2 = [UIlabelTool sizeWithString:@"社交商业" font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    buinessListBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(freshShoppingMallBtn.frame) + ZH_SCALE_SCREEN_Width(30),3, size2.width, self.selectNavView.frame.size.height)title:@"社交商业" tag:2];
    
    CGSize size3 = [UIlabelTool sizeWithString:@"医药商城" font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    littleShopListBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(buinessListBtn.frame) + ZH_SCALE_SCREEN_Width(40),3, size3.width, self.selectNavView.frame.size.height)title:@"医药商城" tag:3];
    
    CGSize size4 = [UIlabelTool sizeWithString:@"地址/发票" font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    viewManagementBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(littleShopListBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size4.width, self.selectNavView.frame.size.height)title:@"地址/发票" tag:4];
}

- (void)fh_setMainScrollView {
    CGFloat tabbarHeight = KIsiPhoneX ? 83 : 49;
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,MainSizeHeight + 35, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarHeight - 35)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    [self.view insertSubview:mainScrollView belowSubview:self.selectNavView];
    NSArray *views = @[self.freshShoppingMall.view, self.buinessList.view,self.littleShopList.view,self.viewManager.view];
    self.viewControllers = @[self.freshShoppingMall,self.buinessList,self.littleShopList,self.viewManager];
    for (int i = 0; i < self.viewControllers.count; i++){
        //添加背景，把四个VC的view贴到mainScrollView上面
        UIView *pageView = views[i];
        pageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
        [mainScrollView addSubview:pageView];
    }
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * (self.viewControllers.count), 0);
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    for (UIViewController *controller in self.viewControllers) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    _viewControllers = [viewControllers copy];
    [_viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:obj];
    }];
    
    // 更新scrollView的content size
    if (mainScrollView) {
        mainScrollView.contentSize =  CGSizeMake(SCREEN_WIDTH * (self.viewControllers.count), 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double index_ = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self sliderAnimationWithTag:(int)(index_ + 0.5) + 1];
    
}


#pragma mark -- 创建Btn
- (UIButton *)creatBtnWithFrame:(CGRect )frame title:(NSString *)title tag:(NSInteger ) tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = tag;
    btn.opaque = true;
    [self.selectNavView addSubview:btn];
    
    return btn;
}
//Btn的点击方法
-(void)sliderAction:(UIButton *)sender {
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        self->mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (UIButton *)theSeletedBtn {
    if (freshShoppingMallBtn.selected) {
        return freshShoppingMallBtn;
    } else if (buinessListBtn.selected){
        return buinessListBtn;
    } else if (littleShopListBtn.selected){
        return littleShopListBtn;
    } else if (viewManagementBtn.selected){
        return viewManagementBtn;
    } else{
        return nil;
    }
}

-(UIButton *)buttonWithTag:(NSInteger)tag {
    if (tag == 1) {
        return freshShoppingMallBtn;
    } else if (tag == 2){
        return buinessListBtn;
    } else if (tag == 3){
        return littleShopListBtn;
    } else if (tag == 4){
        return viewManagementBtn;
    } else{
        return nil;
    }
}

- (void)sliderAnimationWithTag:(NSInteger)tag{
    freshShoppingMallBtn.selected = NO;
    buinessListBtn.selected = NO;
    littleShopListBtn.selected = NO;
    viewManagementBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        [self->freshShoppingMallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self->buinessListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self->littleShopListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self->viewManagementBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:HEX_COLOR(0x0000FF) forState:UIControlStateNormal];
    }];
    
}

#pragma mark — setter && getter#pragma mark - 懒加载
- (UIView *)selectNavView {
    if (!_selectNavView) {
        _selectNavView = [[UIView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 35)];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [_selectNavView addSubview:bottomLine];
    }
    return _selectNavView;
}

- (FHFreshShoppingMallController *)freshShoppingMall {
    if (!_freshShoppingMall) {
        _freshShoppingMall = [[FHFreshShoppingMallController alloc ] init];
    }
    return _freshShoppingMall;
}

- (FHBuinessListController *)buinessList {
    if (!_buinessList) {
        _buinessList = [[FHBuinessListController alloc] init];
    }
    return _buinessList;
}

- (FHLittleShopListController *)littleShopList {
    if (!_littleShopList) {
        _littleShopList = [[FHLittleShopListController alloc] init];
    }
    return _littleShopList;
}

- (FHViewManagementController *)viewManager{
    if (!_viewManager) {
        _viewManager =  [[FHViewManagementController alloc] init];
    }
    return _viewManager;
}

@end
