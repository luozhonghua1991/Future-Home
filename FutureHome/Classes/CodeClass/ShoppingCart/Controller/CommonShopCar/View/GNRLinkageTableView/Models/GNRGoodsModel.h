//
//  GNRGoodsModel.h
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNRGoodsModel : NSObject
/** 商品名字 */
@property (nonatomic, strong)NSString * goodsName;
/** 商品图片 */
@property (nonatomic, strong)NSString * goodsImage;
/** 价格 */
@property (nonatomic, strong)NSString * goodsPrice;
/** 产地 */
@property (nonatomic, strong)NSString * goodsPlace;
/** 库存 */
@property (nonatomic, strong)NSString * goodsSafetStock;
/** 商品规格 */
@property (nonatomic, strong) NSString *goodsUnitAtr;
/** 商品对应的id */
@property (nonatomic, strong) NSString *goodsID;

@property (nonatomic, assign)float shouldPayMoney;
/** 购买个数 */
@property (nonatomic, strong)NSNumber * number;//购买个数
/** 0不限购 1限购 */
@property (nonatomic, assign) NSInteger Isrestrictions;
/** 当前用户总共购买的数量 */
@property (nonatomic, assign) NSInteger buyNum;
/** 限购的数量 */
@property (nonatomic, assign) NSInteger limit_num;

@end
