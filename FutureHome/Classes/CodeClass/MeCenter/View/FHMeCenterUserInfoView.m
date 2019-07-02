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
    [self.topContentView addSubview:self.userNameLabel];
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

- (UIView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 65)];
        _bottomContentView.backgroundColor = [UIColor greenColor];
    }
    return _bottomContentView;
}

@end
