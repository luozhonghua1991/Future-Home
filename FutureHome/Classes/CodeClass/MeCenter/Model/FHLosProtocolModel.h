//
//  FHLosProtocolModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  获取协议model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHLosProtocolModel : NSObject
/** 折扣率 */
@property (nonatomic, copy) NSString *discount;
/** 开通物业费价格 */
@property (nonatomic, copy) NSString *open;
/** 折扣价 */
@property (nonatomic, copy) NSString *price;
/** 看协议的价格 */
@property (nonatomic, copy) NSString *protocol;
/** 外层提示1 */
@property (nonatomic, copy) NSString *tip1;
/** 外层提示2 */
@property (nonatomic, copy) NSString *tip2;

@end

NS_ASSUME_NONNULL_END
