//
//  BaseNavigationController.m
//  UserRedMaster
//
//  Created by liuchao on 16/2/4.
//  Copyright © 2016年 liuchao. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController()
<
UIGestureRecognizerDelegate,
UINavigationControllerDelegate
>
/** 当前控制器 */
@property (nonatomic, weak) UIViewController *activeVController;

@end

@implementation BaseNavigationController

+ (void)initialize
{
    // 1.设置导航栏颜色
    UINavigationBar *navBar = [UINavigationBar appearance];
    //    navBar.barTintColor = [UIColor blackColor];
    navBar.translucent = NO;
//    navBar.barStyle = UIBarStyleBlack;
    
    // 隐藏 uinavigationbar bottom line
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // 2.设置 title 颜色
    NSMutableDictionary * navAttrs = [NSMutableDictionary dictionary];
    navAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    navAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    navBar.titleTextAttributes = navAttrs;
    
    // 3.设置 BarButtonItem 颜色
    UIBarButtonItem *barBtn = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barBtn setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    if (self = [super initWithRootViewController:rootViewController]) {
        
        self.interactivePopGestureRecognizer.delegate = self;
        
        self.delegate = self;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
//        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

//// 个人中心首页隐藏 NavigationBar
//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated {
//    if (
//        [viewController isMemberOfClass:NSClassFromString(@"ShopViewController")] ||
//        [viewController isMemberOfClass:NSClassFromString(@"RacingDetailViewController")]||
//        [viewController isMemberOfClass:NSClassFromString(@"NewsViewController")]||
//        [viewController isMemberOfClass:NSClassFromString(@"LiveRoomViewController")]) {
//        [navigationController setNavigationBarHidden:YES animated:animated];
//    } else if ( [navigationController isNavigationBarHidden] ) {
//        [navigationController setNavigationBarHidden:NO animated:animated];
//    }
//}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1) {
        self.activeVController = nil;
    }else {
        self.activeVController = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.activeVController == self.topViewController) ? YES : NO;
    }
    return YES;
}

@end
