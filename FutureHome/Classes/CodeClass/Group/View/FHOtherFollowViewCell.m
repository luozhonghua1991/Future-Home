//
//  FHOtherFollowCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  收藏cell

#import "FHOtherFollowViewCell.h"

@implementation FHOtherFollowViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.headerImgView.frame = CGRectMake(10, 7.5, 55, 55);
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"头像"]];
    [self.contentView addSubview:self.headerImgView];
    self.titleLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, 15.5, 250, 13);
    [self.contentView addSubview:self.titleLabel];
    self.timeLabel.frame = CGRectMake(0, 35.5, SCREEN_WIDTH - 20, 11);
    [self.contentView addSubview:self.timeLabel];
//    self.contentLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.titleLabel) + 10, SCREEN_WIDTH - 100, 13);
//    [self.contentView addSubview:self.contentLabel];
}


#pragma mark — setter && getter
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
    }
    return _headerImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"收藏的标题";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.text = @"收藏于: 2019.08.03";
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.text = @"吃辣哈啊鞍山市佛法和哈弗扒饭害怕符合恢复怕黑皮肤哈";
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
