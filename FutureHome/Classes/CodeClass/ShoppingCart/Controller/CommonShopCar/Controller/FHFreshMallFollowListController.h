//
//  FHFreshMallFollowListController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHFreshMallFollowListController : BaseViewController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *titleString;
/** 1物业收藏 2业委收藏 3.生鲜收藏 4社交收藏 5企业收藏 */
@property (nonatomic, copy) NSString *type;
// <#属性block#>
@property (nonatomic, copy) void(^selectShopBlock)(NSString *shopID);


@end

NS_ASSUME_NONNULL_END
