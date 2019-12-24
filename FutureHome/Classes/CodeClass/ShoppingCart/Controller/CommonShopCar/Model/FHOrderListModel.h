//
//  FHOrderListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHOrderListModel : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *cover;
/** 描述 */
@property (nonatomic, copy) NSString *productname;
/** 物品id */
@property (nonatomic, copy) NSString *goods_id;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *id;
/** 个数 */
@property (nonatomic, copy) NSString *number;
/** 支付id */
@property (nonatomic, copy) NSString *order_idass;
/** 单个价格 */
@property (nonatomic, copy) NSString *sell_price;

/** 单个价格 */
//@property (nonatomic, assign) float  sell_price;

@end

NS_ASSUME_NONNULL_END
