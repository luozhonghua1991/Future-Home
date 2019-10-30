//
//  FHServiceCommonHeaderView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHServiceCommonHeaderView.h"

@implementation FHServiceCommonHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self fh_installUI];
    }
    return self;
}

- (void)fh_installUI {
    [self addSubview:self.headerImgView];
    [self addSubview:self.shopNameLabel];
    [self addSubview:self.codeLabel];
    [self addSubview:self.fansLabel];
    [self addSubview:self.countLabel];
    
    [self addSubview:self.upCountLabel];
    [self addSubview:self.personCountBtn];
    [self addSubview:self.bottomLineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerImgView.frame = CGRectMake(10, 0, 100, 100);
    self.headerImgView.centerY = self.height / 2;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:@""]];
    self.shopNameLabel.frame = CGRectMake(MaxX(self.headerImgView) + 15, 25, SCREEN_WIDTH, 25);
    self.codeLabel.frame = CGRectMake(MaxX(self.headerImgView) + 15, MaxY(self.shopNameLabel) + 10, SCREEN_WIDTH - 150, 35);
    
    self.countLabel.frame = CGRectMake(MaxX(self.headerImgView) + 15, MaxY(self.codeLabel) + 10, 50, 13);
    
    self.upCountLabel.frame = CGRectMake(MaxX(self.countLabel) + 40, MaxY(self.codeLabel) + 10, 50, 13);
    
    self.fansLabel.frame = CGRectMake(SCREEN_WIDTH - 95, MaxY(self.codeLabel) + 10, 60, 13);
    
    self.bottomLineView.frame = CGRectMake(0, 139.5, SCREEN_WIDTH, 0.5);
    
    self.personCountBtn.frame = CGRectMake(SCREEN_WIDTH - 120 , MaxY(self.shopNameLabel) + 20, 100, 13);
}


#pragma mark — setter && getter
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = 50;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.clipsToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.textAlignment = NSTextAlignmentLeft;
        _shopNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _shopNameLabel.textColor = HEX_COLOR(0x0000FF);
#warning message
//        _shopNameLabel.text = @"未来生鲜龙湖U城店未来式未来式未来式";
    }
    return _shopNameLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textAlignment = NSTextAlignmentLeft;
        _codeLabel.font = [UIFont systemFontOfSize:15];
        _codeLabel.textColor = HEX_COLOR(0x0000FF);
#warning message
//        _codeLabel.text = @"未来生鲜龙湖U城自营店未来家园官方号:CQ20192890";
    }
    return _codeLabel;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textAlignment = NSTextAlignmentLeft;
        _fansLabel.font = [UIFont systemFontOfSize:13];
        _fansLabel.textColor = [UIColor blackColor];
//        _fansLabel.backgroundColor = [UIColor redColor];
#warning message
//        _fansLabel.text = @"粉丝数量";
    }
    return _fansLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textColor = [UIColor blackColor];
#warning message
//        _countLabel.text = @"创作数量:100";
    }
    return _countLabel;
    
}

- (UILabel *)upCountLabel {
    if (!_upCountLabel) {
        _upCountLabel = [[UILabel alloc] init];
        _upCountLabel.textAlignment = NSTextAlignmentRight;
        _upCountLabel.font = [UIFont systemFontOfSize:13];
        _upCountLabel.textColor = [UIColor blackColor];
//        _upCountLabel.backgroundColor = [UIColor redColor];
#warning message
        _upCountLabel.text = @"点赞数:20W";
    }
    return _upCountLabel;
}

- (UIButton *)personCountBtn {
    if (!_personCountBtn) {
        _personCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_personCountBtn setTitle:@"用户评论" forState:UIControlStateNormal];
        _personCountBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_personCountBtn setTitleColor:HEX_COLOR(0x0000FF) forState:UIControlStateNormal];
    }
    return _personCountBtn;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

@end
