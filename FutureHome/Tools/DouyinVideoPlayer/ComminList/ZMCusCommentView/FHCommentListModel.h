//
//  FHCommentListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  评论model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCommentListModel : NSObject
/** 评论时间 */
@property (nonatomic, copy) NSString *add_time;
/** 评论id */
@property (nonatomic, copy) NSString *comment_id;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 头像 */
@property (nonatomic, copy) NSString *form_pic;
/** 名字 */
@property (nonatomic, copy) NSString *from_name;
/** 用户uid */
@property (nonatomic, copy) NSString *from_uid;
/** id */
@property (nonatomic, copy) NSString *id;
/** 评论人的id */
@property (nonatomic, copy) NSString *reply_id;
/** 评论人头像 */
@property (nonatomic, copy) NSString *reply_pic;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *topic_id;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSArray *child;

@end

NS_ASSUME_NONNULL_END
