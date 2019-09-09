//
//  FHFriendListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHFriendListCell.h"

@implementation FHFriendListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.followOrNoBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerImgView.frame = CGRectMake(10, 7.5, 55, 55);
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, 0, 200, 70);
    self.followOrNoBtn.frame = CGRectMake(self.contentView.width - 100, 15.5, 80, 35);
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
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
#warning message
        _nameLabel.text = @"许大宝~";
    }
    return _nameLabel;
}

- (UIButton *)followOrNoBtn {
    if (!_followOrNoBtn) {
        _followOrNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followOrNoBtn.layer.cornerRadius = 35 / 2;
        _followOrNoBtn.layer.masksToBounds = YES;
        _followOrNoBtn.clipsToBounds = YES;
        _followOrNoBtn.layer.borderWidth = 1;
        _followOrNoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _followOrNoBtn;
}

@end
