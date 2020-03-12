//
//  FHElectRepeatTFView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHElectRepeatTFView.h"

@implementation FHElectRepeatTFView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.contentTF];
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27 / 2, 120, 13)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(97.5, 0, 0.5, 40)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UITextField *)contentTF {
    if (!_contentTF) {
        _contentTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 27 / 2 , 260, 13)];
        _contentTF.textAlignment = NSTextAlignmentLeft;
        _contentTF.font = [UIFont systemFontOfSize:13];
    }
    return _contentTF;
}

@end
