//
//  FHUserInfoHeaderBaseView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHUserInfoHeaderBaseView.h"

@implementation FHUserInfoHeaderBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.topLogLabel];
    [self addSubview:self.bottomLogLabel];
}


#pragma mark - 懒加载
- (UILabel *)topLogLabel {
    if (!_topLogLabel) {
        _topLogLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH / 4, 14)];
        _topLogLabel.text = @"许大宝~";
        _topLogLabel.textColor = [UIColor blackColor];
        _topLogLabel.textAlignment = NSTextAlignmentCenter;
        _topLogLabel.font = [UIFont systemFontOfSize:14];
    }
    return _topLogLabel;
}

- (UILabel *)bottomLogLabel {
    if (!_bottomLogLabel) {
        _bottomLogLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29 + 5, SCREEN_WIDTH / 4, 12)];
        _bottomLogLabel.text = @"许大宝~";
        _bottomLogLabel.textColor = [UIColor lightGrayColor];
        _bottomLogLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLogLabel.font = [UIFont systemFontOfSize:12];
    }
    return _bottomLogLabel;
}

@end
