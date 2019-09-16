//
//  GNRCartGoodsCell.m
//  外卖
//
//  Created by LvYuan on 2017/5/3.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import "GNRCartGoodsCell.h"
#import "GNRGoodsModel.h"
@implementation GNRCartGoodsCell


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, ([UIColor colorWithWhite:0.8 alpha:0.8]).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 0.4));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stepperSuperView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 13.5, 80, 23)];
    [self.contentView addSubview:self.stepperSuperView];
}

- (GNRCountStepper *)stepper{
    if (!_stepper) {
        _stepper = [[GNRCountStepper alloc]initWithFrame:CGRectZero style:GNRCountStepperStyleShoppingCart];
    }
    return _stepper;
}

- (void)config:(GNRGoodsModel *)goods{
    [self.stepperSuperView addSubview:self.stepper];
    [self.stepper countChangedBlock:^(NSInteger count) {
        if (goods) {
            goods.number = @(count);
            self->_priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goods.shouldPayMoney];
            if ([self->_delegate respondsToSelector:@selector(stepper:valueChangedForCount:goods:)]) {
                [self->_delegate stepper:_stepper valueChangedForCount:count goods:goods];
            }
        }
    }];
    self.stepper.count = goods.number.integerValue;
    self.nameL.text = goods.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",goods.shouldPayMoney];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews{
    self.stepper.frame = self.stepperSuperView.bounds;
}

@end
