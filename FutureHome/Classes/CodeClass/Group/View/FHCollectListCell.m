//
//  FHCollectListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/8.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  全类收藏列表cell

#import "FHCollectListCell.h"

@implementation FHCollectListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.headerImgView.frame = CGRectMake(10, 7.5, 55, 55);
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
    [self.contentView addSubview:self.headerImgView];
    self.titleLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, 15.5, 250, 15);
    [self.contentView addSubview:self.titleLabel];
    self.distanceLabel.frame = CGRectMake(0, 15.5, SCREEN_WIDTH - 20, 13);
    [self.contentView addSubview:self.distanceLabel];
    self.contentLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.titleLabel) + 10, SCREEN_WIDTH - 100, 13);
    [self.contentView addSubview:self.contentLabel];
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
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"吃辣哈啊鞍山市佛法和哈弗扒饭害怕符合恢复怕黑皮肤哈";
        _titleLabel.textColor = HEX_COLOR(0x1296db);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.text = @"0.01KM";
        _distanceLabel.textColor = [UIColor blackColor];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
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
