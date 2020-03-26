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
    self.houseNameLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, 3, SCREEN_WIDTH - (MaxX(self.leftImgView) + 10), 35);
    self.houseTypeLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, MaxY(self.houseNameLabel) + 10, 200, 13);
    self.priceSugmentLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, MaxY(self.houseTypeLabel) + 10, 200, 13);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 租赁信息的model赋值 */
- (void)setHouseListModel:(FHHouseListModel *)houseListModel {
    _houseListModel = houseListModel;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:_houseListModel.img_ids] placeholderImage:[UIImage imageNamed:@"头像"]];
}


/** 发布管理的model赋值 */
- (void)setManagementModel:(FHReleaseManagemengModel *)managementModel {
    _managementModel = managementModel;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:_managementModel.img_ids] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.houseNameLabel.text = _managementModel.community;
    self.houseTypeLabel.text = _managementModel.hall;
    self.priceSugmentLabel.text = _managementModel.require;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_managementModel.rent];
    
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
        _houseNameLabel.font = [UIFont boldSystemFontOfSize:14];
        _houseNameLabel.text = @"金科廊桥水乡";
        _houseNameLabel.textColor = [UIColor blackColor];
        _houseNameLabel.textAlignment = NSTextAlignmentLeft;
        _houseNameLabel.numberOfLines = 0;
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
