//
//  FHFollowListViewCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  文档收藏cell

#import "FHFollowListViewCell.h"

@interface FHFollowListViewCell()
/** 白色背景View */
@property (nonatomic, strong) UIView *whiteBgView;

@end

@implementation FHFollowListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.whiteBgView];
    
    [self.whiteBgView addSubview:self.logoImgView];
    [self.whiteBgView addSubview:self.titleLabel];
    [self.whiteBgView addSubview:self.comeFromLabel];
    [self.whiteBgView addSubview:self.timeLabel];
}


#pragma mark — setter && getter
- (UIView *)whiteBgView {
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 100)];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.layer.cornerRadius = 5;
        _whiteBgView.clipsToBounds = YES;
        _whiteBgView.layer.masksToBounds = YES;
    }
    return _whiteBgView;
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        _logoImgView.image = [UIImage imageNamed:@""];
        _logoImgView.backgroundColor = HEX_COLOR(0x1296db);
    }
    return _logoImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, self.whiteBgView.width - 100, 50)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
#warning message
        _titleLabel.text = @"南山一叶南山一叶南山一叶南山一叶南山一叶南山一叶";
    }
    return _titleLabel;
}

- (UILabel *)comeFromLabel {
    if (!_comeFromLabel) {
        _comeFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.whiteBgView.width, 13)];
        _comeFromLabel.textAlignment = NSTextAlignmentLeft;
        _comeFromLabel.font = [UIFont systemFontOfSize:13];
        _comeFromLabel.textColor = [UIColor lightGrayColor];
#warning message
        _comeFromLabel.text = @"南山一叶";
    }
    return _comeFromLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.whiteBgView.width - 20, 13)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
#warning message
        _timeLabel.text = @"两天前";
    }
    return _timeLabel;
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
