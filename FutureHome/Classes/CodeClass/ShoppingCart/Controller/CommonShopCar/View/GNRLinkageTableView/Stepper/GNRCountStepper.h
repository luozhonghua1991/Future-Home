//
//  GNRCountStepper.h
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNRCartDefine.h"

@interface GNRCountStepper : UIView

/** 0不限购 1限购 */
@property (nonatomic, assign) NSInteger Isrestrictions;
/** 当前用户总共购买的数量 */
@property (nonatomic, assign) NSInteger buyNum;
/** 限购的数量 */
@property (nonatomic, assign) NSInteger limit_num;

@property (nonatomic, strong)UIButton * subBtn;
@property (nonatomic, strong)UIButton * addBtn;
@property (nonatomic, strong)UILabel * numberL;

@property (nonatomic, assign)NSInteger count;
@property (nonatomic, assign)GNRCountStepperStyle style;
- (instancetype)initWithFrame:(CGRect)frame
                        style:(GNRCountStepperStyle )style;

- (void)countChangedBlock:(void(^)(NSInteger count))block;
- (void)addActionBlock:(void(^)(UIButton *))block;
- (void)subActionBlock:(void(^)(UIButton *))block;
// block
@property (nonatomic, copy) void(^block)(NSInteger count);
// 加
@property (nonatomic, copy) void(^addActionBlock)(UIButton * btn);
//减
@property (nonatomic, copy) void(^subActionBlock)(UIButton * btn);

@end
