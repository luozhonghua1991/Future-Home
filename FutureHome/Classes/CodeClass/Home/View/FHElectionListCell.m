//
//  FHElectionListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHElectionListCell.h"

@interface FHElectionListCell ()
/** 背景内容View */
@property (nonatomic, strong) UIView  *contentBgView;
/** 底部的label */
@property (nonatomic, strong) UILabel *bottomLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *leftImgView;

/** 竖线 */
@property (nonatomic, strong) UIView *shuLineView;
/** 上面的线 */
@property (nonatomic, strong) UIView *topLineView;
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** 号码 */
@property (nonatomic, strong) UILabel *numberLabel;




/** 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 年龄 */
@property (nonatomic, strong) UILabel *ageLabel;
/** 性别 */
@property (nonatomic, strong) UILabel *sexLabel;
/** 学历 */
@property (nonatomic, strong) UILabel *xueLiLabel;
/** 政治面貌 */
@property (nonatomic, strong) UILabel *faceLabel;
/** 兼职 */
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation FHElectionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.contentBgView];
    
    [self.contentBgView addSubview:self.nameLabel];
    [self.contentBgView addSubview:self.ageLabel];
    [self.contentBgView addSubview:self.sexLabel];
    [self.contentBgView addSubview:self.xueLiLabel];
    [self.contentBgView addSubview:self.faceLabel];
    [self.contentBgView addSubview:self.typeLabel];
    
    [self.contentBgView addSubview:self.leftImgView];
    [self.contentBgView addSubview:self.shuLineView];
    [self.contentBgView addSubview:self.topLineView];
    [self.contentBgView addSubview:self.bottomLineView];
    
    [self.contentBgView addSubview:self.numberLabel];
    [self.contentBgView addSubview:self.countLabel];
    [self.contentBgView addSubview:self.selectBtn];
    [self.contentBgView addSubview:self.selectLabel];
    
    [self.contentView addSubview:self.bottomLabel];
}



- (void)setCandidateListModel:(FHCandidateListModel *)candidateListModel {
    _candidateListModel = candidateListModel;
    self.bottomLabel.text = _candidateListModel.intro;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:_candidateListModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@号",candidateListModel.number];
    self.ageLabel.text = [NSString stringWithFormat:@"年龄: %ld岁",(long)_candidateListModel.age];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名: %@",_candidateListModel.name];
    self.sexLabel.text = [NSString stringWithFormat:@"性别: %@",_candidateListModel.getSex];
    self.xueLiLabel.text = [NSString stringWithFormat:@"学历: %@",_candidateListModel.education];
    self.faceLabel.text = [NSString stringWithFormat:@"政治面貌: %@",_candidateListModel.polity];
    self.typeLabel.text = [NSString stringWithFormat:@"全职/兼职: %@",_candidateListModel.getFull];
    
    
    if (_candidateListModel.select == 0) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    } else if (_candidateListModel.select == 1) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    }
}


-  (void)tapClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_FHElectionListCellDelegateSelectModel:)]) {
        [_delegate fh_FHElectionListCellDelegateSelectModel:self.candidateListModel];
    }
}


#pragma mark — setter && getter
- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 130)];
        _contentBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentBgView.layer.borderWidth = 1;
        _contentBgView.backgroundColor = [UIColor whiteColor];
    }
    return _contentBgView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(self.contentBgView) + 10, SCREEN_WIDTH - 100, 13)];
        _bottomLabel.font = [UIFont systemFontOfSize:13];
        _bottomLabel.text = @"全新全意为人民服务";
        _bottomLabel.textColor = [UIColor blackColor];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bottomLabel;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        _leftImgView.image = [UIImage imageNamed:@"头像"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        _leftImgView.userInteractionEnabled = YES;
        [_leftImgView addGestureRecognizer:tap];
    }
    return _leftImgView;
}

- (UIView *)shuLineView {
    if (!_shuLineView) {
        _shuLineView = [[UIView alloc] initWithFrame:CGRectMake(self.contentBgView.width - 100, 0, 0.5, self.contentBgView.height)];
        _shuLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _shuLineView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.shuLineView), 40, 100, 0.5)];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.shuLineView), 80, 100, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.shuLineView), 0, 100, 40)];
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.text = @"1号";
        _numberLabel.textColor = [UIColor blackColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.shuLineView), MaxY(self.numberLabel), 100, 40)];
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.text = @"502票";
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(MaxX(self.shuLineView) + 23.5, MaxY(self.countLabel) + 25 / 2 , 25, 25);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        _selectBtn.userInteractionEnabled = NO;
//        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.selectBtn), MaxY(self.countLabel), 28, 50)];
        _selectLabel.font = [UIFont systemFontOfSize:13];
        _selectLabel.text = @"选他";
        _selectLabel.textColor = [UIColor blackColor];
//        _selectLabel.backgroundColor = [UIColor redColor];
        _selectLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _selectLabel;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgView) + 5, 5, 150, 13)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.text = @"姓名: 南山叶";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgView) + 5, MaxY(self.nameLabel) + 8, 150, 13)];
        _ageLabel.font = [UIFont systemFontOfSize:13];
        _ageLabel.text = @"年龄: 32岁";
        _ageLabel.textColor = [UIColor blackColor];
        _ageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _ageLabel;
}

- (UILabel *)sexLabel {
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgView) + 5, MaxY(self.ageLabel) + 8, 150, 13)];
        _sexLabel.font = [UIFont systemFontOfSize:13];
        _sexLabel.text = @"性别: 男";
        _sexLabel.textColor = [UIColor blackColor];
        _sexLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _sexLabel;
}

- (UILabel *)xueLiLabel {
    if (!_xueLiLabel) {
        _xueLiLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgView) + 5, MaxY(self.sexLabel) + 8, 150, 13)];
        _xueLiLabel.font = [UIFont systemFontOfSize:13];
        _xueLiLabel.text = @"学历: 本科";
        _xueLiLabel.textColor = [UIColor blackColor];
        _xueLiLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _xueLiLabel;
}

- (UILabel *)faceLabel {
    if (!_faceLabel) {
        _faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgView) + 5, MaxY(self.xueLiLabel) + 8, 150, 13)];
        _faceLabel.font = [UIFont systemFontOfSize:13];
        _faceLabel.text = @"政治面貌: 党员";
        _faceLabel.textColor = [UIColor blackColor];
        _faceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _faceLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImgView) + 5, MaxY(self.faceLabel) + 8, 150, 13)];
        _typeLabel.font = [UIFont systemFontOfSize:13];
        _typeLabel.text = @"兼职/全职: 兼职";
        _typeLabel.textColor = [UIColor blackColor];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

@end
