//
//  FHVerificationCodeLoginController.m
//  RWGame
//
//  Created by luozhonghua on 2018/7/18.
//  Copyright © 2018年 chao.liu. All rights reserved.
//  验证码登录界面(点击验证码登录跳转的界面)

#import "FHVerificationCodeLoginController.h"
#import "TPKeyboardAvoidingScrollView.h"
//#import "OtherLoginView.h"
//#import <UMSocialCore/UMSocialCore.h>
//#import "LoginService.h"
//#import "Account.h"
//#import "XWCountryCodeController.h"
#import "RWTextField.h"
#import "FHEntryVerificationCodeController.h"

@interface FHVerificationCodeLoginController ()<UITextFieldDelegate>

/** <#Description#> */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/** 头部图片 */
@property (nonatomic, strong) UIImageView                  *titleView;
/**手机号码View*/
@property (nonatomic,strong) UIView                        *phoneNumnberView;
/**国家区号按钮*/
@property (nonatomic,strong) UIButton                      *countryBtn;
/**手机号码TF*/
@property (nonatomic,strong) RWTextField                   *phoneNumnTF;
/**发送验证码按钮*/
@property (nonatomic,strong) UIButton                      *nextStepBtn;
/**区号*/
@property (nonatomic,copy) NSString                        *dialing_code;

@end

@implementation FHVerificationCodeLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dialing_code = @"86";
    // Nav buttonItem 左边的关闭按钮
//     [self navLeftButtonItemIcon:@"rw_login_back" highIcon:@"rw_login_back"];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleView];
    
    [self.scrollView addSubview:self.phoneNumnberView];
    [self.phoneNumnberView addSubview:self.countryBtn];
    [self.phoneNumnberView addSubview:self.phoneNumnTF];
    
    [self.scrollView addSubview:self.nextStepBtn];
    
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0 ));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    //手机号码区域布局
    [self.phoneNumnberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(40);
        make.left.mas_equalTo(27.5);
        make.width.mas_equalTo(@(self.view.width - 55));
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
        make.width.mas_equalTo(kScreenWidth - 41);
        make.height.mas_equalTo(55);
    }];
    
    [self.scrollView contentSizeToFit];
    
}


#pragma mark -- events
- (void)nextStepBtnClick {
    //校验手机号请求
    if (0 == self.phoneNumnTF.text.length) {
        [self.view makeToast:@"亲，请先输入手机号码"];
        return;
    }
    //验证码输入界面
    FHEntryVerificationCodeController *vc = [[FHEntryVerificationCodeController alloc]init];
    vc.phoneNumber = self.phoneNumnTF.text;
    //验证码登录界面
    vc.vcType = VERIFICATIONLOGIN_VC;
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

////国家区号按钮点击事件
//- (void)moreCountryTouchOn:(UIButton *)btn {
//    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
//    WS(weakSelf);
//    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
//        NSLog(@"我获取到的区号%@",countryCodeStr);
//         weakSelf.dialing_code  = countryCodeStr;
//        CGSize size = [UIlabelTool sizeWithString:[NSString stringWithFormat:@"+%@",countryCodeStr] font:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
//        [self.countryBtn setTitle:[NSString stringWithFormat:@"+%@",countryCodeStr] forState:UIControlStateNormal];
//        [self.countryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width * 2, 0, 0)];
//        weakSelf.phoneNumnTF.text = @"";
//    }];
//    [self.navigationController pushViewController:CountryCodeVC animated:YES];
//}

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

//电竞大师logo
- (UIImageView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIImageView alloc] init];
        _titleView.image = [UIImage imageNamed:@"rw_logo"];
        //        _titleView.frame = MAKEFRAME(0, 0, self.view.width, 100);
    }
    return _titleView;
}

- (UIView *)phoneNumnberView {
    if (!_phoneNumnberView) {
        _phoneNumnberView = [[UIView alloc]init];
        _phoneNumnberView.layer.cornerRadius = 25;
        _phoneNumnberView.backgroundColor = [UIColor whiteColor];
        _phoneNumnberView.layer.borderColor = HEX_COLOR(0xC0C0C0).CGColor;
        _phoneNumnberView.layer.borderWidth = 0.5;
        _phoneNumnberView.clipsToBounds = YES;
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
        _nextStepBtn.userInteractionEnabled = NO;
        [_nextStepBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    return _nextStepBtn;
}

@end
