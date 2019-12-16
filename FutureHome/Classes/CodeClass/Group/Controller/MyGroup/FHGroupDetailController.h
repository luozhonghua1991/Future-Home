//
//  FHGroupDetailController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHGroupDetailController : BaseViewController
/** 群ID */
@property (nonatomic, copy) NSString *groupID;
/** 群名字 */
@property (nonatomic, strong) NSString *groupName;

@end

NS_ASSUME_NONNULL_END
