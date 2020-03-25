//
//  FHHouseListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHHouseListModel : NSObject
/** 住房面积 */
@property (nonatomic, copy) NSString *area;
/** 小区名字 */
@property (nonatomic, copy) NSString *community;
/** 付款要求 */
@property (nonatomic, copy) NSString *require;
/** 几室几厅 */
@property (nonatomic, copy) NSString *hall;
/** 图片 */
@property (nonatomic, copy) NSString *img_ids;
/** 出售价格 */
@property (nonatomic, copy) NSString *rent;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger id;
/** 车位编号 */
@property (nonatomic, copy) NSString *park_number;


@end

NS_ASSUME_NONNULL_END
