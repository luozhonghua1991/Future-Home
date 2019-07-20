//
//  FHDetailAddressView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/19.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHDetailAddressView.h"

@interface FHDetailAddressView ()
/** 省市区 */
@property (nonatomic, strong) UILabel *leftProvinceLabel;
/** 省市区 */
@property (nonatomic, strong) UILabel *centerProvinceLabel;
/** 省市区 */
@property (nonatomic, strong) UILabel *rightProvinceLabel;
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation FHDetailAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.leftProvinceLabel];
    [self addSubview:self.centerProvinceLabel];
    [self addSubview:self.rightProvinceLabel];
    
    [self addSubview:self.leftProvinceDataLabel];
    [self addSubview:self.centerProvinceDataLabel];
    [self addSubview:self.rightProvinceDataLabel];
    
    [self addSubview:self.bottomLineView];
}


#pragma mark — setter && getter
- (UILabel *)leftProvinceLabel {
    if (!_leftProvinceLabel) {
        _leftProvinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 20, 15)];
        _leftProvinceLabel.textColor = [UIColor blackColor];
        _leftProvinceLabel.textAlignment = NSTextAlignmentLeft;
        _leftProvinceLabel.font = [UIFont systemFontOfSize:15];
        _leftProvinceLabel.text = @"省";
    }
    return _leftProvinceLabel;
}

- (UILabel *)leftProvinceDataLabel {
    if (!_leftProvinceDataLabel) {
        _leftProvinceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftProvinceLabel.frame) + 5, 24, 50, 13)];
        _leftProvinceDataLabel.textColor = [UIColor blackColor];
        _leftProvinceDataLabel.textAlignment = NSTextAlignmentLeft;
        _leftProvinceDataLabel.font = [UIFont systemFontOfSize:13];
        _leftProvinceDataLabel.text = @"北京市";
    }
    return _leftProvinceDataLabel;
}

- (UILabel *)centerProvinceLabel {
    if (!_centerProvinceLabel) {
        _centerProvinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftProvinceDataLabel.frame) + 5, 23, 20, 15)];
        _centerProvinceLabel.textColor = [UIColor blackColor];
        _centerProvinceLabel.textAlignment = NSTextAlignmentLeft;
        _centerProvinceLabel.font = [UIFont systemFontOfSize:15];
        _centerProvinceLabel.text = @"市";
    }
    return _centerProvinceLabel;
}

- (UILabel *)centerProvinceDataLabel {
    if (!_centerProvinceDataLabel) {
        _centerProvinceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.centerProvinceLabel.frame) + 5, 24, 80, 13)];
        _centerProvinceDataLabel.textColor = [UIColor blackColor];
        _centerProvinceDataLabel.textAlignment = NSTextAlignmentLeft;
        _centerProvinceDataLabel.font = [UIFont systemFontOfSize:13];
        _centerProvinceDataLabel.text = @"乌鲁木齐市";
    }
    return _centerProvinceDataLabel;
}

- (UILabel *)rightProvinceLabel {
    if (!_rightProvinceLabel) {
        _rightProvinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.centerProvinceDataLabel.frame) + 5, 23, 35, 15)];
        _rightProvinceLabel.textColor = [UIColor blackColor];
        _rightProvinceLabel.textAlignment = NSTextAlignmentLeft;
        _rightProvinceLabel.font = [UIFont systemFontOfSize:15];
        _rightProvinceLabel.text = @"区县";
    }
    return _rightProvinceLabel;
}

- (UILabel *)rightProvinceDataLabel {
    if (!_rightProvinceDataLabel) {
        _rightProvinceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rightProvinceLabel.frame) + 5, 24, 200, 13)];
        _rightProvinceDataLabel.textColor = [UIColor blackColor];
        _rightProvinceDataLabel.textAlignment = NSTextAlignmentLeft;
        _rightProvinceDataLabel.font = [UIFont systemFontOfSize:13];
        _rightProvinceDataLabel.text = @"阿克苏啦啦啦啦啦啦啦";
    }
    return _rightProvinceDataLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}


@end
