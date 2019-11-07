//
//  FHBaseHaveNavTabberController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "YPTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHBaseHaveNavTabberController : YPTabBarController
/** 标题名字 */
@property (nonatomic, copy) NSString *titleString;
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;

- (void)initViewControllers;

@end

NS_ASSUME_NONNULL_END
