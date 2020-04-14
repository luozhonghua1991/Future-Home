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
    self.LocationLabel.textColor = [UIColor blackColor];
    self.stepperSuperView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.77 - 45, (self.contentView.height - 88) / 2, 40, 88)];
//    self.stepperSuperView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.stepperSuperView];
    
    self.nameL.font = [UIFont boldSystemFontOfSize:15];
    
    self.specsLabel.frame = CGRectMake(self.nameL.x, self.nameL.y + self.nameL.size.height + 13, ZH_SCALE_SCREEN_Width(100), 13);
    [self.contentView addSubview:self.specsLabel];
    
    self.priceLabel.frame = CGRectMake(0, self.nameL.y + self.nameL.size.height + 13, SCREEN_WIDTH * 0.77 - 40, 13);
//    self.priceLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.priceLabel];
    
    self.stockLabel.frame = CGRectMake(0, self.priceLabel.y + self.priceLabel.size.height + 9, SCREEN_WIDTH * 0.77 - 40, 13);
//    self.stockLabel.backgroundColor = [UIColor redColor];
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
    self.stepper.frame = self.stepperSuperView.bounds;
}

- (void)refreshUI{
    if (!_goods) {
        return;
    }
    _nameL.text = _goods.goodsName;
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_goods.goodsImage]]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_goods.goodsPrice];
    self.LocationLabel.text = [NSString stringWithFormat:@"产地:%@",_goods.goodsPlace];
    self.specsLabel.text = [NSString stringWithFormat:@"%@",_goods.goodsUnitAtr];
    self.stockLabel.text = [NSString stringWithFormat:@"库存:%@",_goods.goodsSafetStock];
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
        _specsLabel.font = [UIFont systemFontOfSize:13];
        _specsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _specsLabel;
}

/** 库存 */
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] init];
        _stockLabel.text = @"库存:300只";
        _stockLabel.font = [UIFont systemFontOfSize:13];
        _stockLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stockLabel;
}

/** 价格 */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"￥9.8 元/份";
        _priceLabel.font = [UIFont boldSystemFontOfSize:13];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = [UIColor redColor];
    }
    return _priceLabel;
}

@end
