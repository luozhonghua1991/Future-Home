//
//  FHCandidateListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCandidateListModel : NSObject
/** 年龄 */
@property (nonatomic, assign) NSInteger age;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 描述 */
@property (nonatomic, copy) NSString *describe;
/** 学历 */
@property (nonatomic, copy) NSString *education;
/** 选举人的id */
@property (nonatomic, assign) NSInteger id;
/** 身份证号码 */
@property (nonatomic, copy) NSString *id_number;
/** 简介 */
@property (nonatomic, copy) NSString *intro;
/** 电话号码 */
@property (nonatomic, copy) NSString *mobile;
/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** 1兼职 2q全职 */
@property (nonatomic, assign) NSInteger is_full;
/** s获取兼职全职 1男  2女 */
@property (nonatomic, copy) NSString *getFull;
/** 多少号 */
@property (nonatomic, copy) NSString *number;
/** owner_id */
@property (nonatomic, copy) NSString *owner_id;
/** pid */
@property (nonatomic, copy) NSString *pid;
/** 政治面貌 */
@property (nonatomic, copy) NSString *polity;
/** 海选票数 */
@property (nonatomic, assign) NSInteger sea_num;
/** 岗位选举票数 */
@property (nonatomic, assign) NSInteger post_num;
/** select 0 没选 1 选中 */
@property (nonatomic, assign) NSInteger select;
/** 1海选 2岗位选举 */
@property (nonatomic, copy) NSString *status;
/** sex 1男  2女 */
@property (nonatomic, copy) NSString *getSex;
/** sex 1男  2女 */
@property (nonatomic, assign) NSInteger sex;
/** 地址 */
@property (nonatomic, copy) NSString *home_num;


@end

NS_ASSUME_NONNULL_END
