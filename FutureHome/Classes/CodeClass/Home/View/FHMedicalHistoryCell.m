//
//  FHMedicalHistoryCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMedicalHistoryCell.h"

@implementation FHMedicalHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.hospitalLabel];
    [self.contentView addSubview:self.infoLabel];
}

- (void)setModel:(FHHealthHistoryModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",_model.name,_model.getSex];
    self.dateLabel.text = _model.treat_time;
    self.hospitalLabel.text = [NSString stringWithFormat:@"医院名称: %@",_model.hospital];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_model.total_pay];
    self.infoLabel.text = [NSString stringWithFormat:@"症状描述 %@",_model.symptom];
}


#pragma mark — setter && getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width, 13)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
#warning message
        _nameLabel.text = @"许大宝 女";
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 10, 13)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textColor = [UIColor blackColor];
#warning message
        _dateLabel.text = @"2018年8月28号";
    }
    return _dateLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(_dateLabel) + 10, ScreenWidth - 10, 13)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [UIColor blackColor];
#warning message
        _priceLabel.text = @"200.00元";
    }
    return _priceLabel;
}

- (UILabel *)hospitalLabel {
    if (!_hospitalLabel) {
        _hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(_nameLabel) + 10, self.contentView.width, 13)];
        _hospitalLabel.textAlignment = NSTextAlignmentLeft;
        _hospitalLabel.font = [UIFont systemFontOfSize:13];
        _hospitalLabel.textColor = [UIColor blackColor];
#warning message
        _hospitalLabel.text = @"医院名称 :重庆XX医院";
    }
    return _hospitalLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(_hospitalLabel) + 10, self.contentView.width, 13)];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.textColor = [UIColor blackColor];
#warning message
        _infoLabel.text = @"描述症状 :感冒发烧";
    }
    return _infoLabel;
}

@end
