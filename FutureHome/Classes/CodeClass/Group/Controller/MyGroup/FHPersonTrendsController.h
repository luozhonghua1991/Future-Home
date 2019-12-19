//
//  FHPersonTrendsController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "YPTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHPersonTrendsController : YPTabBarController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *titleString;
/** 1是自己 0是看的别人 */
@property (nonatomic, assign) NSInteger personType;
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 关注信息 */
@property (nonatomic, copy) NSString *follow_msg;

@end

NS_ASSUME_NONNULL_END
