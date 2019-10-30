//
//  GNRCountStepper.m
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//  列表的Cel


#import "GNRCountStepper.h"

@interface GNRCountStepper ()
{
    CGFloat Height_MAX;
    CGFloat Width_MAX;
    CGFloat Width_Btn;
    CGFloat Width_Lab;
    CGRect BOUNDS_SIZE;
}


@end

@implementation GNRCountStepper

- (instancetype)init{
    if (self = [super init]) {
        [self initData];
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(GNRCountStepperStyle )style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        [self initData];
        [self installUI];
    }
    return self;
}

- (void)initData {
    Width_Btn = 23.f;
    Width_Lab = 30.f;
    Width_MAX = Width_Lab + Width_Btn*2.f;
    Height_MAX = 30.f;
    if (self.style == GNRCountStepperStyleShoppingCart) {
        BOUNDS_SIZE = CGRectMake(0, 0, Width_MAX, Height_MAX);
        self.bounds = BOUNDS_SIZE;
    } else {
        BOUNDS_SIZE = CGRectMake(0, 0, Height_MAX, Width_MAX);
        self.bounds = CGRectMake(0,0,60,88);
//        self.bounds = BOUNDS_SIZE;
    }
    
}

- (void)installUI {
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subBtn setImage:[UIImage imageNamed:@"shoplist_stepper_sub_icon"] forState:UIControlStateNormal];
    [_subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_subBtn];

    _numberL = [[UILabel alloc] init];
    _numberL = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 23, 23)];
    _numberL.textColor = [UIColor blackColor];
    _numberL.textAlignment = NSTextAlignmentCenter;
    _numberL.text = @"1";
    _numberL.font = [UIFont systemFontOfSize:13];
    [self addSubview:_numberL];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"shoplist_stepper_add_icon"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    [_subBtn setImage:[UIImage imageNamed:self.style==GNRCountStepperStyleGoodsList?@"shoplist_stepper_sub_icon":@"shoplist_stepper_subred_icon"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:self.style==GNRCountStepperStyleGoodsList?@"shoplist_stepper_add_icon":@"shoplist_stepper_addred_icon"] forState:UIControlStateNormal];
    
    if (self.style == GNRCountStepperStyleShoppingCart) {
        _subBtn.frame = CGRectMake(3, 0, Width_Btn, Width_Btn);
        _addBtn.frame = CGRectMake(_numberL.frame.origin.x+_numberL.frame.size.width + 3, _subBtn.frame.origin.y, Width_Btn, Width_Btn);
    } else {
        _addBtn.frame = CGRectMake(4, 5, 60, Width_Btn);
        _numberL.frame = CGRectMake((60 - Width_Lab) / 2 + 2, _addBtn.frame.origin.y+_addBtn.frame.size.height, Width_Lab, Height_MAX);
        _subBtn.frame = CGRectMake(_addBtn.frame.origin.x, _numberL.frame.origin.y+_numberL.frame.size.height , 60, Width_Btn);
        
    }
}

- (void)setCount:(NSInteger)count {
    _count = count;
    if (count<=0) {
        _subBtn.hidden = YES;
        _numberL.text = @"";
    }else{
        _subBtn.hidden = NO;
        _numberL.text = @(count).stringValue;
    }
    [SingleManager shareManager].numberButton.currentNumber = _count;
}

- (void)countChangedBlock:(void(^)(NSInteger count))block{
    self.block = nil;
    self.block = [block copy];
}

- (void)addActionBlock:(void (^)(UIButton *))block{
    self.addActionBlock = nil;
    self.addActionBlock = [block copy];
}

- (void)subActionBlock:(void(^)(UIButton *))block{
    self.subActionBlock = nil;
    self.subActionBlock = [block copy];
}

- (void)subBtnAction:(id)sender{
    if (_count>0) {
        self.count--;
    }
    if (self.block) {
        self.block(_count);
    }
    
    if (self.subActionBlock) {
        self.subActionBlock(sender);
    }
}

- (void)addBtnAction:(id)sender{
    self.count++;
    
    if (self.block) {
        self.block(_count);
    }
    if (self.addActionBlock) {
        self.addActionBlock(sender);
    }
}

@end
