//
//  FHGoodsListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHGoodsListModel : NSObject
/** 添加时间 */
@property (nonatomic, copy) NSString *add_time;
/** 图片数组 */
@property (nonatomic, copy) NSArray *covers;
/** 订单id */
@property (nonatomic, copy) NSString *id;
/** 个数 */
@property (nonatomic, copy) NSString *number;
/** 总价 */
@property (nonatomic, copy) NSString *pay_money;
/** 商店名字 */
@property (nonatomic, copy) NSString *shopname;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *status;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;
/** 0没有申请退款 1申请退款 */
@property (nonatomic, copy) NSString *isapply;
/** 0没有评价 1评价 */
@property (nonatomic, copy) NSString *iscomment;
/** 0没有完成退款 1完成退款 */
@property (nonatomic, copy) NSString *approval;

@end

NS_ASSUME_NONNULL_END
