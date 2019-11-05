//
//  FHCircleHotPointController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHCircleHotPointController : BaseViewController
/** 是否有tabbar  默认没得 */
@property (nonatomic, assign) BOOL isHaveTabbar;
/** 是否有headerView  默认没得 */
@property (nonatomic, assign) BOOL isHaveHeaderView;
/** 1是自己 0是看的别人 2刚进来的状态*/
@property (nonatomic, assign) NSInteger personType;
/** 用户的ID */
@property (nonatomic, copy) NSString *personID;
/** 关注信息 */
@property (nonatomic, copy) NSString *follow_msg;

@end

NS_ASSUME_NONNULL_END
