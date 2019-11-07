//
//  FHCommonFollowModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCommonFollowModel : NSObject
/** 签名 */
@property (nonatomic, copy) NSString *autograph;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 距离 */
@property (nonatomic, copy) NSString *distance;
/** 粉丝数 */
@property (nonatomic, copy) NSString *fans_num;
/** 粉丝数 */
@property (nonatomic, copy) NSString *follow_num;
/** id */
@property (nonatomic, copy) NSString *id;
/** 收藏的主键 */
@property (nonatomic, copy) NSString *cid;
/** 是否收藏 0未收藏 1已收藏 */
@property (nonatomic, copy) NSString *is_collect;
/** 名字 */
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
