//
//  FHCommitDetailController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/19.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHCommitDetailController : BaseViewController
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 帖子id */
@property (nonatomic, copy) NSString *ID;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** 1 物业  2 业委 */
@property (nonatomic, assign) NSInteger type;
/** 是否能评论 */
@property (nonatomic, assign) BOOL isCanCommit;
/** 传过来的评论数据 */
@property (nonatomic, strong) NSDictionary *dataDic;


@end

NS_ASSUME_NONNULL_END
