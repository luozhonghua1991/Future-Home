//
//  FHMyVideosController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMyVideosController : BaseViewController
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 1视频收藏 2生鲜视频 需要一个头部区域 */
@property (nonatomic, assign) NSInteger type;
/** 视频类型 从那边过来的 */
@property (nonatomic, copy) NSString *videoType;


@end

NS_ASSUME_NONNULL_END
