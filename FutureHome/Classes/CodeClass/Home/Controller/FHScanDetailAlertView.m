//
//  FHScanDetailAlertView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/18.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHScanDetailAlertView.h"

@implementation FHScanDetailAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.3];
        [self rw_setUpUI];
    }
    return self;
}


#pragma mark -- tap
//- (void)tapClick {
//    [self removeView];
//}

- (void)closeBtnClick {
    [self removeView];
}

#pragma mark -- removeView
/**
 让View消失
 */
- (void)removeView{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark -- privite
- (void)rw_setUpUI {
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.codeImgView];
    [self.whiteBgView addSubview:self.titleLabel];
    [self.whiteBgView addSubview:self.closeBtn];
    [self.whiteBgView addSubview:self.titleLabel];
    [self.whiteBgView addSubview:self.topLabel];
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-80);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 160, 350));
    }];
    
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.whiteBgView);
        make.centerY.mas_equalTo(self.whiteBgView);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 160, 16));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeImgView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 160, 114));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)setDataDetaildic:(NSDictionary *)dataDetaildic {
    _dataDetaildic = dataDetaildic;
    self.codeImgView.image = [SGQRCodeObtain generateQRCodeWithData:[self DataTOjsonString:_dataDetaildic] size:150];
    self.titleLabel.text = [NSString stringWithFormat:@"社云账号:%@",_dataDetaildic[@"username"]];
    self.topLabel.text = _dataDetaildic[@"name"];
}

#pragma mark - 得到jsonString
- (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark -- setter getter
- (UIView *)whiteBgView {
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc]init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.userInteractionEnabled =YES;
        _whiteBgView.layer.cornerRadius = 7.5;
        _whiteBgView.clipsToBounds = YES;
    }
    return _whiteBgView;
}

- (UIImageView *)codeImgView {
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
    }
    return _codeImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = HEX_COLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"activity_coin_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.textColor = HEX_COLOR(0x4D4D4D);
        _topLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _topLabel.text = @"";
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.numberOfLines = 0;
    }
    return _topLabel;
}

@end
