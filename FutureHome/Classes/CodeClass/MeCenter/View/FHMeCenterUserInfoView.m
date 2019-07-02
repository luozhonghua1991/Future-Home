//
//  FHMeCenterUserInfoView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  个人中心 个人信息View

#import "FHMeCenterUserInfoView.h"

@interface FHMeCenterUserInfoView ()
/** 上面部分的视图 */
@property (nonatomic, strong) UIView  *topContentView;
/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 下面部分的视图 */
@property (nonatomic, strong) UIView  *bottomContentView;

@end

@implementation FHMeCenterUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.topContentView];
    [self.topContentView addSubview:self.userHeaderImgView];
    [self.topContentView addSubview:self.userNameLabel];
    self.userNameLabel.centerY = self.topContentView.height / 2;
    [self.topContentView addSubview:self.codeImgView];
    [self.topContentView addSubview:self.logoLabel];
    
    [self addSubview:self.bottomContentView];
}


#pragma mark - 懒加载
- (UIView *)topContentView {
    if (!_topContentView) {
        _topContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
        _topContentView.backgroundColor = [UIColor redColor];
    }
    return _topContentView;
}

- (UIImageView *)userHeaderImgView {
    if (!_userHeaderImgView) {
        _userHeaderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
        _userHeaderImgView.backgroundColor = [UIColor blueColor];
    }
    return _userHeaderImgView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75 + 20, 0, 100, 16)];
        _userNameLabel.text = @"许大宝~";
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLabel;
}

- (UIImageView *)codeImgView {
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 5, 65, 65)];
        _codeImgView.backgroundColor = [UIColor blueColor];
    }
    return _codeImgView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 72, 100, 10)];
        _logoLabel.text = @"我的二维码";
        _logoLabel.textColor = [UIColor blackColor];
        _logoLabel.textAlignment = NSTextAlignmentRight;
        _logoLabel.font = [UIFont systemFontOfSize:10];
    }
    return _logoLabel;
}

- (UIView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 65)];
        _bottomContentView.backgroundColor = [UIColor greenColor];
    }
    return _bottomContentView;
}

@end
