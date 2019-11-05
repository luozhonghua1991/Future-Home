//
//  FHSuggestionListController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHSuggestionListController : BaseViewController
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** 1 物业  2 业委 */
@property (nonatomic, assign) NSInteger type;
/** 是否是自己的回复 */
@property (nonatomic, assign) BOOL isSelf;

@end

NS_ASSUME_NONNULL_END
