//
//  FHCommitDetailController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/19.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHCommitDetailController : UIViewController
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 帖子id */
@property (nonatomic, copy) NSString *ID;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** 1 物业  2 业委 3 朋友圈*/
@property (nonatomic, assign) NSInteger type;
/** 是否能评论 */
@property (nonatomic, assign) BOOL isCanCommit;
/** 传过来的评论数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** 传过来的评论数据 */
@property (nonatomic, strong) NSDictionary *dongTaiDataDic;

@end

NS_ASSUME_NONNULL_END
