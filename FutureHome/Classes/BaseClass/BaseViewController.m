//
//  BaseViewController.m
//  WMPlayer
//
//  Created by 郑文明 on 16/3/15.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

/** 带搜索的View视图 */
@property (nonatomic, strong) FHCommonNavView *navView;
/** iOS7 之后布局部分 */
@property (nonatomic, assign, getter=isFullScreenLayout) BOOL fullScreenLayout;// default is NO;
@property (nonatomic, assign, getter=isSpecifyFullScreenLayout) BOOL specifyFullScreenLayout;

/** 上面的轮播图 */
@property (nonatomic, strong) NSMutableArray *topBannerArrays;
/** 上面的轮播图 */
@property (nonatomic, strong) NSMutableArray *bottomBannerArrays;

@end

@implementation BaseViewController
//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToHomePage) name:@"GoHomePageController" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GoHomePageController" object:nil];
}

- (void)backToHomePage {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (id)init{
    self = [super init];
    if (self) {
        self.enablePanGesture = YES;
        self.isHaveNav = NO;
        self.isHaveNavgationView = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];
    NSLog(@"%@加载出来了",self);
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        if (SCREEN_HEIGHT == 812) {// iphone X
            [[UITableView appearance] setContentInset:UIEdgeInsetsMake(0, 0, 35, 0)];
            [UITableView appearance].scrollIndicatorInsets = [UITableView appearance].contentInset;

        }
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setIsHaveNav:(BOOL)isHaveNav {
    _isHaveNav = isHaveNav;
    if (!_isHaveNav) {
        if (self.navView) {
            [self.navView removeFromSuperview];
        }
    }
    if (self.isHaveNav) {
        self.navView = [[FHCommonNavView alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
        self.navView.backgroundColor = [UIColor redColor];
        WEAK_SELF(weakSelf);
        self.navView.searchBlock = ^{
            [weakSelf searchClick];
        };
        self.navView.collectBlock = ^{
            [weakSelf collectClick];
        };
        [self.view addSubview:self.navView];
    }
}

- (void)setIsHaveNavgationView:(BOOL)isHaveNavgationView {
    _isHaveNavgationView = isHaveNavgationView;
    if (!isHaveNavgationView) {
        if (self.navgationView) {
            [self.navgationView removeFromSuperview];
        }
    }
    if (self.isHaveNavgationView) {
        self.navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainSizeHeight)];
        self.navgationView.backgroundColor = HEX_COLOR(0x1296db);
        self.navgationView.userInteractionEnabled = YES;
        [self.view addSubview:self.navgationView];
    }
}

- (void)addHud
{
    if (!_hud) {
        _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}
- (void)addHudWithMessage:(NSString*)message
{
    if (!_hud)
    {
        _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText=message;
    }
    
}
- (void)removeHud
{
    if (_hud) {
        [_hud removeFromSuperview];
        _hud=nil;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)dealloc{
    [UIView hideHud:[UIApplication sharedApplication].keyWindow];
//    [ZHProgressHUD showMessage:@"dealloc_success" inView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"dealloc -success");
}

- (CGFloat)getTabbarHeight {
    CGFloat tabbarHeight;
    if (KIsiPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max || IS_IPHONE_Xs) {
        return tabbarHeight = 83;
    } else {
         return tabbarHeight = 49;
    }
}

/**
 *  从 A 控制器跳转到 B 控制器
 *
 *  @param nameVC B 控制器名称
 *  @param param  可选参数
 */
- (void)viewControllerPushOther:(nonnull NSString *)nameVC {
    UIViewController *vc = [[NSClassFromString(nameVC) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

//#pragma mark — FHCommonNavViewBlock
///** 搜索 */
//- (void)searchClick {
//    
//}
///** 收藏 */
//- (void)collectClick {
//    
//}

- (NSMutableArray *)getBottomBannersImgArrysWithType:(NSInteger )type {
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(1),@"user_id",
                               @(type),@"type", nil];
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        
    } failure:^(NSError *error) {
        
    }];
    return self.bottomBannerArrays;
}

- (void)loadInit
{
    [self headerReload];
}
- (void)loadNext
{
    [self footerReload];
}

- (void)headerReload
{}

- (void)footerReload
{}

- (void)delayEndRefresh:(MJRefreshComponent *)cmp
{
    [cmp endRefreshing];
}



#pragma mark — setter && getter
- (NSMutableArray *)topBannerArrays {
    if (!_topBannerArrays) {
        _topBannerArrays = [[NSMutableArray alloc] init];
    }
    return _topBannerArrays;
}

- (NSMutableArray *)bottomBannerArrays {
    if (!_bottomBannerArrays) {
        _bottomBannerArrays = [[NSMutableArray alloc] init];
    }
    return _bottomBannerArrays;
}

@end
