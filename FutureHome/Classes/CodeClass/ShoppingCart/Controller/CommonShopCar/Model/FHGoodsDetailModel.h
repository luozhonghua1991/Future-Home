//
//  FHGoodsDetailModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHGoodsDetailModel : NSObject
/** 商品名字 */
@property (nonatomic, strong)NSString * title;
/** 商品图片 */
@property (nonatomic, strong)NSString * cover;
/** 产地 */
@property (nonatomic, strong)NSString * Place;
/** 商品原价 */
@property (nonatomic, copy) NSString *origin_price;
/** 商品现价 */
@property (nonatomic, copy) NSString *sell_price;
/** 库存 */
@property (nonatomic, strong)NSString * SafetStock;
/** 商品规格 */
@property (nonatomic, strong) NSString *UnitAtr;
/** 商品描述 */
@property (nonatomic, copy) NSString *desc;
/** 每日限购 */
@property (nonatomic, copy) NSString *limit_num;

@end

NS_ASSUME_NONNULL_END
