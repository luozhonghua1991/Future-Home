//
//  UIButton+countDown.h
//  CountDownButtonDemo
//
//  Created by bear on 16/6/17.
//  Copyright © 2016年 bear. All rights reserved.
//  验证码倒计时

#import <UIKit/UIKit.h>

@interface UIButton (countDown)

@property (nonatomic, strong) NSString *countDownFormat;

-(void)countDownWithTimeInterval:(NSTimeInterval) duration;

@end
