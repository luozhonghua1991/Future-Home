
//
//  CurrentViewController.m
//  SayU
//
//  Created by mac on 15/11/18.
//  Copyright (c) 2015年 xys. All rights reserved.
//

#import "CurrentViewController.h"

@interface CurrentViewController ()

@end

@implementation CurrentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
    result = window.rootViewController;
    return result;
}

+ (UIViewController *)getCurrentVC1
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

/**
 *  获取最上层视图
 */
+ (UIViewController*)topViewController
{
    return [[[CurrentViewController alloc] init] topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
