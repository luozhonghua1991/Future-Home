//
//  FHUserAgreementView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHUserAgreementView.h"
#import "NSMutableAttributedString+XZCategory.h"

@interface FHUserAgreementView ()
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 协议label */
@property (nonatomic, strong) UILabel *agrmmmentLabel;
/** 整体的View */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation FHUserAgreementView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.userInteractionEnabled = YES;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.agrmmmentLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [UIlabelTool sizeWithString:@"点击按钮即表示您同意《用户信息授权协议》，并确认授权" font:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH];
    self.contentView.width = size.width + 15;
    self.contentView.height = 15;
    self.contentView.centerX = self.width / 2;
    
    self.agrmmmentLabel.frame = CGRectMake(17, 0, size.width,
                                           15);
}

- (void)tapClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHUserAgreementViewClick)]) {
        [_delegate FHUserAgreementViewClick];
    }
}

- (void)selectBtnClick:(UIButton *)sender {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_fhuserAgreementWithBtn:)]) {
        [_delegate fh_fhuserAgreementWithBtn:sender];
    }
}

#pragma mark — setter && getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(0, 0, 15, 15);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)agrmmmentLabel {
    if (!_agrmmmentLabel) {
        _agrmmmentLabel = [[UILabel alloc] init];
        _agrmmmentLabel.font = [UIFont systemFontOfSize:13];
        NSString *titleString = @"点击按钮即表示您同意《用户信息授权协议》，并确认授权";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:UIColorFromRGB(0x4393D9) rang:[attributedTitle changeSystemFontFloat:13 from:10 legth:10]];
        _agrmmmentLabel.textColor = UIColorFromRGB(0x666666);
        _agrmmmentLabel.textAlignment = NSTextAlignmentCenter;
        _agrmmmentLabel.attributedText = attributedTitle;
        _agrmmmentLabel.userInteractionEnabled = YES;
    }
    return _agrmmmentLabel;
}

@end
