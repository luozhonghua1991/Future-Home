//
//  FHHomePageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  主页

#import "FHHomePageController.h"

@interface FHHomePageController ()
/** 导航View视图 */
@property (nonatomic, strong) UIView *navView;
/** 坐标图片 */
@property (nonatomic, strong) UIImageView *locationImgView;
/** 地点名字label */
@property (nonatomic, strong) UILabel *locationLabel;


@end

@implementation FHHomePageController


#pragma mark — privite
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}

- (void)setNav {
    CGFloat H = MainNavgationBarHeight;
    NSLog(@"%f",H);
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    self.navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.locationImgView];
    [self.navView addSubview:self.locationLabel];
    
    
    
}


#pragma mark — setter & getter
#pragma mark - 懒加载
- (UIImageView *)locationImgView {
    if (!_locationImgView) {
        _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, MainNavgationBarHeight - 10)];
        _locationImgView.backgroundColor = [UIColor blueColor];
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

@end
