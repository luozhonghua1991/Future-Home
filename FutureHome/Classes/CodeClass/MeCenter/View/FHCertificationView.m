//
//  FHCertificationView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  实名认证View

#import "FHCertificationView.h"

@interface FHCertificationView ()


@end

@implementation FHCertificationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.userInteractionEnabled = YES;
    [self addSubview:self.logoLabel];
    [self addSubview:self.contentTF];
    [self addSubview:self.bottomLineView];
}


#pragma mark — setter && getter
- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 160, 60)];
        _logoLabel.textColor = [UIColor blackColor];
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _logoLabel;
}

- (UITextField *)contentTF {
    if (!_contentTF) {
        _contentTF = [[UITextField alloc] initWithFrame:CGRectMake(160, 20, 200, 20)];
        _contentTF.textAlignment = NSTextAlignmentRight;
        _contentTF.font = [UIFont systemFontOfSize:15];
    }
    return _contentTF;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

@end
