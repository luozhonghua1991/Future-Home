//
//  FHMyPhotoController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMyPhotoController : BaseViewController
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** type 1 是没有tabbar的 */
@property (nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END
