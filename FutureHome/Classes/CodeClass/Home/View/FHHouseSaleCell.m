//
//  FHHouseSaleCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHHouseSaleCell.h"

@interface FHHouseSaleCell ()
/** 左边的图片 */
@property (nonatomic, strong) UIImageView *leftImgView;
/** 房子名称 */
@property (nonatomic, strong) UILabel *houseNameLabel;
/** 房子类型 */
@property (nonatomic, strong) UILabel *houseTypeLabel;
/** 付款要求 */
@property (nonatomic, strong) UILabel *priceSugmentLabel;
/** 价格label */
@property (nonatomic, strong) UILabel *priceLabel;


@end

@implementation FHHouseSaleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.leftImgView];
    [self.contentView addSubview:self.houseNameLabel];
    [self.contentView addSubview:self.houseTypeLabel];
    [self.contentView addSubview:self.priceSugmentLabel];
    [self.contentView addSubview:self.priceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftImgView.frame = CGRectMake(10, 10, 80, 80);
    self.houseNameLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, 20, 200, 13);
    self.houseTypeLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, MaxY(self.houseNameLabel) + 15, 200, 13);
    self.priceSugmentLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, MaxY(self.houseTypeLabel) + 15, 200, 13);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark — setter && getter
- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.image = [UIImage imageNamed:@"头像"];
    }
    return _leftImgView;
}

- (UILabel *)houseNameLabel {
    if (!_houseNameLabel) {
        _houseNameLabel = [[UILabel alloc] init];
        _houseNameLabel.font = [UIFont systemFontOfSize:13];
        _houseNameLabel.text = @"金科廊桥水乡";
        _houseNameLabel.textColor = [UIColor blackColor];
        _houseNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseNameLabel;
}

- (UILabel *)houseTypeLabel {
    if (!_houseTypeLabel) {
        _houseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (100 - 13) / 2, SCREEN_WIDTH - 10, 13)];
        _houseTypeLabel.font = [UIFont systemFontOfSize:13];
        _houseTypeLabel.text = @"一室一厅";
        _houseTypeLabel.textColor = [UIColor blackColor];
        _houseTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseTypeLabel;
}

- (UILabel *)priceSugmentLabel {
    if (!_priceSugmentLabel) {
        _priceSugmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (100 - 13) / 2, SCREEN_WIDTH - 10, 13)];
        _priceSugmentLabel.font = [UIFont systemFontOfSize:13];
        _priceSugmentLabel.text = @"付款要求:月付";
        _priceSugmentLabel.textColor = [UIColor blackColor];
        _priceSugmentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceSugmentLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (100 - 13) / 2, SCREEN_WIDTH - 10, 13)];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.text = @"￥258.00";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

@end
