//
//  FHPersonCodeView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/18.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHPersonCodeView.h"

@interface FHPersonCodeView ()
/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation FHPersonCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.bottomLineView];
    [self addSubview:self.titleLabel];
}


#pragma mark - 懒加载
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 180 - 0.5, SCREEN_WIDTH, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 200, 15)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

@end
