//
//  FHFollowListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHFollowListModel : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 创建时间 */
@property (nonatomic, copy) NSString *create_time;
/** id */
@property (nonatomic, copy) NSString *follow_id;
/** 关注信息 */
@property (nonatomic, copy) NSString *follow_msg;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 用户编号 */
@property (nonatomic, copy) NSString *username;
/** 关注 */
@property (nonatomic, copy) NSString *follower;
/** id */
@property (nonatomic, copy) NSString *id;


@end

NS_ASSUME_NONNULL_END
