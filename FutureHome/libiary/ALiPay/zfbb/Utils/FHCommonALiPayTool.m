//
//  FHCommonALiPayTool.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  通用支付宝支付tool 工具类

#import "FHCommonALiPayTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthInfo.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import "adwb.h"


#define AP_SUBVIEW_XGAP   (20.0f)
#define AP_SUBVIEW_YGAP   (30.0f)
#define AP_SUBVIEW_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 2*(AP_SUBVIEW_XGAP))

#define AP_BUTTON_HEIGHT  (60.0f)
#define AP_INFO_HEIGHT    (200.0f)

@implementation FHCommonALiPayTool


// 选中商品调用支付宝极简支付

+ (void)doAPPayWithAppsecertKey:(NSString *)keyString {
        NSString *appScheme = @"alisdkdemo";
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:keyString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
        }];
}

@end
