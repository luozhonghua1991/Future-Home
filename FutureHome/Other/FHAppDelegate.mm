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
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "LeoPayManager.h"
#import <RongIMKit/RongIMKit.h>
#import "AFNetworkReachabilityManager.h"

static FHAppDelegate* pSelf = nil;

@interface FHAppDelegate () <
WXApiDelegate,
RCIMUserInfoDataSource,
RCIMConnectionStatusDelegate,
RCIMGroupInfoDataSource
>
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *allFriendArrs;

@end

@implementation FHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SingleManager shareManager].allGroupsArrs = [[NSMutableArray alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    pSelf = self;
    self.allFriendArrs = [[NSMutableArray alloc] init];
    [WXApi registerApp:@"wx73519589eb9e4996" universalLink:@""];
    [self checkNetWork];
    
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUDAPPKEY];
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    /** 与融云服务器建立连接 */
    Account *account = [AccountStorage readAccount];
    if (account.rong_token) {
        [[RCIM sharedRCIM] connectWithToken:account.rong_token success:^(NSString *userId) {
            //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = account.username;
            userInfo.name = account.nickname;
            userInfo.portraitUri = account.avatar;
            [RCIM sharedRCIM].currentUserInfo = userInfo;
        } error:^(RCConnectErrorCode status) {
            NSLog(@"login error status: %ld.", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
        }];
    } else {
        [FHLoginTool fh_makePersonToLoging];
    }
    [self setTabBarController];
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

//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//
//        }];
//
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//    } else if ([url.host isEqualToString:@"pay"]) {
//        // 处理微信的支付结果
//        [WXApi handleOpenURL:url delegate:self];
//    }
//    return YES;
//}

//iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if([url.scheme hasPrefix:@"wx"])//微信
    {
        return [LeoPayManager wechatHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"UnionPay"])//银联
    {
        return [LeoPayManager unionHandleOpenURL:url];
    }
    else if([url.host hasPrefix:@"safepay"])//支付宝
    {
        return [LeoPayManager alipayHandleOpenURL:url];
    }
    
    return YES;
}


// MARK: - 融云服务器连接状态监听
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_Connected) {
        NSLog(@"融云服务器连接成功!");
    } else  {
        if (status == ConnectionStatus_SignUp) {
            NSLog(@"融云服务器断开连接!");
        } else {
            NSLog(@"融云服务器连接失败!");
        }
    }
}


#pragma mark - <RCIMUserInfoDataSource>
// 设置会话的头像和昵称等   是好友的头像和昵称，不是自己的
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {

    NSLog(@"------ userID = %@ ---------", userId);
    dispatch_async(dispatch_get_main_queue(), ^{
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   userId,@"userId",
                                   nil];

        [AFNetWorkTool get:@"sheyun/getUserInfor" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                userInfo.userId = userId;
                userInfo.name = responseObj[@"data"][@"userName"];
                userInfo.portraitUri = responseObj[@"data"][@"userPortrait"];

                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
                return completion(userInfo);
            } else {

            }
        } failure:^(NSError *error) {

        }];
        return completion(nil);
    });
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    NSLog(@"------ groupId = %@ ---------", groupId);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[SingleManager shareManager].allGroupsArrs containsObject:groupId]) {
            [[SingleManager shareManager].allGroupsArrs addObject:groupId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEGROUPCOUNT" object:nil];
        }

        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   groupId,@"groupId",
                                   nil];

        [AFNetWorkTool get:@"sheyun/getGroupDetail" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                RCGroup *groupInfo = [[RCGroup alloc] init];
                groupInfo.groupId = groupId;
                groupInfo.groupName = responseObj[@"data"][@"groupName"];
                groupInfo.portraitUri = responseObj[@"data"][@"groupPortrait"];

                [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupInfo.groupId];
                return completion(groupInfo);
            } else {

            }
        } failure:^(NSError *error) {

        }];
        return completion(nil);
    });
}


- (void)checkNetWork {
    AFNetworkReachabilityManager *mger = [AFNetworkReachabilityManager sharedManager];
    [mger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [SingleManager shareManager].isIphone4G = NO;
                ZHLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                [SingleManager shareManager].isIphone4G = NO;
                ZHLog(@"没有网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                [SingleManager shareManager].isIphone4G = YES;
                ZHLog(@"手机自带网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fefreshBanner" object:nil];
                break;
            }
            default:AFNetworkReachabilityStatusReachableViaWiFi: {
                [SingleManager shareManager].isIphone4G = NO;
                ZHLog(@"wifi");
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"fefreshBanner" object:nil];
                break;
            }
        }
    }];
    [mger startMonitoring];
}

@end
