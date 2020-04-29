//
//  FHScrollNewsController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHScrollNewsController : BaseViewController
/** 滚动消息数据 */
@property (nonatomic, copy) NSArray *listInfoArrs;
/** 类型 1主页 2健康 3理财 4客服 */
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
