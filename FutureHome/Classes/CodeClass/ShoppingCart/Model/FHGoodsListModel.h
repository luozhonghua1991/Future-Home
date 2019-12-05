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
/** 订单状态 1下单(待付款) 2付款(等待接单)(待发货) 3送达(完成)(待评价) 4已经完成(已经评价) 5 申请退款 6退款成功 7拒绝退款*/
@property (nonatomic, copy) NSString *status;
/** 1快递到家 2预订前往 3实时配送 */
@property (nonatomic, copy) NSString *type;
/** 0没有申请退款 1申请退款 */
@property (nonatomic, copy) NSString *isapply;
/** 0没有评价 1评价 */
@property (nonatomic, copy) NSString *iscomment;
/** 0没有完成退款 1完成退款 */
@property (nonatomic, copy) NSString *approval;

@end

NS_ASSUME_NONNULL_END
