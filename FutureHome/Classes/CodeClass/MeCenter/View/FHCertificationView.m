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
        self.backgroundColor = [UIColor lightGrayColor];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.userInteractionEnabled = YES;
    [self addSubview:self.logoLabel];
    [self addSubview:self.contentTF];
}


#pragma mark — setter && getter
- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 60)];
        _logoLabel.textColor = [UIColor blackColor];
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _logoLabel;
}

- (UITextField *)contentTF {
    if (!_contentTF) {
        _contentTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 20, 200, 20)];
        _contentTF.textAlignment = NSTextAlignmentLeft;
        _contentTF.font = [UIFont systemFontOfSize:15];
    }
    return _contentTF;
}

@end
