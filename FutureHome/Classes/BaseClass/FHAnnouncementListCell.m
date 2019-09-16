//
//  FHAnnouncementListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  通用公告类Cell

#import "FHAnnouncementListCell.h"

@interface FHAnnouncementListCell ()
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 时间abel */
@property (nonatomic, strong) UILabel *timeLabel;
/** 阅读量label */
@property (nonatomic, strong) UILabel *readCountLabel;

@end

@implementation FHAnnouncementListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.readCountLabel];
}

- (void)setNoticeModel:(FHNoticeListModel *)noticeModel {
    _noticeModel = noticeModel;
    self.titleLabel.text = _noticeModel.title;
    self.timeLabel.text = _noticeModel.create_time;
    self.readCountLabel.text = [NSString stringWithFormat:@"阅读数%ld",(long)_noticeModel.view_num];
}


#pragma mark — setter && getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.contentView.width, 16)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
#warning message
        _titleLabel.text = @"政府政府公告政府政府公告政府政府公告";
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(self.titleLabel) + 25, self.contentView.width, 13)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
#warning message
        _timeLabel.text = @"更新时间2019-04-15 12:30:25";
    }
    return _timeLabel;
}

- (UILabel *)readCountLabel {
    if (!_readCountLabel) {
        _readCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.titleLabel) + 25, SCREEN_WIDTH - 13, 13)];
        _readCountLabel.textAlignment = NSTextAlignmentRight;
        _readCountLabel.font = [UIFont systemFontOfSize:13];
        _readCountLabel.textColor = [UIColor lightGrayColor];
#warning message
        _readCountLabel.text = @"阅读数520";
    }
    return _readCountLabel;
}

@end
