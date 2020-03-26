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
/** 房屋类型 */
@property (nonatomic, strong) UILabel *houseTypeLabel;
/** 房屋房号 */
@property (nonatomic, strong) UILabel *houseNumberLabel;
/** 房屋朝向 */
@property (nonatomic, strong) UILabel *houseTowardLabel;
/** 装修情况 */
@property (nonatomic, strong) UILabel *houseStatueLabel;

/** 产权年限 */
@property (nonatomic, strong) UILabel *yearLabel;
/** 建筑时间 */
@property (nonatomic, strong) UILabel *buildTimeLabel;
/** 付款要求 */
@property (nonatomic, strong) UILabel *payTypeLabel;
/** 联系电话 */
@property (nonatomic, strong) UILabel *phoneLabel;
/** 接听时段 */
@property (nonatomic, strong) UILabel *callPhoneLabel;
/**补充信息 */
@property (nonatomic, strong) UILabel *otherInfoLabel;



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
    
    if (self.type == 0 || self.type == 1) {
        /** 房子相关的 */
        [self.contentView addSubview:self.houseTypeLabel];
        [self.contentView addSubview:self.houseNumberLabel];
        [self.contentView addSubview:self.houseTowardLabel];
        [self.contentView addSubview:self.houseStatueLabel];
        [self.contentView addSubview:self.yearLabel];
        [self.contentView addSubview:self.buildTimeLabel];
        [self.contentView addSubview:self.payTypeLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.callPhoneLabel];
        [self.contentView addSubview:self.otherInfoLabel];
    } else {
        /** 车位相关的 */
        [self.contentView addSubview:self.yearLabel];
        [self.contentView addSubview:self.carNumerLouLabel];
        [self.contentView addSubview:self.buildTimeLabel];
        [self.contentView addSubview:self.payTypeLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.callPhoneLabel];
        [self.contentView addSubview:self.otherInfoLabel];
    }
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)setDetailModel:(FHListDetailModel *)detailModel {
    _detailModel = detailModel;
    /** 0房屋出售 1房屋出租 2车位出售 3车位出租 */
    if (self.type == 0) {
        self.priceLabe.text = [NSString stringWithFormat:@"￥%ld万",(long)_detailModel.rent];
        self.carNumberLogoLabel.text = @"房屋户型";
        self.priceLogoLabe.text = @"出售价格";
        self.carNumberLabel.text = [NSString stringWithFormat:@"%@",_detailModel.hall];
    } else if (self.type == 1) {
        self.priceLabe.text = [NSString stringWithFormat:@"￥%ld元",(long)_detailModel.rent];
        self.carNumberLogoLabel.text = @"房屋户型";
        self.priceLogoLabe.text = @"出租价格";
        self.carNumberLabel.text = [NSString stringWithFormat:@"%@",_detailModel.hall];
    } else if (self.type == 2) {
        self.priceLabe.text = [NSString stringWithFormat:@"￥%ld万",(long)_detailModel.rent];
        self.carNumberLogoLabel.text = @"车位编号";
        self.priceLogoLabe.text = @"出售价格";
        self.carNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.shelves];
    } else if (self.type == 3) {
        self.priceLabe.text = [NSString stringWithFormat:@"￥%ld元",(long)_detailModel.rent];
        self.carNumberLogoLabel.text = @"车位编号";
        self.priceLogoLabe.text = @"出租价格";
        self.carNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.shelves];
    }
    
    self.areaLabel.text = [NSString stringWithFormat:@"%ld㎡",(long)_detailModel.area];
    if (self.type == 2 || self.type == 3) {
        self.titleNameLabel.text = _detailModel.title;
        [self changeTitle:[NSString stringWithFormat:@"车库楼层: %ld楼",(long)_detailModel.l_floor] index:5 label:self.carNumerLouLabel];
        [self changeTitle:[NSString stringWithFormat:@"建筑时间: %@",_detailModel.create_time] index:5 label:self.buildTimeLabel];
        [self changeTitle:[NSString stringWithFormat:@"付款要求: %@",_detailModel.require] index:5 label:self.payTypeLabel];
        [self changeTitle:[NSString stringWithFormat:@"产权年限: %ld年",(long)_detailModel.years] index:5 label:self.yearLabel];
        [self changeTitle:[NSString stringWithFormat:@"联系电话: %@",_detailModel.mobile] index:5 label:self.phoneLabel];
        [self changeTitle:[NSString stringWithFormat:@"接听时段: %@",_detailModel.time_slot] index:5 label:self.callPhoneLabel];
        [self changeTitle:[NSString stringWithFormat:@"其它补充信息: \n\n%@",_detailModel.describe] index:7 label:self.otherInfoLabel];
    } else {
        self.titleNameLabel.text = _detailModel.community;
        [self changeTitle:[NSString stringWithFormat:@"房屋类型: %@",_detailModel.house_type] index:5 label:self.houseTypeLabel];
        [self changeTitle:[NSString stringWithFormat:@"楼层房号: %@",_detailModel.house_park] index:5 label:self.houseNumberLabel];
        [self changeTitle:[NSString stringWithFormat:@"房屋朝向: %ld年",(long)_detailModel.toward] index:5 label:self.houseTowardLabel];
        [self changeTitle:[NSString stringWithFormat:@"装修情况: %@",_detailModel.decoration] index:5 label:self.houseStatueLabel];
        [self changeTitle:[NSString stringWithFormat:@"建筑时间: %@",_detailModel.create_time] index:5 label:self.buildTimeLabel];
        [self changeTitle:[NSString stringWithFormat:@"付款要求: %@",_detailModel.require] index:5 label:self.payTypeLabel];
        [self changeTitle:[NSString stringWithFormat:@"产权年限: %ld年",(long)_detailModel.years] index:5 label:self.yearLabel];
        [self changeTitle:[NSString stringWithFormat:@"联系电话: %@",_detailModel.mobile] index:5 label:self.phoneLabel];
        [self changeTitle:[NSString stringWithFormat:@"接听时段: %@",_detailModel.time_slot] index:5 label:self.callPhoneLabel];
        [self changeTitle:[NSString stringWithFormat:@"其它补充信息: \n\n%@",_detailModel.describe] index:7 label:self.otherInfoLabel];
    }
    
    /** frame相关的 */
    CGSize titleSize = [UIlabelTool sizeWithString:self.titleNameLabel.text font:self.titleNameLabel.font width:self.titleNameLabel.width];
    self.titleNameLabel.frame = CGRectMake(10, 15, SCREEN_WIDTH - 200, titleSize.height);
    self.priceLabe.frame = CGRectMake(10, MaxY(self.titleNameLabel) + 15, SCREEN_WIDTH - 200, 15);
    self.priceLogoLabe.frame = CGRectMake(10, MaxY(self.priceLabe) + 5, SCREEN_WIDTH - 200, 14);
    
    self.carNumberLabel.frame = CGRectMake(0, MaxY(self.titleNameLabel) + 15, SCREEN_WIDTH, 15);
    self.carNumberLogoLabel.frame = CGRectMake(0, MaxY(self.carNumberLabel) + 5, SCREEN_WIDTH, 14);
    
    self.areaLabel.frame = CGRectMake(0, MaxY(self.titleNameLabel) + 15, SCREEN_WIDTH - 10, 15);
    self.areaLogoLabel.frame = CGRectMake(2, MaxY(self.areaLabel) + 5, SCREEN_WIDTH - 10, 14);
    
    self.lineView.frame = CGRectMake(10, MaxY(self.priceLogoLabe) + 20, SCREEN_WIDTH - 20, 0.5);
    
    if (self.type == 0  || self.type == 1) {
        /** 房子相关的 */
        self.houseTypeLabel.frame = CGRectMake(10, MaxY(self.lineView) + 12, SCREEN_WIDTH - 200, 15);
        self.houseNumberLabel.frame = CGRectMake(10, MaxY(self.houseTypeLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.houseTowardLabel.frame = CGRectMake(10, MaxY(self.houseNumberLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.houseStatueLabel.frame = CGRectMake(10, MaxY(self.houseTowardLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.yearLabel.frame = CGRectMake(10, MaxY(self.houseStatueLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.buildTimeLabel.frame = CGRectMake(10, MaxY(self.yearLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.payTypeLabel.frame = CGRectMake(10, MaxY(self.buildTimeLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.phoneLabel.frame = CGRectMake(10, MaxY(self.payTypeLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.callPhoneLabel.frame = CGRectMake(10, MaxY(self.phoneLabel) + 12, SCREEN_WIDTH - 200, 15);
    } else {
        /** 车位相关的 */
        self.carNumerLouLabel.frame = CGRectMake(10, MaxY(self.lineView) + 12, SCREEN_WIDTH - 200, 15);
        self.yearLabel.frame = CGRectMake(10, MaxY(self.carNumerLouLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.buildTimeLabel.frame = CGRectMake(10, MaxY(self.yearLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.payTypeLabel.frame = CGRectMake(10, MaxY(self.buildTimeLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.phoneLabel.frame = CGRectMake(10, MaxY(self.payTypeLabel) + 12, SCREEN_WIDTH - 200, 15);
        self.callPhoneLabel.frame = CGRectMake(10, MaxY(self.phoneLabel) + 12, SCREEN_WIDTH - 200, 15);
    }
    
    CGSize size = [UIlabelTool sizeWithString:self.otherInfoLabel.text font:self.otherInfoLabel.font width:self.otherInfoLabel.width];
    self.otherInfoLabel.frame = CGRectMake(10, MaxY(self.callPhoneLabel) + 12, SCREEN_WIDTH - 200, size.height);
    [SingleManager shareManager].rentOrSaleDetailHeight = MaxY(self.otherInfoLabel) + 10;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)changeTitle:(NSString *)title
                index:(NSInteger)index
                label:(UILabel *)label {
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:title];
    [attributedTitle changeColor:[UIColor blackColor] rang:[attributedTitle changeSystemFontFloat:15 from:index legth:attributedTitle.length - index]];
    label.attributedText = attributedTitle;
}


#pragma mark — setter && getter
- (UILabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] init];
        _titleNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleNameLabel.text = @"车位大甩卖";
        _titleNameLabel.textColor = [UIColor blackColor];
        _titleNameLabel.textAlignment = NSTextAlignmentLeft;
        _titleNameLabel.numberOfLines = 0;
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
        _priceLogoLabe.text = @"出售价格";
        _priceLogoLabe.textColor = HEX_COLOR(0x1296db);
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
        _carNumberLogoLabel.textColor = HEX_COLOR(0x1296db);
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
        _areaLogoLabel.textColor = HEX_COLOR(0x1296db);
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
        _carNumerLouLabel.font = [UIFont systemFontOfSize:15];
        _carNumerLouLabel.text = @"车库楼层: 富2楼";
        _carNumerLouLabel.textColor = HEX_COLOR(0x1296db);
        _carNumerLouLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _carNumerLouLabel;
}

- (UILabel *)buildTimeLabel {
    if (!_buildTimeLabel) {
        _buildTimeLabel = [[UILabel alloc] init];
        _buildTimeLabel.font = [UIFont systemFontOfSize:15];
        _buildTimeLabel.text = @"建筑时间: 2015.9";
        _buildTimeLabel.textColor = HEX_COLOR(0x1296db);
        _buildTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _buildTimeLabel;
}

- (UILabel *)payTypeLabel {
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.font = [UIFont systemFontOfSize:15];
        _payTypeLabel.text = @"付款要求: 一次付清";
        _payTypeLabel.textColor = HEX_COLOR(0x1296db);
        _payTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _payTypeLabel;
}

- (UILabel *)otherInfoLabel {
    if (!_otherInfoLabel) {
        _otherInfoLabel = [[UILabel alloc] init];
        _otherInfoLabel.font = [UIFont systemFontOfSize:15];
        _otherInfoLabel.text = @"补充信息:好的很，霸气侧漏";
        _otherInfoLabel.textColor = HEX_COLOR(0x1296db);
        _otherInfoLabel.textAlignment = NSTextAlignmentLeft;
        _otherInfoLabel.numberOfLines = 0;
    }
    return _otherInfoLabel;
}

- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont systemFontOfSize:15];
        _yearLabel.text = @"产权年限: 50年";
        _yearLabel.textColor = HEX_COLOR(0x1296db);
        _yearLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _yearLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        _phoneLabel.text = @"联系电话: 15849152460";
        _phoneLabel.textColor = HEX_COLOR(0x1296db);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLabel;
}

- (UILabel *)callPhoneLabel {
    if (!_callPhoneLabel) {
        _callPhoneLabel = [[UILabel alloc] init];
        _callPhoneLabel.font = [UIFont systemFontOfSize:15];
        _callPhoneLabel.text = @"接听时段: 08:00-18:00";
        _callPhoneLabel.textColor = HEX_COLOR(0x1296db);
        _callPhoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _callPhoneLabel;
}

- (UILabel *)houseTypeLabel {
    if (!_houseTypeLabel) {
        _houseTypeLabel = [[UILabel alloc] init];
        _houseTypeLabel.font = [UIFont systemFontOfSize:15];
        _houseTypeLabel.text = @"房屋类型: ";
        _houseTypeLabel.textColor = HEX_COLOR(0x1296db);
        _houseTypeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseTypeLabel;
}

- (UILabel *)houseNumberLabel {
    if (!_houseNumberLabel) {
        _houseNumberLabel = [[UILabel alloc] init];
        _houseNumberLabel.font = [UIFont systemFontOfSize:15];
        _houseNumberLabel.text = @"房屋房号: ";
        _houseNumberLabel.textColor = HEX_COLOR(0x1296db);
        _houseNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseNumberLabel;
}

- (UILabel *)houseTowardLabel {
    if (!_houseTowardLabel) {
        _houseTowardLabel = [[UILabel alloc] init];
        _houseTowardLabel.font = [UIFont systemFontOfSize:15];
        _houseTowardLabel.text = @"房屋朝向: 08:00-18:00";
        _houseTowardLabel.textColor = HEX_COLOR(0x1296db);
        _houseTowardLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseTowardLabel;
}

- (UILabel *)houseStatueLabel {
    if (!_houseStatueLabel) {
        _houseStatueLabel = [[UILabel alloc] init];
        _houseStatueLabel.font = [UIFont systemFontOfSize:15];
        _houseStatueLabel.text = @"装修情况: 08:00-18:00";
        _houseStatueLabel.textColor = HEX_COLOR(0x1296db);
        _houseStatueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _houseStatueLabel;
}

@end
