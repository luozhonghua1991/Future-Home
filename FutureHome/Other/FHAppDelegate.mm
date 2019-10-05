//
//  AppDelegate.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHAppDelegate.h"
#import "LCTabBarController.h"
#import "FHHomePageController.h"
#import "FHGroupController.h"
#import "FHShopingController.h"
#import "FHShopingCartController.h"
#import "FHMeCenterController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

static FHAppDelegate* pSelf = nil;

@interface FHAppDelegate ()

@end

@implementation FHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    pSelf = self;
    [self setTabBarController];

    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        // 无权限
        // do something...
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    return YES;
}


#pragma mark  -- 设置tabbar
- (void)setTabBarController {
    FHHomePageController *vc1 = [[FHHomePageController alloc] init];
    vc1.title = @"首页";
    vc1.tabBarItem.image = [UIImage imageNamed:@"zhuye-2"];
    vc1.tabBarItem.selectedImage = [UIImage imageNamed:@"zhuye"];
    
    FHGroupController *vc2 = [[FHGroupController alloc] init];
    vc2.title = @"社云";
    vc2.isSelectBuiness = NO;
    vc2.tabBarItem.image = [UIImage imageNamed:@"jiayuanshejiao-2"];
    vc2.tabBarItem.selectedImage = [UIImage imageNamed:@"jiayuanshejiao"];
    
    FHGroupController *vc3 = [[FHGroupController alloc] init];
    vc3.title = @"商家服务";
    vc3.isSelectBuiness = YES;
    vc3.tabBarItem.image = [UIImage imageNamed:@"jiaoyi-3"];
    vc3.tabBarItem.selectedImage = [UIImage imageNamed:@"jiaoyi"];
    
    FHShopingCartController *vc4 = [[FHShopingCartController alloc] init];
    vc4.title = @"购物车";
    vc4.tabBarItem.image = [UIImage imageNamed:@"gouwuche-2"];
    vc4.tabBarItem.selectedImage = [UIImage imageNamed:@"gouwuche"];
    
    FHMeCenterController *vc5 = [[FHMeCenterController alloc] init];
    vc5.title = @"个人中心";
    vc5.tabBarItem.image = [UIImage imageNamed:@"gerenzhongxinxuanzhong1-2"];
    vc5.tabBarItem.selectedImage = [UIImage imageNamed:@"gerenzhongxinxuanzhong1"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    LCTabBarController *tabBarC    = [[LCTabBarController alloc] init];
    [tabBarC addChildViewController:navC1];
    [tabBarC addChildViewController:navC2];
    [tabBarC addChildViewController:navC3];
    [tabBarC addChildViewController:navC4];
    [tabBarC addChildViewController:navC5];
    self.window.rootViewController = tabBarC;
    
    /** 判断用户是否登录过 没登录去登录 */
    if (![AccountStorage isExistsToKen]) {
        [FHLoginTool fh_makePersonToLoging];
        return;
    }
}


#pragma mark  -- 返回AppDelegate本身
+ (FHAppDelegate *)getAppDelegate {
    return pSelf;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
