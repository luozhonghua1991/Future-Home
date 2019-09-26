//
//  FHMentalHealthController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHBaseHaveNavTabberController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMentalHealthController : FHBaseHaveNavTabberController
/** 获取VC ID */
@property (nonatomic, assign) NSInteger ID;
/** 获取类型 */
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
