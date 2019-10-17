//
//  FHMenuListCollectionCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/25.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMenuListCollectionCell.h"

@interface FHMenuListCollectionCell ()

@end

@implementation FHMenuListCollectionCell

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
    self.listNameLabel.y = CGRectGetMaxY(self.logoImgView.frame) + 10;
    [self.contentView addSubview:self.listNameLabel];
}


#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 35, 35)];
        _logoImgView.image = [UIImage imageNamed:@"tarbar_home_normal"];
    }
    return _logoImgView;
}

- (UILabel *)listNameLabel {
    if (!_listNameLabel) {
        _listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 16)];
        _listNameLabel.textAlignment = NSTextAlignmentCenter;
        _listNameLabel.font = [UIFont systemFontOfSize:15];
        _listNameLabel.textColor = [UIColor blackColor];
#warning message
        _listNameLabel.text = @"物业服务";
    }
    return _listNameLabel;
}

@end
