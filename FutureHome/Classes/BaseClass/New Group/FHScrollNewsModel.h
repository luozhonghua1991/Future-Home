//
//  FHScrollNewsModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHScrollNewsModel : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *coverthumb;
/** id */
@property (nonatomic, copy) NSString *id;
/** 阅读量 */
@property (nonatomic, copy) NSString *browse;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 更新时间 */
@property (nonatomic, copy) NSString *insert_time;
/** 跳转链接 */
@property (nonatomic, copy) NSString *singpage;

@end

NS_ASSUME_NONNULL_END
