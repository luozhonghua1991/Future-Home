//
//  FHheadercCollectioCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHheadercCollectioCell.h"

@interface FHheadercCollectioCell ()
/** 左边的View */
@property (nonatomic, strong) UIView *leftView;
/** 右边的View */
@property (nonatomic, strong) UIView *rightView;

@end

@implementation FHheadercCollectioCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.leftView];
    [self.leftView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightView];
    [self.rightView addSubview:self.rightLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = SCREEN_WIDTH / 2 - 1;
    self.leftView.frame = CGRectMake(0, 0, width / 2 - 1, 58);
    self.rightView.frame = CGRectMake(MaxX(self.leftView) + 2, 0, width / 2 - 1, 58);
    
    self.leftLabel.frame = self.leftView.bounds;
    self.rightLabel.frame =  self.rightView.bounds;
}

- (void)setNumberCount:(NSInteger)numberCount {
    _numberCount = numberCount;
    if (self.numberCount == 4) {
        self.leftView.backgroundColor = HEX_COLOR(0x708090);
    } else {
        self.leftView.backgroundColor = HEX_COLOR(0x7FFFD4);
    }
    if (self.numberCount == 4) {
        self.rightView.backgroundColor = HEX_COLOR(0xEE2C2);
    } else {
        self.rightView.backgroundColor = HEX_COLOR(0xEEE685);
    }
}

#pragma mark — setter && getter
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont boldSystemFontOfSize:13];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

@end
