//
//  FHCarSaleCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  车位出售cell

#import "FHCarSaleCell.h"

@interface FHCarSaleCell ()
/** 标题名字 */
@property (nonatomic, strong) UILabel *titleNameLabel;

/** 价格label */
@property (nonatomic, strong) UILabel *priceLabe;
/** 价格label */
@property (nonatomic, strong) UILabel *priceLogoLabe;

/** 车位label */
@property (nonatomic, strong) UILabel *carNumberLabel;
/** 车位label */
@property (nonatomic, strong) UILabel *carNumberLogoLabel;

/** 大小label */
@property (nonatomic, strong) UILabel *areaLabel;
/** 大小label */
@property (nonatomic, strong) UILabel *areaLogoLabel;

/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *lineView;

/** 车库楼层 */
@property (nonatomic, strong) UILabel *carNumerLouLabel;
/** 建筑时间 */
@property (nonatomic, strong) UILabel *buildTimeLabel;
/** 付款要求 */
@property (nonatomic, strong) UILabel *payTypeLabel;
/**补充信息 */
@property (nonatomic, strong) UILabel *otherInfoLabel;
/** 产权年限 */
@property (nonatomic, strong) UILabel *yearLabel;
/** 联系电话 */
@property (nonatomic, strong) UILabel *phoneLabel;
/** 接听时段 */
@property (nonatomic, strong) UILabel *callPhoneLabel;


@end

@implementation FHCarSaleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.titleNameLabel];
    
    [self.contentView addSubview:self.priceLabe];
    [self.contentView addSubview:self.priceLogoLabe];
    
    [self.contentView addSubview:self.carNumberLabel];
    [self.contentView addSubview:self.carNumberLogoLabel];
    
    [self.contentView addSubview:self.areaLabel];
    [self.contentView addSubview:self.areaLogoLabel];
    
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.carNumerLouLabel];
    [self.contentView addSubview:self.buildTimeLabel];
    [self.contentView addSubview:self.payTypeLabel];
    [self.contentView addSubview:self.otherInfoLabel];
    
    [self.contentView addSubview:self.yearLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.callPhoneLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleNameLabel.frame = CGRectMake(0, 15, SCREEN_WIDTH - 200, 15);
    
    self.priceLabe.frame = CGRectMake(0, MaxY(self.titleNameLabel) + 15, SCREEN_WIDTH - 200, 15);
    self.priceLogoLabe.frame = CGRectMake(2, MaxY(self.priceLabe) + 5, SCREEN_WIDTH - 200, 14);
    
    self.carNumberLabel.frame = CGRectMake(0, MaxY(self.titleNameLabel) + 15, SCREEN_WIDTH, 15);
    self.carNumberLogoLabel.frame = CGRectMake(0, MaxY(self.carNumberLabel) + 5, SCREEN_WIDTH, 14);
    
    self.areaLabel.frame = CGRectMake(0, MaxY(self.titleNameLabel) + 15, SCREEN_WIDTH - 10, 15);
    self.areaLogoLabel.frame = CGRectMake(2, MaxY(self.areaLabel) + 5, SCREEN_WIDTH - 10, 14);
    
    self.lineView.frame = CGRectMake(0, MaxY(self.priceLogoLabe) + 20, SCREEN_WIDTH, 0.5);
    
    self.carNumerLouLabel.frame = CGRectMake(5, MaxY(self.lineView) + 20, SCREEN_WIDTH - 200, 13);
    self.buildTimeLabel.frame = CGRectMake(5, MaxY(self.carNumerLouLabel) + 15, SCREEN_WIDTH - 200, 13);
    self.payTypeLabel.frame = CGRectMake(5, MaxY(self.buildTimeLabel) + 15, SCREEN_WIDTH - 200, 13);
    self.otherInfoLabel.frame = CGRectMake(5, MaxY(self.payTypeLabel) + 15, SCREEN_WIDTH - 200, 13);
    
    self.yearLabel.frame = CGRectMake(SCREEN_WIDTH - 150, MaxY(self.lineView) + 20, SCREEN_WIDTH - 200, 13);
    self.phoneLabel.frame = CGRectMake(SCREEN_WIDTH - 150, MaxY(self.yearLabel) + 15, SCREEN_WIDTH - 200, 13);
    self.callPhoneLabel.frame = CGRectMake(SCREEN_WIDTH - 150, MaxY(self.phoneLabel) + 15, SCREEN_WIDTH - 200, 13);
}


- (void)setDetailModel:(FHListDetailModel *)detailModel {
    _detailModel = detailModel;
    self.titleNameLabel.text = _detailModel.community;
    self.priceLabe.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.rent];
    self.carNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.shelves];
    self.areaLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.area];
    self.carNumerLouLabel.text = [NSString stringWithFormat:@"车库楼层: 富%ld楼",(long)_detailModel.shelves];
    self.buildTimeLabel.text = [NSString stringWithFormat:@"建筑时间: %@",_detailModel.create_time];
    self.payTypeLabel.text = [NSString stringWithFormat:@"付款要求: %@",_detailModel.require];
    self.otherInfoLabel.text = [NSString stringWithFormat:@"补充信息: \n%@",_detailModel.describe];
    self.yearLabel.text = [NSString stringWithFormat:@"产权年限: %ld年",(long)_detailModel.years];
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话: %@",_detailModel.mobile];
    self.callPhoneLabel.text = [NSString stringWithFormat:@"接听时段: %@",_detailModel.time_slot];
}


#pragma mark — setter && getter
- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleNameLabel.text = @"车位大甩卖";
        _titleNameLabel.textColor = [UIColor blackColor];
        _titleNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleNameLabel;
}


- (UILabel *)priceLabe {
    if (!_priceLabe) {
        _priceLabe = [[UILabel alloc] init];
        _priceLabe.font = [UIFont boldSystemFontOfSize:15];
        _priceLabe.text = @"￥866600.00";
        _priceLabe.textColor = [UIColor redColor];
        _priceLabe.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabe;
}

- (UILabel *)priceLogoLabe {
    if (!_priceLogoLabe) {
        _priceLogoLabe = [[UILabel alloc] init];
        _priceLogoLabe.font = [UIFont systemFontOfSize:14];
        _priceLogoLabe.text = @"金额";
        _priceLogoLabe.textColor = [UIColor lightGrayColor];
        _priceLogoLabe.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLogoLabe;
}


- (UILabel *)carNumberLabel {
    if (!_carNumberLabel) {
        _carNumberLabel = [[UILabel alloc] init];
        _carNumberLabel.font = [UIFont boldSystemFontOfSize:15];
        _carNumberLabel.text = @"560";
        _carNumberLabel.textColor = [UIColor redColor];
        _carNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _carNumberLabel;
}

- (UILabel *)carNumberLogoLabel {
    if (!_carNumberLogoLabel) {
        _carNumberLogoLabel = [[UILabel alloc] init];
        _carNumberLogoLabel.font = [UIFont systemFontOfSize:14];
        _carNumberLogoLabel.text = @"车位号";
        _carNumberLogoLabel.textColor = [UIColor lightGrayColor];
        _carNumberLogoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _carNumberLogoLabel;
}

- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc] init];
        _areaLabel.font = [UIFont boldSystemFontOfSize:15];
        _areaLabel.text = @"0平米";
        _areaLabel.textColor = [UIColor redColor];
        _areaLabel.textAlignment = NSTextAlignmentRight;
    }
    return _areaLabel;
}

- (UILabel *)areaLogoLabel {
    if (!_areaLogoLabel) {
        _areaLogoLabel = [[UILabel alloc] init];
        _areaLogoLabel.font = [UIFont systemFontOfSize:14];
        _areaLogoLabel.text = @"建筑面积";
        _areaLogoLabel.textColor = [UIColor lightGrayColor];
        _areaLogoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _areaLogoLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UILabel *)carNumerLouLabel {
    if (!_carNumerLouLabel) {
        _carNumerLouLabel = [[UILabel alloc] init];
        _carNumerLouLabel.font = [UIFont systemFontOfSize:13];
        _carNumerLouLabel.text = @"车库楼层: 富2楼";
        _carNumerLouLabel.textColor = [UIColor blackColor];
        _carNumerLouLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _carNumerLouLabel;
}

- (UILabel *)buildTimeLabel {
    if (!_buildTimeLabel) {
        _buildTimeLabel = [[UILabel alloc] init];
        _buildTimeLabel.font = [UIFont systemFontOfSize:13];
        _buildTimeLabel.text = @"建筑时间: 2015.9";
        _buildTimeLabel.textColor = [UIColor blackColor];
        _buildTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _buildTimeLabel;
}

- (UILabel *)payTypeLabel {
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.font = [UIFont systemFontOfSize:13];
        _payTypeLabel.text = @"付款要求: 一次付清";
        _payTypeLabel.textColor = [UIColor blackColor];
        _payTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _payTypeLabel;
}

- (UILabel *)otherInfoLabel {
    if (!_otherInfoLabel) {
        _otherInfoLabel = [[UILabel alloc] init];
        _otherInfoLabel.font = [UIFont systemFontOfSize:13];
        _otherInfoLabel.text = @"补充信息:好的很，霸气侧漏";
        _otherInfoLabel.textColor = [UIColor blackColor];
        _otherInfoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _otherInfoLabel;
}

- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont systemFontOfSize:13];
        _yearLabel.text = @"产权年限: 50年";
        _yearLabel.textColor = [UIColor blackColor];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yearLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        _phoneLabel.text = @"联系电话: 13849132460";
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLabel;
}

- (UILabel *)callPhoneLabel {
    if (!_callPhoneLabel) {
        _callPhoneLabel = [[UILabel alloc] init];
        _callPhoneLabel.font = [UIFont systemFontOfSize:13];
        _callPhoneLabel.text = @"接听时段: 08:00-18:00";
        _callPhoneLabel.textColor = [UIColor blackColor];
        _callPhoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _callPhoneLabel;
}

@end
