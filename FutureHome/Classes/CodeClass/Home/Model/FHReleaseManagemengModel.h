//
//  FHReleaseManagemengModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHReleaseManagemengModel : NSObject
/** 住房面积 */
@property (nonatomic, copy) NSString *area;
/** 小区名字 */
@property (nonatomic, copy) NSString *community;
/** 创建时间 */
@property (nonatomic, copy) NSString *create_time;
/** 描述信息 */
@property (nonatomic, copy) NSString *describe;
/** 几室几厅 */
@property (nonatomic, copy) NSString *hall;
/** 1 房屋 2 车位 */
@property (nonatomic, copy) NSString *house_park;
/** <#assign属性注释#> */
@property (nonatomic, copy) NSString *id;
/** 图片 */
@property (nonatomic, copy) NSString *img_ids;
/** 出售价格 */
@property (nonatomic, copy) NSString *rent;
/** 付款要求 */
@property (nonatomic, copy) NSString *require;
/** 1上架 2下架 */
@property (nonatomic, copy) NSString *shelves;
/** 房屋朝向 */
@property (nonatomic, copy) NSString *toward;
/** 1出售 2出租 */
@property (nonatomic, copy) NSString *type;
/** property_id */
@property (nonatomic, copy) NSString *property_id;

@end

NS_ASSUME_NONNULL_END
