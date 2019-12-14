//
//  FHSelectGroupMemberController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHSelectGroupMemberController : BaseViewController
/** 标题 */
@property (nonatomic, copy) NSString *titleString;
/** 1创建群选择成员 2添加成员 3删除成员 */
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
