//
//  FHAuthModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHAuthModel : NSObject
/** 住房面积 */
@property (nonatomic, assign) NSInteger area;
/** 地址 */
@property (nonatomic, copy) NSString *area_id;
/** 1是认证 0是未认证 */
@property (nonatomic, assign) NSInteger audit_status;
/** 房屋在多少栋 */
@property (nonatomic, assign) NSInteger build_num;
/** 小区名称 */
@property (nonatomic, copy) NSString *cell_name;
/** 城市 */
@property (nonatomic, copy) NSString *city_id;
/** 创建时间 */
@property (nonatomic, copy) NSString *create_time;
/** 身份证号 */
@property (nonatomic, copy) NSString *id_num;
/** 手机号码 */
@property (nonatomic, copy) NSString *mobile;
/** 1审核中 2审核通过 3是审核失败 */
@property (nonatomic, assign) NSInteger is_auth;
/** 业主姓名 */
@property (nonatomic, copy) NSString *name;
/** 省 */
@property (nonatomic, copy) NSString *province_id;
/** 房间号 */
@property (nonatomic, assign) NSInteger room_num;
/** 街道名 */
@property (nonatomic, copy) NSString *street_name;

@end

NS_ASSUME_NONNULL_END
