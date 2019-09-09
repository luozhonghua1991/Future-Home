//
//  FHVideoListViewCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHVideoListViewCell.h"

@implementation FHVideoListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.logoImgView.centerX = self.contentView.width / 2;
    [self.contentView addSubview:self.logoImgView];
    self.listNameLabel.y = CGRectGetMaxY(self.logoImgView.frame) + 1;
    [self.contentView addSubview:self.listNameLabel];
}


#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.contentView.width - 10, self.contentView.width)];
        _logoImgView.image = [UIImage imageNamed:@"头像"];
    }
    return _logoImgView;
}

- (UILabel *)listNameLabel {
    if (!_listNameLabel) {
        _listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.contentView.width - 10, 44)];
        _listNameLabel.textAlignment = NSTextAlignmentLeft;
        _listNameLabel.font = [UIFont systemFontOfSize:10];
        _listNameLabel.textColor = [UIColor blackColor];
        _listNameLabel.numberOfLines = 2;
#warning message
        _listNameLabel.text = @"标题内容展示区域标题内容展示区域标题内容展示区域标题内容展示区域标题内容展示区域";
    }
    return _listNameLabel;
}

@end
