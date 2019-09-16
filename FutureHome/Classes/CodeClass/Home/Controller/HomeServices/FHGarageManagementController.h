//
//  FHGarageManagementController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHGarageManagementController : BaseViewController
/** 获取VC ID */
@property (nonatomic, assign) NSInteger ID;
/** 获取类型 */
@property (nonatomic, assign) NSInteger type;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;

@end

NS_ASSUME_NONNULL_END
