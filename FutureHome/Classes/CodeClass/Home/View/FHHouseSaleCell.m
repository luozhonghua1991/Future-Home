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
    self.houseNameLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, 3, SCREEN_WIDTH - (MaxX(self.leftImgView) + 10), 37);
    self.houseTypeLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, MaxY(self.houseNameLabel) + 10, 200, 14);
    self.priceSugmentLabel.frame = CGRectMake(MaxX(self.leftImgView) + 10, MaxY(self.houseTypeLabel) + 10, 200, 14);
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
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:_houseListModel.img_ids] placeholderImage:nil];
}


/** 发布管理的model赋值 */
- (void)setManagementModel:(FHReleaseManagemengModel *)managementModel {
    _managementModel = managementModel;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:_managementModel.img_ids] placeholderImage:nil];
    self.houseNameLabel.text = _managementModel.community;
    if ([_managementModel.house_park integerValue] == 1) {
        /** 房屋 */
        if ([_managementModel.type integerValue] == 1) {
            /** 出售 */
            self.houseTypeLabel.text = [NSString stringWithFormat:@"房屋户型: %@",_managementModel.hall];
            self.priceSugmentLabel.text = [NSString stringWithFormat:@"房屋面积 :%.2f㎡",[_managementModel.area floatValue]];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@万/套",_managementModel.rent];
        } else if ([_managementModel.type integerValue] == 2) {
            /** 出租 */
            self.houseTypeLabel.text = [NSString stringWithFormat:@"房屋户型: %@",_managementModel.hall];
            self.priceSugmentLabel.text = [NSString stringWithFormat:@"房屋面积 :%.2f㎡",[_managementModel.area floatValue]];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@元/月",_managementModel.rent];
        }
    } else {
        /** 车位 */
        if ([_managementModel.type integerValue] == 1) {
            /** 出售 */
            self.houseTypeLabel.text = [NSString stringWithFormat:@"车位编号: %@",_managementModel.park_number];
            self.priceSugmentLabel.text = [NSString stringWithFormat:@"车位面积 :%.2f㎡",[_managementModel.area floatValue]];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@万/个",_managementModel.rent];
        } else {
            /** 出租 */
            self.houseTypeLabel.text = [NSString stringWithFormat:@"车位编号: %@",_managementModel.park_number];
            self.priceSugmentLabel.text = [NSString stringWithFormat:@"车位面积 :%.2f㎡",[_managementModel.area floatValue]];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@元/月",_managementModel.rent];
        }
    }
    
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
        _houseNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _houseNameLabel.text = @"金科廊桥水乡";
        _houseNameLabel.textColor = [UIColor blackColor];
        _houseNameLabel.textAlignment = NSTextAlignmentLeft;
        _houseNameLabel.numberOfLines = 0;
    }
    return _houseNameLabel;
}

- (UILabel *)houseTypeLabel {
    if (!_houseTypeLabel) {
        _houseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (100 - 13) / 2, SCREEN_WIDTH - 10, 14)];
        _houseTypeLabel.font = [UIFont systemFontOfSize:14];
        _houseTypeLabel.text = @"一室一厅";
        _houseTypeLabel.textColor = [UIColor blackColor];
        _houseTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseTypeLabel;
}

- (UILabel *)priceSugmentLabel {
    if (!_priceSugmentLabel) {
        _priceSugmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (100 - 13) / 2, SCREEN_WIDTH - 10, 14)];
        _priceSugmentLabel.font = [UIFont systemFontOfSize:14];
        _priceSugmentLabel.text = @"付款要求:月付";
        _priceSugmentLabel.textColor = [UIColor blackColor];
        _priceSugmentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceSugmentLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (100 - 13) / 2, SCREEN_WIDTH - 10, 14)];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.text = @"￥258.00";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

@end
