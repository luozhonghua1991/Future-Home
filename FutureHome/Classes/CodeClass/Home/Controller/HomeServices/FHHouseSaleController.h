//
//  FHHouseSaleController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHHouseSaleController : BaseViewController
/** 0房屋出售 1房屋出租 2车位出售 3车位出租   1出售 2出租*/
@property (nonatomic, assign) NSInteger type;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;

@end

NS_ASSUME_NONNULL_END
