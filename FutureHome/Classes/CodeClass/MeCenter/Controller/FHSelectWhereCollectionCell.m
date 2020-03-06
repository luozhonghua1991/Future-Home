//
//  FHSelectWhereCollectionCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/6.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHSelectWhereCollectionCell.h"

@implementation FHSelectWhereCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.selectBtn];
}


- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = self.contentView.bounds;
    }
    return _selectBtn;
}

@end
