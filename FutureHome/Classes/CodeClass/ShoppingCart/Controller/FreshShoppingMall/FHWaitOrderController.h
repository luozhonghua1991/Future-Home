//
//  FHWaitOrderController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHWaitOrderController : BaseViewController
/** 0待付款 1待收货 2待评价 3售后 */
@property (nonatomic, assign) NSInteger type;
/** 1代付款 2待收货 3待评价 4退换 售后 */
@property (nonatomic, assign) NSInteger status;
/** 3 生鲜商城订单 4 社交商业订单 5 药品商城订单 */
@property (nonatomic, copy) NSString *order_type;


@end

NS_ASSUME_NONNULL_END
