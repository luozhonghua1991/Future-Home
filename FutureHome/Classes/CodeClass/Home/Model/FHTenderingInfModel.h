//
//  FHTenderingInfModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/26.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHTenderingInfModel : NSObject
/** id */
@property (nonatomic, copy) NSString *id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 时间 */
@property (nonatomic, copy) NSString *candidate_time;
/** 手机 */
@property (nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
