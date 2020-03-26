//
//  FHFHTenderingInfoCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/26.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHFHTenderingInfoCell.h"

@interface FHFHTenderingInfoCell()
/** 外边框图 */
@property (nonatomic, strong) UIView *layerBgView;
/** 标题注释label */
@property (nonatomic, strong) UILabel *titleLogLabel;
/** 时间注释label */
@property (nonatomic, strong) UILabel *timeLogLabel;
/** phone */
@property (nonatomic, strong) UILabel *phoneLogLabel;
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 手机 */
@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation FHFHTenderingInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.layerBgView];
    [self.layerBgView addSubview:self.titleLogLabel];
    [self.layerBgView addSubview:self.titleLabel];
    [self.layerBgView addSubview:self.timeLabel];
    [self.layerBgView addSubview:self.timeLogLabel];
    [self.layerBgView addSubview:self.phoneLabel];
    [self.layerBgView addSubview:self.phoneLogLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)setInfoModel:(FHTenderingInfModel *)infoModel {
    _infoModel = infoModel;
    self.titleLabel.text = _infoModel.title;
    self.timeLabel.text = _infoModel.candidate_time;
    self.phoneLabel.text = _infoModel.mobile;
    CGSize size = [UIlabelTool sizeWithString:_infoModel.title font:[UIFont systemFontOfSize:14] width:self.layerBgView.width - 145];
    self.titleLabel.frame = CGRectMake(140, 5, self.layerBgView.width - 145, size.height);
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark — setter && getter
- (UIView *)layerBgView {
    if (!_layerBgView) {
        _layerBgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 120)];
        _layerBgView.backgroundColor = [UIColor whiteColor];
        _layerBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _layerBgView.layer.borderWidth = 1;
        _layerBgView.layer.masksToBounds = YES;
        _layerBgView.clipsToBounds = YES;
    }
    return _layerBgView;
}

- (UILabel *)titleLogLabel {
    if (!_titleLogLabel) {
        _titleLogLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 14)];
        _titleLogLabel.font = [UIFont systemFontOfSize:14];
        _titleLogLabel.text = @"投标项目名称";
        _titleLogLabel.textColor = [UIColor blueColor];
        _titleLogLabel.textAlignment = NSTextAlignmentLeft;
        _titleLogLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLogLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.titleLogLabel) + 25, 5, 250, 0)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"恒大未来城- -期业委会团购20吨苹果，欢迎产地方投标，付款方式友好共36字.";
        _titleLabel.textColor = [UIColor blueColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLogLabel {
    if (!_timeLogLabel) {
        _timeLogLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, MaxY(self.titleLogLabel) + 40, 105, 14)];
        _timeLogLabel.font = [UIFont systemFontOfSize:14];
        _timeLogLabel.text = @"投标有效时间:";
        _timeLogLabel.textColor = [UIColor blueColor];
        _timeLogLabel.textAlignment = NSTextAlignmentLeft;
        _timeLogLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLogLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.titleLogLabel) + 40, self.layerBgView.width - 5, 14)];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.text = @"2020.03.20-2020.03.28";
        _timeLabel.textColor = [UIColor blueColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.backgroundColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UILabel *)phoneLogLabel {
    if (!_phoneLogLabel) {
        _phoneLogLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, MaxY(self.timeLogLabel) + 20, 120, 14)];
        _phoneLogLabel.font = [UIFont systemFontOfSize:14];
        _phoneLogLabel.text = @"发标方联系电话:";
        _phoneLogLabel.textColor = [UIColor blueColor];
        _phoneLogLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLogLabel.backgroundColor = [UIColor whiteColor];
    }
    return _phoneLogLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.timeLogLabel) + 20, self.layerBgView.width - 5, 14)];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        _phoneLabel.text = @"13849132460";
        _phoneLabel.textColor = [UIColor blueColor];
        _phoneLabel.textAlignment = NSTextAlignmentRight;
        _phoneLabel.backgroundColor = [UIColor whiteColor];
    }
    return _phoneLabel;
}

@end
