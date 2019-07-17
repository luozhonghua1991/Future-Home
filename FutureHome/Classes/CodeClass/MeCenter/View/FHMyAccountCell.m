//
//  FHMyAccountCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账户信息cell

#import "FHMyAccountCell.h"

@interface FHMyAccountCell ()
/** 最下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation FHMyAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}


#pragma mark — privite
- (void)fh_setUpUI {
    self.logoLabel.frame = CGRectMake(20, 55, SCREEN_WIDTH, 14);
    [self.contentView addSubview:self.logoLabel];
    self.contentLabel.frame = CGRectMake(0, 55, SCREEN_WIDTH - 65, 14);
    [self.contentView addSubview:self.contentLabel];
    self.rightArrowImg.frame = CGRectMake(SCREEN_WIDTH - 30, 55, 20, 14);
    [self.contentView addSubview:self.rightArrowImg];
    self.headerImg.frame = CGRectMake(SCREEN_WIDTH - 80, 15, 60, 60);
    [self.contentView addSubview:self.headerImg];
    self.bottomLineView.frame = CGRectMake(20, 79, SCREEN_WIDTH - 40, 1);
    [self.contentView addSubview:self.bottomLineView];
}



#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] init];
        _headerImg.image = [UIImage imageNamed:@""];
        _headerImg.backgroundColor = [UIColor blueColor];
    }
    return _headerImg;
}

- (UIImageView *)rightArrowImg {
    if (!_rightArrowImg) {
        _rightArrowImg = [[UIImageView alloc] init];
        _rightArrowImg.image = [UIImage imageNamed:@""];
        _rightArrowImg.backgroundColor = [UIColor blueColor];
    }
    return _rightArrowImg;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:14];
        _logoLabel.textColor = [UIColor blackColor];
#warning message
        _logoLabel.text = @"物业服务";
    }
    return _logoLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor blackColor];
#warning message
        _contentLabel.text = @"南山一叶";
    }
    return _contentLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
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
