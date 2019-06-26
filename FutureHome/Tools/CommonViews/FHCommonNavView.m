//
//  FHCommonNavView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  顶部通用导航View

#import "FHCommonNavView.h"

@interface FHCommonNavView ()
/** 坐标图片 */
@property (nonatomic, strong) UIImageView *locationImgView;
/** 地点名字label */
@property (nonatomic, strong) UILabel *locationLabel;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchBtn;
/** 收藏按钮 */
@property (nonatomic, strong) UIButton *collectBtn;

@end

@implementation FHCommonNavView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self fm_setUpUI];
    }
    return self;
}

#pragma mark — privite
- (void)fm_setUpUI {
    [self addSubview:self.locationImgView];
    [self addSubview:self.locationLabel];
    self.searchBtn.frame = CGRectMake(0, (MainNavgationBarHeight - 16) / 2, 100, 16);
    self.searchBtn.centerX = self.width / 2;
    [self addSubview:self.searchBtn];
    self.collectBtn.frame = CGRectMake(self.width - 55, (MainNavgationBarHeight - 16) / 2, 50, 16);
    [self addSubview:self.collectBtn];
}


#pragma mark — event
- (void)searchBtnClick {
    /** 搜索事件 */
    if (self.searchBlock) {
        self.searchBlock();
    }
}

- (void)collectBtnClick {
    /** 收藏事件 */
    if (self.collectBlock) {
        self.collectBlock();
    }
}


#pragma mark - 懒加载
- (UIImageView *)locationImgView {
    if (!_locationImgView) {
        _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, MainNavgationBarHeight - 10)];
        _locationImgView.image = [UIImage imageNamed:@"tarbar_home_normal"];
    }
    return _locationImgView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationImgView.frame) + 5, (MainNavgationBarHeight - 16) / 2, 100, 16)];
        _locationLabel.textColor = [UIColor blackColor];
        _locationLabel.text = @"重庆市";
        _locationLabel.font = [UIFont systemFontOfSize:16];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _locationLabel;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索🔍" forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setTitle:@"+收藏" forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}


@end
