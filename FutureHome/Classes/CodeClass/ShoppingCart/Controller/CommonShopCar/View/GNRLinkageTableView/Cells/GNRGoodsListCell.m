//
//  GNRGoodsListCell.m
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import "GNRGoodsListCell.h"

@implementation GNRGoodsListCell

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, ([UIColor colorWithWhite:0.8 alpha:0.8]).CGColor);
    CGContextStrokeRect(context, CGRectMake(16, rect.size.height, rect.size.width, 0.4));
}

- (GNRCountStepper *)stepper{
    if (!_stepper) {
        _stepper = [[GNRCountStepper alloc] initWithFrame:CGRectZero style:GNRCountStepperStyleGoodsList];
    }
    return _stepper;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stepperSuperView = [[UIView alloc] initWithFrame:CGRectMake(ZH_SCALE_SCREEN_Width(250), (self.contentView.height - 88) / 2, 30, 88)];
    [self.contentView addSubview:self.stepperSuperView];
    
    self.specsLabel.frame = CGRectMake(self.nameL.x, self.nameL.y + self.nameL.size.height + 13, ZH_SCALE_SCREEN_Width(80), 12);
    [self.contentView addSubview:self.specsLabel];
    
    self.priceLabel.frame = CGRectMake(0, self.nameL.y + self.nameL.size.height + 13, self.contentView.width - (ZH_SCALE_SCREEN_Width(40) + self.stepperSuperView.size.width), 12);
    [self.contentView addSubview:self.priceLabel];
    
    self.stockLabel.frame = CGRectMake(0, self.priceLabel.y + self.priceLabel.size.height + 17, self.contentView.width - (ZH_SCALE_SCREEN_Width(40) + self.stepperSuperView.size.width), 12);
    [self.contentView addSubview:self.stockLabel];
    
    [self.stepperSuperView addSubview:self.stepper];
    [self.stepper countChangedBlock:^(NSInteger count) {
        if (self->_goods) {
            self->_goods.number = @(count);
            if ([self->_delegate respondsToSelector:@selector(stepper:valueChangedForCount:goods:)]) {
                [self->_delegate stepper:self->_stepper valueChangedForCount:count goods:self->_goods];
            }
        }
    }];
    __weak typeof(self) wself = self;
    [wself.stepper addActionBlock:^(UIButton * btn) {
        if ([wself.delegate respondsToSelector:@selector(stepper:addSender:cell:)]) {
            [wself.delegate stepper:wself.stepper addSender:btn cell:wself];
        }
    }];
    [wself.stepper subActionBlock:^(UIButton * btn) {
        if ([wself.delegate respondsToSelector:@selector(stepper:subSender:cell:)]) {
            [wself.delegate stepper:wself.stepper subSender:btn cell:wself];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoods:(GNRGoodsModel *)goods{
    _goods = goods;
    [self refreshUI];
}

- (void)layoutSubviews{
//    self.stepper.center = CGPointMake(_stepperSuperView.bounds.size.width/2.0, _stepperSuperView.bounds.size.height/2.0);
    self.stepper.frame = self.stepperSuperView.bounds;
}

- (void)refreshUI{
    if (!_goods) {
        return;
    }
    _nameL.text = _goods.goodsName;
    self.LocationLabel.text = @"产地：越南";
    /** 价格 */
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_goods.goodsPrice];
    _stepper.count = _goods.number.integerValue;
}

#pragma mark — setter && getter
/** 规格 */
- (UILabel *)specsLabel {
    if (!_specsLabel) {
        _specsLabel = [[UILabel alloc] init];
        _specsLabel.text = @"700-800g/份";
        _specsLabel.font = [UIFont systemFontOfSize:12];
        _specsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _specsLabel;
}

/** 库存 */
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] init];
        _stockLabel.text = @"库存:300只";
        _stockLabel.font = [UIFont systemFontOfSize:12];
        _stockLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stockLabel;
}

/** 价格 */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"￥9.8 元/份";
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

@end