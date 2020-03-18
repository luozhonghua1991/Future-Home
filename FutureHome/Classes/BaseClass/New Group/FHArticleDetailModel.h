//
//  FHArticleDetailModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/17.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHArticleDetailModel : NSObject
/** 公告ID */
@property (nonatomic, copy) NSString *id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 跳转的URL */
@property (nonatomic, copy) NSString *path;
/** 作者 */
@property (nonatomic, copy) NSString *writer;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;
/** 评论个数 */
@property (nonatomic, copy) NSString *comment_num;
/** 预览图 */
@property (nonatomic, copy) NSString *cover;
/** 是否喜欢 */
@property (nonatomic, assign) NSInteger islike;
/** 喜欢数量 */
@property (nonatomic, copy) NSString *like_num;
/** 是否收藏 */
@property (nonatomic, assign) NSInteger iscollection;

@end

NS_ASSUME_NONNULL_END
