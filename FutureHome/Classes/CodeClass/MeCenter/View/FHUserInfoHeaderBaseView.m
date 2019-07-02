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
    
}

#pragma mark - 懒加载
- (UILabel *)topLogLabel {
    if (!_topLogLabel) {
        _topLogLabel = [[UILabel alloc] initWithFrame:CGRectMake(75 + 20, 0, 100, 14)];
        _topLogLabel.text = @"许大宝~";
        _topLogLabel.textColor = [UIColor blackColor];
        _topLogLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLogLabel;
}

@end
