//
//  FHProofOfOwnershipView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  权属证明View

#import "FHProofOfOwnershipView.h"

@interface FHProofOfOwnershipView ()

@end

@implementation FHProofOfOwnershipView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.titleLabel];
}


#pragma mark — setter && getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, SCREEN_WIDTH - 20, 40)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

@end
