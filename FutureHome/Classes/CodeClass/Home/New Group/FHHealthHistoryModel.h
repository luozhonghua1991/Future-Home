//
//  FHHealthHistoryModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  医疗记录model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHHealthHistoryModel : NSObject
/** 症状描述 */
@property (nonatomic, copy) NSString *symptom;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 医院名称 */
@property (nonatomic, copy) NSString *hospital;
/** datebirth出生日期 */
@property (nonatomic, copy) NSString *treat_time;
/** sex 1男  2女 */
@property (nonatomic, copy) NSString *getSex;
/** sex 1男  2女 */
@property (nonatomic, assign) NSInteger sex;
/** 社保卡号 */
@property (nonatomic, copy) NSString *social_number;
/** 医疗记录id */
@property (nonatomic, copy) NSString *id;
/** 图片数组 */
@property (nonatomic, copy) NSString *img_ids;
/** 总花费 */
@property (nonatomic, copy) NSString *total_pay;
/** 主治医生 */
@property (nonatomic, copy) NSString *doctor;
/** 治疗方案 */
@property (nonatomic, copy) NSString *programme;

@end

NS_ASSUME_NONNULL_END
