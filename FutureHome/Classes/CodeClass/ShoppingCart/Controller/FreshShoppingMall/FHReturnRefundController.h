//
//  FHReturnRefundController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "HWPublishBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHReturnRefundController : HWPublishBaseController
/** 订单id */
@property (nonatomic, copy) NSString *orderID;
/** 退款的金额 */
@property (nonatomic, copy) NSString *totolePrice;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *order_type;


@end

NS_ASSUME_NONNULL_END
