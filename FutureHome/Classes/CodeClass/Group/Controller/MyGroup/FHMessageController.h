//
//  FHMessageController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMessageController : RCConversationListViewController
/** 个人 还是 群聊 */
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
