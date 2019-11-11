//
//  ZFTableData.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/24.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface ZFTableData : NSObject
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *dataID;
/** <#copy属性注释#> */
@property (nonatomic, assign) NSInteger pid;
/** <#copy属性注释#> */
@property (nonatomic, assign) NSInteger aid;

@property (nonatomic, copy) NSString *nick_name;
//@property (nonatomic, copy) NSString *head;
//@property (nonatomic, assign) NSInteger agree_num;
//@property (nonatomic, assign) NSInteger share_num;
//@property (nonatomic, assign) NSInteger post_num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat thumbnail_width;
@property (nonatomic, assign) CGFloat thumbnail_height;
//@property (nonatomic, assign) CGFloat video_duration;
/** 视频宽度 */
@property (nonatomic, assign) CGFloat video_width;
/** 视频高度 */
@property (nonatomic, assign) CGFloat video_height;

@property (nonatomic, copy) NSString *thumbnail_url;
/** 视频链接 */
@property (nonatomic, copy) NSString *video_url;
/** 0不喜欢  1喜欢 */
@property (nonatomic, assign) NSInteger islike;
/** 0未收藏 1已收藏 */
@property (nonatomic, assign) NSInteger isconnection;
/** 点赞数量 */
@property (nonatomic, copy) NSString *like;
/** 评论数 */
@property (nonatomic, copy) NSString *comment;

@end
