//
//  FHOrderDetailController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHOrderDetailController : BaseViewController
/** 0待付款 1待收货 2待评价 3售后 */
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
