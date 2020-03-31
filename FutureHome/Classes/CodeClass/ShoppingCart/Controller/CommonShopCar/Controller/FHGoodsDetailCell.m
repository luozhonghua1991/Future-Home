//
//  FHGoodsDetailCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/10.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHGoodsDetailCell.h"

@interface FHGoodsDetailCell ()
/** 上面的线 */
@property (nonatomic, strong) UIView *topLineView;
/** 标题名字 */
@property (nonatomic, strong) UILabel *titleNameLabel;
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** 产地 */
@property (nonatomic, strong) UILabel *producingAreaLabel;
/** 商品原价 */
@property (nonatomic, strong) UILabel *oldPriceLabel;
/** 付款要求 */
@property (nonatomic, strong) UILabel *dayCountLabel;
/** 商品描述 */
@property (nonatomic, strong) UILabel *goodsInfoLabel;
/** 规格 */
@property (nonatomic, strong) UILabel *typeLabel;
/** 售价 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 库存 */
@property (nonatomic, strong) UILabel *allCountLabel;

@end

@implementation FHGoodsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.titleNameLabel];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.producingAreaLabel];
    [self.contentView addSubview:self.oldPriceLabel];
    [self.contentView addSubview:self.dayCountLabel];
    [self.contentView addSubview:self.goodsInfoLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.allCountLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topLineView.frame = CGRectMake(0, 5, ScreenWidth, 0.5);
    self.titleNameLabel.frame = CGRectMake(10, MaxY(self.topLineView) + 17, SCREEN_WIDTH - 200, 16);
    self.bottomLineView.frame = CGRectMake(0, MaxY(self.titleNameLabel) + 20, SCREEN_WIDTH, 0.5);
    
    self.producingAreaLabel.frame = CGRectMake(10, MaxY(self.bottomLineView) + 20, SCREEN_WIDTH - 200, 15);
    self.oldPriceLabel.frame = CGRectMake(10, MaxY(self.producingAreaLabel) + 20, SCREEN_WIDTH - 200, 15);
    self.dayCountLabel.frame = CGRectMake(10, MaxY(self.oldPriceLabel) + 20, SCREEN_WIDTH - 200, 15);
    self.typeLabel.frame = CGRectMake(SCREEN_WIDTH / 2, MaxY(self.bottomLineView) + 20, SCREEN_WIDTH / 2, 15);
    self.priceLabel.frame = CGRectMake(SCREEN_WIDTH / 2, MaxY(self.typeLabel) + 20, SCREEN_WIDTH / 2, 15);
    self.allCountLabel.frame = CGRectMake(SCREEN_WIDTH / 2, MaxY(self.priceLabel) + 20, SCREEN_WIDTH / 2, 15);
}


- (void)setGoodsDetailModel:(FHGoodsDetailModel *)goodsDetailModel {
    _goodsDetailModel = goodsDetailModel;
    if (_goodsDetailModel == nil) {
        return;
    }
    self.titleNameLabel.text = _goodsDetailModel.title;
    self.producingAreaLabel.text = [NSString stringWithFormat:@"产地:%@",_goodsDetailModel.Place];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"商品原价:%.2f元",_goodsDetailModel.origin_price];
    if (_goodsDetailModel.Isrestrictions == 0) {
        self.dayCountLabel.text = [NSString stringWithFormat:@"是否限购:不限"];
    } else if (_goodsDetailModel.Isrestrictions == 1) {
        self.dayCountLabel.text = [NSString stringWithFormat:@"是否限购:限购%@",_goodsDetailModel.limit_num];
    }
    self.typeLabel.text = [NSString stringWithFormat:@"规格:%@",_goodsDetailModel.UnitAtr];
    self.priceLabel.text = [NSString stringWithFormat:@"售价:%@元",_goodsDetailModel.sell_price];
    self.allCountLabel.text = [NSString stringWithFormat:@"库存:%@",_goodsDetailModel.SafetStock];
    self.goodsInfoLabel.text = [NSString stringWithFormat:@"商品描述:\n\n%@",_goodsDetailModel.desc];
    CGSize size = [UIlabelTool sizeWithString:self.goodsInfoLabel.text font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    self.goodsInfoLabel.frame = CGRectMake(10, MaxY(self.dayCountLabel) + 20, SCREEN_WIDTH - 15, size.height);
    [SingleManager shareManager].goodsDetailHeight = MaxY(self.goodsInfoLabel) + 5;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark — setter && getter
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleNameLabel.text = @"车位大甩卖";
        _titleNameLabel.textColor = [UIColor blackColor];
        _titleNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleNameLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UILabel *)producingAreaLabel {
    if (!_producingAreaLabel) {
        _producingAreaLabel = [[UILabel alloc] init];
        _producingAreaLabel.font = [UIFont systemFontOfSize:15];
        _producingAreaLabel.text = @"产地:";
        _producingAreaLabel.textColor = [UIColor blackColor];
        _producingAreaLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _producingAreaLabel;
}

- (UILabel *)oldPriceLabel {
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] init];
        _oldPriceLabel.font = [UIFont systemFontOfSize:15];
        _oldPriceLabel.text = @"商品原价:";
        _oldPriceLabel.textColor = [UIColor blackColor];
        _oldPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _oldPriceLabel;
}

- (UILabel *)dayCountLabel {
    if (!_dayCountLabel) {
        _dayCountLabel = [[UILabel alloc] init];
        _dayCountLabel.font = [UIFont systemFontOfSize:15];
        _dayCountLabel.text = @"每日限购:";
        _dayCountLabel.textColor = [UIColor blackColor];
        _dayCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dayCountLabel;
}

- (UILabel *)goodsInfoLabel {
    if (!_goodsInfoLabel) {
        _goodsInfoLabel = [[UILabel alloc] init];
        _goodsInfoLabel.font = [UIFont systemFontOfSize:15];
        _goodsInfoLabel.text = @"商品描述:";
        _goodsInfoLabel.textColor = [UIColor blackColor];
        _goodsInfoLabel.numberOfLines = 0;
        _goodsInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsInfoLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:15];
        _typeLabel.text = @"规格:";
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.text = @"售价:";
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

- (UILabel *)allCountLabel {
    if (!_allCountLabel) {
        _allCountLabel = [[UILabel alloc] init];
        _allCountLabel.font = [UIFont systemFontOfSize:15];
        _allCountLabel.text = @"库存:";
        _allCountLabel.textColor = [UIColor blackColor];
        _allCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _allCountLabel;
}

@end
