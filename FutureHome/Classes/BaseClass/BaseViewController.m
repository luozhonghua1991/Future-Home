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
/** 自定义导航栏视图 */
@property (nonatomic, strong) UIView *navgationView;
/** iOS7 之后布局部分 */
@property (nonatomic, assign, getter=isFullScreenLayout) BOOL fullScreenLayout;// default is NO;
@property (nonatomic, assign, getter=isSpecifyFullScreenLayout) BOOL specifyFullScreenLayout;

@end

@implementation BaseViewController
//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
        self.navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainNavgationBarHeight)];
        self.navgationView.backgroundColor = [UIColor blueColor];
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
    return tabbarHeight = KIsiPhoneX ? 83 : 49;
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

@end
