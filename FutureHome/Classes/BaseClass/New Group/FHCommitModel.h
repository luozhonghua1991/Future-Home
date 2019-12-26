//
//  FHCommitModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCommitModel : NSObject
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 创建时间 */
@property (nonatomic, copy) NSString *create_time;
/** 0是物业回复 1是自己回复 */
@property (nonatomic, copy) NSString *is_reply;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
