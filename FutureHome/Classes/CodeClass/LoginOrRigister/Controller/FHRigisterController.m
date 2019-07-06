//
//  FHRigisterController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  用户注册

#import "FHRigisterController.h"
#import "RWTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FHEntryVerificationCodeController.h"

@interface FHRigisterController () <UITextFieldDelegate>

/** <#Description#> */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/**标题label*/
@property (nonatomic,strong) UILabel                       *titleLabel;
/**手机号码View*/
@property (nonatomic,strong) UIView                        *phoneNumnberView;
/**国家区号按钮*/
@property (nonatomic,strong) UIButton                      *countryBtn;
/**手机号码TF*/
@property (nonatomic,strong) RWTextField                   *phoneNumnTF;
/**下一步按钮*/
@property (nonatomic,strong) UIButton                      *nextStepBtn;
///**条款label*/
@property (nonatomic,strong) UILabel                       *clauseLabel;
/**区号*/
@property (nonatomic,copy) NSString                        *dialing_code;
/**服务条款按钮*/
@property (nonatomic,strong) UIButton                      *leftBtn;
/**隐私策略按钮*/
@property (nonatomic,strong) UIButton                      *rightBtn;

@end

@implementation FHRigisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dialing_code = @"86";
    // Nav buttonItem
//    [self navLeftButtonItemIcon:@"rw_login_back" highIcon:@"rw_login_back"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    
    [self.scrollView addSubview:self.phoneNumnberView];
    [self.phoneNumnberView addSubview:self.countryBtn];
    [self.phoneNumnberView addSubview:self.phoneNumnTF];
    
    [self.scrollView addSubview:self.nextStepBtn];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //整个的滚动试图
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0 ));
    }];
    //titleLabel
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.centerX.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(20);
    }];
    //手机号码View
    [self.phoneNumnberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(50);
        make.left.mas_equalTo(27.5);
        make.width.mas_equalTo(SCREEN_WIDTH - 55);
        make.height.mas_equalTo(47);
    }];
    //国家区号
    [self.countryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.phoneNumnberView);
    }];
    
    [self.phoneNumnTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.countryBtn.mas_right).offset(15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.phoneNumnberView);
    }];
    
    //下一步按钮
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumnberView.mas_bottom).offset(15);
        make.left.mas_equalTo(20.5);
        //        make.right.mas_equalTo(-20.5);
        make.width.mas_equalTo(SCREEN_WIDTH - 41);
        make.height.mas_equalTo(55);
    }];
    
    [self.scrollView contentSizeToFit];
    
}

#pragma mark -- events
- (void)nextStepBtnClick {
    if (0 == self.phoneNumnTF.text.length) {
        [self.view makeToast:@"亲，请先输入手机号码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = self.phoneNumnTF.text;
    param[@"dialing_code"] = self.dialing_code;
    [self goToIdentifyingCodeVC];
    //检测手机号是否被注册
//    WS(weakSelf);
//    [LoginService verifyPhoneNumberIsRegisteredWithParams:@{@"sms":param} success:^(NSDictionary *respond) {
//        //手机号没有注册
//        [weakSelf goToIdentifyingCodeVC];
//    } failure:^(NSString *msg) {
//        [self.view makeToast:msg];
//    }];
}

- (void)goToIdentifyingCodeVC {
    //验证码输入界面
    FHEntryVerificationCodeController *vc = [[FHEntryVerificationCodeController alloc]init];
    vc.phoneNumber = self.phoneNumnTF.text;
    vc.dialing_code = self.dialing_code;
    //新用户注册界面
    vc.vcType = REGISTER_VC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    
    scrollView.contentOffset = point;
}

#pragma mark -- 输入框文字判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 100) {
        if (((((int)range.location>=0)&&(![string isEqualToString:@""])) || (((int)range.location>=1)&&[string isEqualToString:@""]))) {
            self.nextStepBtn.userInteractionEnabled = YES;
            self.nextStepBtn.alpha = 1;
            [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
        }else{
            self.nextStepBtn.userInteractionEnabled = NO;
            self.nextStepBtn.alpha = 0.5;
            [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        }
        return YES;
    }
    return YES;
    
}

- (void)phoneNumnberViewClick {
    [self.phoneNumnTF becomeFirstResponder];
}

#pragma mark -- setter getter
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    }
    return _scrollView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _titleLabel.text = @"手机快速注册";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)phoneNumnberView {
    if (!_phoneNumnberView) {
        _phoneNumnberView = [[UIView alloc]init];
        _phoneNumnberView.layer.cornerRadius = 25;
        _phoneNumnberView.backgroundColor = [UIColor whiteColor];
        _phoneNumnberView.layer.borderColor = HEX_COLOR(0xC0C0C0).CGColor;
        _phoneNumnberView.layer.borderWidth = 0.5;
        _phoneNumnberView.clipsToBounds = YES;
        _phoneNumnberView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneNumnberViewClick)];
        [_phoneNumnberView addGestureRecognizer:tap];
    }
    return _phoneNumnberView;
}

- (UIButton *)countryBtn {
    if (!_countryBtn) {
        //区号选择按钮
        UIImage *image = [UIImage imageNamed:@"sign_in_arrow"];
        CGSize size = [UIlabelTool sizeWithString:@"+86" font:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_countryBtn setTitle:@"+86" forState:UIControlStateNormal];
        [_countryBtn setTitleColor:HEX_COLOR(0x33333) forState:UIControlStateNormal];
        _countryBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _countryBtn.backgroundColor = [UIColor whiteColor];
        [_countryBtn setImage:image forState:UIControlStateNormal];
        [_countryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width * 2, 0, 0)];
//        [_countryBtn addTarget:self action:@selector(moreCountryTouchOn:)
//              forControlEvents:UIControlEventTouchUpInside];
    }
    return _countryBtn;
}

- (RWTextField *)phoneNumnTF {
    if (!_phoneNumnTF) {
        _phoneNumnTF = [[RWTextField alloc]init];
        _phoneNumnTF.delegate = self;
        _phoneNumnTF.tag = 100;
        _phoneNumnTF.textColor = HEX_COLOR(0x333333);
        _phoneNumnTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumnTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _phoneNumnTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xA6A6A6)}];
    }
    return _phoneNumnTF;
}

- (UIButton *)nextStepBtn {
    if (!_nextStepBtn) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_nextStepBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        _nextStepBtn.alpha = 0.5;
        [_nextStepBtn setTitleColor:HEX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextStepBtn.userInteractionEnabled = NO;
    }
    return _nextStepBtn;
}

@end
