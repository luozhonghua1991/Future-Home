//
//  FHCertificationImgView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  实名认证上传View

#import "FHCertificationImgView.h"

@interface FHCertificationImgView ()
/** 左边View */
@property (nonatomic, strong) UIView *leftView;
/** 中间View */
@property (nonatomic, strong) UIView *centerView;
/** 右边View */
@property (nonatomic, strong) UIView *rightView;

@end

@implementation FHCertificationImgView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}


- (void)fh_setUpUI {
    self.leftView = [self creatViewWithName:@"证件正面" frame:CGRectMake(10, 0, 100, 100) tag:1];
    [self.leftView addSubview:self.leftImgView];
    [self addSubview:self.leftView];
    self.centerView = [self creatViewWithName:@"证件反面" frame:CGRectMake(0, 0, 100, 100) tag:2];
    [self.centerView addSubview:self.centerImgView];
    [self addSubview:self.centerView];
    self.centerView.centerX = self.width / 2;
    self.rightView = [self creatViewWithName:@"手持证件合影照" frame:CGRectMake(SCREEN_WIDTH - 110, 0, 100, 100) tag:3];
    [self.rightView addSubview:self.rightImgView];
    [self addSubview:self.rightView];
}


- (UIImageView *)creatViewWithName:(NSString *)name
                        frame:(CGRect )frame
                          tag:(NSInteger )tag {
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.image = [UIImage imageNamed:@""];
    view.tag = tag;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 20)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = name;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    self.changeTitleLabel = label;
    
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
    return view;
}


#pragma mark — event
- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHCertificationImgViewDelegateSelectIndex:)]) {
        [_delegate FHCertificationImgViewDelegateSelectIndex:recognizer.view.tag];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHCertificationImgViewDelegateSelectIndex:view:)]) {
        [_delegate FHCertificationImgViewDelegateSelectIndex:recognizer.view.tag view:self];
    }
}

#pragma mark — setter && getter
//- (UIView *)leftView {
//    if (!_leftView) {
//        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _leftView.backgroundColor = [UIColor redColor];
//    }
//    return _leftView;
//}

//- (UIView *)centerView {
//    if (!_centerView) {
//        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _centerView.backgroundColor = [UIColor redColor];
//    }
//    return _centerView;
//}
//
//- (UIView *)rightView {
//    if (!_rightView) {
//        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _rightView.backgroundColor = [UIColor redColor];
//    }
//    return _rightView;
//}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
//        _leftImgView.backgroundColor = HEX_COLOR(0x1296db);
        _leftImgView.backgroundColor = [UIColor clearColor];
        _leftImgView.image = [UIImage imageNamed:@"头像"];
        _leftImgView.userInteractionEnabled = YES;
    }
    return _leftImgView;
}

- (UIImageView *)centerImgView {
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
//        _centerImgView.backgroundColor = HEX_COLOR(0x1296db);
        _centerImgView.backgroundColor = [UIColor clearColor];
        _centerImgView.image = [UIImage imageNamed:@"头像"];
        _centerImgView.userInteractionEnabled = YES;
    }
    return _centerImgView;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
//        _rightImgView.backgroundColor = HEX_COLOR(0x1296db);
        _rightImgView.image = [UIImage imageNamed:@"头像"];
        _rightImgView.backgroundColor = [UIColor clearColor];
        _rightImgView.userInteractionEnabled = YES;
    }
    return _rightImgView;
}

@end
