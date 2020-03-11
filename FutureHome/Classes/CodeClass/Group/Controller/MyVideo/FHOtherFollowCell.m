//
//  FHOtherFollowCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  文档收藏

#import "FHOtherFollowCell.h"
#import "FHDocumentCollectModel.h"

@interface FHOtherFollowCell ()
/** 内容label */
@property (nonatomic, strong) UILabel *contentLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 下面的灰色视图 */
@property (nonatomic, strong) UIView *grayView;
/** 更新时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 阅读数量label */
@property (nonatomic, strong) UILabel *readCountLabel;
@end

@implementation FHOtherFollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self fh_creatUI];
    }
    return self;
}

- (void)fh_creatUI {
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.grayView];
    [self.grayView addSubview:self.timeLabel];
    [self.grayView addSubview:self.readCountLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH - 135, 50);
    self.headerImgView.frame  = CGRectMake(SCREEN_WIDTH - 118 + 28, 10, 80, 80);
    self.grayView.frame = CGRectMake(10, self.contentView.height - 35, SCREEN_WIDTH - 135, 25);
    self.timeLabel.frame = CGRectMake(0, 0, self.grayView.width, 25);
    self.readCountLabel.frame = CGRectMake(0, 0, self.grayView.width, 25);
}

- (void)setCollectModel:(FHDocumentCollectModel *)collectModel {
    _collectModel = collectModel;
    self.contentLabel.text = _collectModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"更新时间: %@",_collectModel.updatetime];
    self.readCountLabel.text = [NSString stringWithFormat:@"阅读量: %@",_collectModel.browse];
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_collectModel.coverthumb]];
}

#pragma mark — setter && getter
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont boldSystemFontOfSize:16];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
#warning message
        _contentLabel.text = @"未来生鲜龙湖U城店，后天将会到达烟台顶级樱桃，价格还不贵哦，共计500份，赶紧预定抢购";
    }
    return _contentLabel;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
    }
    return _headerImgView;
}

- (UIView *)grayView {
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = [UIColor whiteColor];
    }
    return _grayView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = HEX_COLOR(0x8f8f8f);
#warning message
        _timeLabel.text = @"更新时间 2018/09/04";
    }
    return _timeLabel;
    
}

- (UILabel *)readCountLabel {
    if (!_readCountLabel) {
        _readCountLabel = [[UILabel alloc] init];
        _readCountLabel.textAlignment = NSTextAlignmentRight;
        _readCountLabel.font = [UIFont systemFontOfSize:13];
        _readCountLabel.textColor = HEX_COLOR(0x8f8f8f);
#warning message
        _readCountLabel.text = @"阅读量  10086";
    }
    return _readCountLabel;
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
