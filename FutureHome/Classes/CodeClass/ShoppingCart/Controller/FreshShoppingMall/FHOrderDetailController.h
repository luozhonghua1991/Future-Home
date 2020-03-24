//
//  FHOrderDetailController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHOrderDetailController : BaseViewController
/** 0待付款 1待收货 2待评价 3售后 */
@property (nonatomic, assign) NSInteger type;
/** 1代付款 2待收货 3待评价 4退换 售后 */
@property (nonatomic, assign) NSInteger status;
/** 订单详情id */
@property (nonatomic, copy) NSString *order_id;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *bottomTitleString;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHGoodsListModel *listModel;

@end

NS_ASSUME_NONNULL_END
