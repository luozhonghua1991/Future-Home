//
//  UIControl+UIControl_buttonCon.h
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/27.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define defaultInterval 1.0//默认时间间隔
@interface UIControl (UIControl_buttonCon)
@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击
@end

NS_ASSUME_NONNULL_END
