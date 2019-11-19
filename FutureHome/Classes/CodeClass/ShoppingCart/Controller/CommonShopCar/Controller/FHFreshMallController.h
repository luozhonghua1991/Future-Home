//
//  FHFreshMallController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHBaseTabbarController.h"
#import "YPTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHFreshMallController : YPTabBarController
/** 商铺ID */
@property (nonatomic, copy) NSString *shopID;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *isCollect;


@end

NS_ASSUME_NONNULL_END
