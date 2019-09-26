//
//  FHCarSaleController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHCarSaleController : BaseViewController
/** 0房屋出售 1房屋出租 2车位出售 3车位出租 */
@property (nonatomic, assign) NSInteger type;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** id */
@property (nonatomic, assign) NSInteger id;

@end

NS_ASSUME_NONNULL_END
