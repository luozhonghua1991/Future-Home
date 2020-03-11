//
//  FHCommonFollowAndPlacementCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  收藏和置顶通用cell

#import "FHCommonFollowAndPlacementCell.h"
#import "FHCommonFollowModel.h"

@interface  FHCommonFollowAndPlacementCell ()
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 名字label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 粉丝label */
@property (nonatomic, strong) UILabel *fnansLabel;


@end

@implementation FHCommonFollowAndPlacementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.fnansLabel];
    [self.contentView addSubview:self.rightBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //高度70
    self.headerImgView.frame = CGRectMake(10, 7.5, 55, 55);
    self.nameLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, 20, 270, 13);
    self.fnansLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.nameLabel) + 10, 200, 13);
    self.rightBtn.frame = CGRectMake(self.contentView.width - 60, MaxY(self.nameLabel) - 5, 40, 25);
}

- (void)setFollowModel:(FHCommonFollowModel *)followModel {
    _followModel = followModel;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_followModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.text = _followModel.name;
    self.fnansLabel.text = [NSString stringWithFormat:@"粉丝 : %ld",(long)_followModel.follow_num];
}


#pragma mark — event
- (void)tapClick {
    if (_delegate !=nil && [_delegate respondsToSelector:@selector(fh_selectAvaterWithModel:)]) {
        [_delegate fh_selectAvaterWithModel:self.followModel];
    }
}

- (void)rightBtnClick {
    if (_delegate !=nil && [_delegate respondsToSelector:@selector(fh_selectMenuWithModel:)]) {
        [_delegate fh_selectMenuWithModel:self.followModel];
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
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blueColor];
        _nameLabel.numberOfLines = 1;
#warning message
        _nameLabel.text = @"未来生鲜龙湖U城店，后天将会到达烟台顶级樱桃，价格还不贵哦，共计500份，赶紧预定抢购";
    }
    return _nameLabel;
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

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.layer.cornerRadius = 25 / 2;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.clipsToBounds = YES;
        _rightBtn.layer.borderWidth = 1;
        [_rightBtn setTitle:@"···" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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
