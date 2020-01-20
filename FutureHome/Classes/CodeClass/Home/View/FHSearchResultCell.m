//
//  FHSearchResultCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHSearchResultCell.h"
#import "FHSearchResultModel.h"

@interface FHSearchResultCell ()
/** 名字label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 位置label */
@property (nonatomic, strong) UILabel *locationLabel;
/** 粉丝label */
@property (nonatomic, strong) UILabel *fnansLabel;

@end

@implementation FHSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.fnansLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.rightBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //高度92
    self.headerImgView.frame = CGRectMake(10, 10, 72, 72);
    self.nameLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, 15, 200, 13);
    self.locationLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.nameLabel) + 13, 200, 13);
    self.fnansLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.locationLabel) + 13, 200, 13);
    self.distanceLabel.frame = CGRectMake(0, MaxY(self.nameLabel) + 30, SCREEN_WIDTH - 33, 13);
    self.rightBtn.frame = CGRectMake(self.contentView.width - 100, MaxY(self.nameLabel) - 10, 80, 30);
}

- (void)setResultModel:(FHSearchResultModel *)resultModel {
    _resultModel = resultModel;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_resultModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.text = _resultModel.name;
    self.locationLabel.text = _resultModel.autograph;
    self.fnansLabel.text = [NSString stringWithFormat:@"粉丝 : %ld",(long)_resultModel.follow_num];
    self.distanceLabel.text = _resultModel.distance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark — event
- (void)tapClick {
    if (_delegate !=nil && [_delegate respondsToSelector:@selector(fh_selectAvaterWithModel:)]) {
        [_delegate fh_selectAvaterWithModel:self.resultModel];
    }
}


#pragma mark — setter && getter
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        _headerImgView.userInteractionEnabled = YES;
        [_headerImgView addGestureRecognizer:tap];
        
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor blueColor];
        _nameLabel.numberOfLines = 1;
#warning message
        _nameLabel.text = @"未来生鲜龙湖U城店，后天将会到达烟台顶级樱桃，价格还不贵哦，共计500份，赶紧预定抢购";
    }
    return _nameLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:13];
        _locationLabel.textColor = [UIColor blackColor];
        _locationLabel.numberOfLines = 1;
#warning message
        _locationLabel.text = @"未来生鲜龙湖U城店，后天将会到达烟台顶级樱桃，价格还不贵哦，共计500份，赶紧预定抢购";
    }
    return _locationLabel;
}

- (UILabel *)fnansLabel {
    if (!_fnansLabel) {
        _fnansLabel = [[UILabel alloc] init];
        _fnansLabel.textAlignment = NSTextAlignmentLeft;
        _fnansLabel.font = [UIFont systemFontOfSize:13];
        _fnansLabel.textColor = [UIColor blackColor];
        _fnansLabel.numberOfLines = 1;
#warning message
        _fnansLabel.text = @"未来生鲜龙湖U城店，后天将会到达烟台顶级樱桃，价格还不贵哦，共计500份，赶紧预定抢购";
    }
    return _fnansLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.textColor = [UIColor blackColor];
        _distanceLabel.numberOfLines = 1;
#warning message
        _distanceLabel.text = @"未来生鲜龙湖U城店，后天将会到达烟台顶级樱桃，价格还不贵哦，共计500份，赶紧预定抢购";
    }
    return _distanceLabel;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.layer.cornerRadius = 30 / 2;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.clipsToBounds = YES;
        _rightBtn.layer.borderWidth = 1;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightBtn;
}

@end
