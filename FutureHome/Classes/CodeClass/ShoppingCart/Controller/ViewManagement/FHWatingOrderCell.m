//
//  FHWatingOrderCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHWatingOrderCell.h"
#import "FHOrderListModel.h"
#import "GNRGoodsModel.h"

@implementation FHWatingOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
//    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.shopImgView];
    [self.contentView addSubview:self.shopNameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.allPriceLabel];
//    [self.contentView addSubview:self.bottomLineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shopImgView.frame = CGRectMake(10, 0, 55, 55);
    self.shopImgView.centerY = self.contentView.height / 2;
    self.shopNameLabel.frame = CGRectMake(MaxX(self.shopImgView) + 10, 25, 200, 15);
    self.contentLabel.frame = CGRectMake(MaxX(self.shopImgView) + 10, MaxY(self.shopNameLabel) + 10, 200, 13);
    self.allPriceLabel.frame = CGRectMake(0, MaxY(self.shopNameLabel) + 5, SCREEN_WIDTH - 10, 13);
}

- (void)setOrderModel:(FHOrderListModel *)orderModel {
    _orderModel = orderModel;
    [self.shopImgView sd_setImageWithURL:[NSURL URLWithString:_orderModel.cover] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.shopNameLabel.text = _orderModel.productname;
    self.contentLabel.text = [NSString stringWithFormat:@"￥%@x%@",_orderModel.sell_price,_orderModel.number];
    CGFloat allPrice = [_orderModel.sell_price floatValue] * [_orderModel.number integerValue];
    self.allPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f",allPrice];
}

- (void)setGoodsModel:(GNRGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.shopImgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImage] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.shopNameLabel.text = _goodsModel.goodsName;
    self.contentLabel.text = [NSString stringWithFormat:@"￥%@x%@",_goodsModel.goodsPrice,_goodsModel.number];
    CGFloat allPrice = [_goodsModel.goodsPrice floatValue] * [_goodsModel.number integerValue];
    self.allPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f",allPrice];
}


#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UIImageView *)shopImgView {
    if (!_shopImgView) {
        _shopImgView = [[UIImageView alloc] init];
        _shopImgView.image = [UIImage imageNamed:@"头像"];
    }
    return _shopImgView;
}

- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.textAlignment = NSTextAlignmentLeft;
        _shopNameLabel.font = [UIFont systemFontOfSize:15];
        _shopNameLabel.textColor = [UIColor blackColor];
#warning message
        _shopNameLabel.text = @"商品的标题";
    }
    return _shopNameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor blackColor];
#warning message
        _contentLabel.text = @"￥60x2";
    }
    return _contentLabel;
}

- (UILabel *)allPriceLabel {
    if (!_allPriceLabel) {
        _allPriceLabel = [[UILabel alloc] init];
        _allPriceLabel.textAlignment = NSTextAlignmentRight;
        _allPriceLabel.font = [UIFont systemFontOfSize:13];
        _allPriceLabel.textColor = [UIColor blackColor];
#warning message
        _allPriceLabel.text = @"￥120";
    }
    return _allPriceLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
