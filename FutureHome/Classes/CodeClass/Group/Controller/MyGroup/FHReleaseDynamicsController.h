//
//  FHReleaseDynamicsController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "HWPublishBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHReleaseDynamicsController : HWPublishBaseController
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** 1 物业  2 业委 */
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
