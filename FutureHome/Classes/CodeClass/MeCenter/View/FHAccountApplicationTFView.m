//
//  FHAccountApplicationTFView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账号申请通用View 左边文字 右边文本框类型

#import "FHAccountApplicationTFView.h"

@interface FHAccountApplicationTFView ()
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation FHAccountApplicationTFView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.bottomLineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentTF];
}

#pragma mark - 懒加载
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 200, 15)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UITextField *)contentTF {
    if (!_contentTF) {
        _contentTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 270, 20, 260, 20)];
        _contentTF.textAlignment = NSTextAlignmentRight;
        _contentTF.font = [UIFont systemFontOfSize:15];
//        _contentTF.backgroundColor = [UIColor blueColor];
    }
    return _contentTF;
}

@end
