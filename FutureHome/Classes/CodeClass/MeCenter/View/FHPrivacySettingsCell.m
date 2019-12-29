//
//  FHPrivacySettingsCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  隐私设置cell

#import "FHPrivacySettingsCell.h"

@implementation FHPrivacySettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.selectBtn.frame = CGRectMake(20, 10, 15, 15);
    [self.contentView addSubview:self.selectBtn];
    self.logoLabel.frame = CGRectMake(MaxX(self.selectBtn) + 3, 10, 100, 13);
    [self.contentView addSubview:self.logoLabel];
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
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _selectBtn.layer.borderWidth = 1;
    }
    return _selectBtn;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.text = @"";
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:13];
        _logoLabel.textColor = [UIColor blackColor];
    }
    return _logoLabel;
}

@end
