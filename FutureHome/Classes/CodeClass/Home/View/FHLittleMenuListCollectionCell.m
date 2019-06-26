//
//  FHLittleMenuListCollectionCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHLittleMenuListCollectionCell.h"

@interface FHLittleMenuListCollectionCell ()
/** 图标 */
@property (nonatomic, strong) UIImageView *logoImgView;
/** 名字 */
@property (nonatomic, strong) UILabel *listNameLabel;

@end

@implementation FHLittleMenuListCollectionCell


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
    self.listNameLabel.y = CGRectGetMaxY(self.logoImgView.frame) + 5;
    [self.contentView addSubview:self.listNameLabel];
}


#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
        _logoImgView.image = [UIImage imageNamed:@"tarbar_home_normal"];
    }
    return _logoImgView;
}

- (UILabel *)listNameLabel {
    if (!_listNameLabel) {
        _listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 12)];
        _listNameLabel.text = @"物业服务";
        _listNameLabel.textAlignment = NSTextAlignmentCenter;
        _listNameLabel.font = [UIFont systemFontOfSize:12];
        _listNameLabel.textColor = [UIColor blackColor];
    }
    return _listNameLabel;
}

@end
