//
//  FHGoodsCommitController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "HWPublishBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHGoodsCommitController : HWPublishBaseController
/** 订单id */
@property (nonatomic, copy) NSString *orderID;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *ordertype;

@end

NS_ASSUME_NONNULL_END
