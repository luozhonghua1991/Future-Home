//
//  FHMedicalRecordsListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMedicalRecordsListCell.h"

@implementation FHMedicalRecordsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.personCodeLabel];
    [self.contentView addSubview:self.codeLabel];
}

- (void)setModel:(FHHealthMemberModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"姓        名: %@",_model.name];
    self.phoneNumberLabel.text = @"";
    self.personCodeLabel.text = [NSString stringWithFormat:@"手机号码: %@",_model.mobile];
    self.codeLabel.text = [NSString stringWithFormat:@"社保卡号: %@",_model.social_number];
}

#pragma mark — setter && getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width, 13)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
#warning message
        _nameLabel.text = @"许大宝 女";
    }
    return _nameLabel;
}

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 10, 13)];
        _phoneNumberLabel.textAlignment = NSTextAlignmentRight;
        _phoneNumberLabel.font = [UIFont systemFontOfSize:13];
        _phoneNumberLabel.textColor = [UIColor blackColor];
#warning message
        _phoneNumberLabel.text = @"15730332432";
    }
    return _phoneNumberLabel;
}

- (UILabel *)personCodeLabel {
    if (!_personCodeLabel) {
        _personCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(_nameLabel) + 10, self.contentView.width, 13)];
        _personCodeLabel.textAlignment = NSTextAlignmentLeft;
        _personCodeLabel.font = [UIFont systemFontOfSize:13];
        _personCodeLabel.textColor = [UIColor blackColor];
#warning message
        _personCodeLabel.text = @"身份证号 :41020319911106201X";
    }
    return _personCodeLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(_personCodeLabel) + 10, self.contentView.width, 13)];
        _codeLabel.textAlignment = NSTextAlignmentLeft;
        _codeLabel.font = [UIFont systemFontOfSize:13];
        _codeLabel.textColor = [UIColor blackColor];
#warning message
        _codeLabel.text = @"社保卡号 :23003082048";
    }
    return _codeLabel;
}

@end
