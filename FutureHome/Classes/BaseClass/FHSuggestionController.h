//
//  FHSuggestionController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHBaseHaveNavTabberController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHSuggestionController : FHBaseHaveNavTabberController
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** 1 物业  2 业委 */
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
