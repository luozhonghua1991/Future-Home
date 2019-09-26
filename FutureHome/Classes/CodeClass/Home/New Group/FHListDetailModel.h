//
//  FHListDetailModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHListDetailModel : NSObject
/** 住房面积 */
@property (nonatomic, assign) NSInteger area;
/** 小区名字 */
@property (nonatomic, copy) NSString *community;
/** 付款要求 */
@property (nonatomic, copy) NSString *require;
/** 几室几厅 */
@property (nonatomic, copy) NSString *hall;
/** 图片 */
//@property (nonatomic, copy) NSString *img_ids;
/** 出售价格 */
@property (nonatomic, assign) NSInteger rent;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger id;
/** 描述信息 */
@property (nonatomic, copy) NSString *describe;
/** 产权年限 */
@property (nonatomic, assign) NSInteger years;
/** 接通时间段 */
@property (nonatomic, copy) NSString *time_slot;
/** 手机号 */
@property (nonatomic, copy) NSString *mobile;
/** 车库楼层 */
@property (nonatomic, assign) NSInteger l_floor;
/** 车位号 */
@property (nonatomic, assign) NSInteger shelves;
/** 创建时间 */
@property (nonatomic, copy) NSString *create_time;


@end

NS_ASSUME_NONNULL_END
