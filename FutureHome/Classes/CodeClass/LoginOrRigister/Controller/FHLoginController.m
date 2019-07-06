//
//  FHLoginController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  用户登录

#import "FHLoginController.h"
#import "FHLoginTool.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "RWTextField.h"
#import "LoginView.h"

@interface FHLoginController () <UITextFieldDelegate,LoginViewDelegate>
/** <#Description#> */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/** 头部图片 */
@property (nonatomic, strong) UIImageView    *titleView;
/**手机号码View*/
@property (nonatomic,strong) UIView          *phoneNumnberView;
/**登录密码View*/
@property (nonatomic,strong) UIView          *passwordView;
/**国家区号按钮*/
@property (nonatomic,strong) UIButton        *countryBtn;
/**手机号码TF*/
@property (nonatomic,strong) RWTextField     *phoneNumnTF;
/**登录密码TF*/
@property (nonatomic,strong) RWTextField     *passwordTF;
/**密码右边眼睛按钮*/
@property (nonatomic,strong) UIButton        *passwordRightBtn;
/** 登录视图 */
@property (nonatomic, strong) LoginView      *login;

@end

@implementation FHLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    [self fh_setUpUI];
}

- (void)fh_setUpUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleView];
    
    [self.scrollView addSubview:self.phoneNumnberView];
    [self.phoneNumnberView addSubview:self.countryBtn];
    [self.phoneNumnberView addSubview:self.phoneNumnTF];
    
    [self.scrollView addSubview:self.passwordView];
    [self.passwordView addSubview:self.passwordTF];
    [self.passwordView addSubview:self.passwordRightBtn];
    
    [self.scrollView addSubview:self.login];
    //验证码登录
    self.login.leftTitle.text = @"验证码登录";
    self.login.rightTitle.text = @"忘记密码";
    [self.login.underButton setTitle:@"登录" forState:UIControlStateNormal];
    self.login.underButton.userInteractionEnabled = NO;
    [self.login.rigisterBtn setTitle:@"注册" forState:UIControlStateNormal];
}

#pragma mark -- layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0 ));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    //手机号码区域布局
    [self.phoneNumnberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(40);
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
    //密码区域的布局
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumnberView.mas_bottom).offset(14);
        make.left.mas_equalTo(self.phoneNumnberView);
        make.width.mas_equalTo(self.phoneNumnberView);
        make.height.mas_equalTo(self.phoneNumnberView);
    }];
    
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(self.passwordView.width - 40 - 35);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.passwordView);
    }];
    
    [self.passwordRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordView);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.view);
        make.height.equalTo(@170);
    }];
    
    [self.scrollView contentSizeToFit];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    
    scrollView.contentOffset = point;
}


#pragma mark -- events
/**
 密码按钮 眼睛的点击事件
 
 @param sender <#sender description#>
 */
- (void)eyesTouchOn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        self.passwordTF.secureTextEntry = NO;
    }else{
        self.passwordTF.secureTextEntry = YES;
    }
}


#pragma mark -- 输入框文字判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 100) {
        if(((((int)range.location>=0)&&(![string isEqualToString:@""])) || (((int)range.location>=1)&&[string isEqualToString:@""]))) {
            if (![self.passwordTF.text isEqualToString:@""]) {
                self.login.underButton.userInteractionEnabled = YES;
                self.login.underButton.alpha = 1;
                [self.login.underButton setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
            }
        } else {
            self.login.underButton.userInteractionEnabled = NO;
            self.login.underButton.alpha = 0.5;
            [self.login.underButton setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        }
        return YES;
    } else {
        if(((((int)range.location>=0)&&(![string isEqualToString:@""])) || (((int)range.location>=1)&&[string isEqualToString:@""]))) {
            if (![self.phoneNumnTF.text isEqualToString:@""]) {
                self.login.underButton.userInteractionEnabled = YES;
                self.login.underButton.alpha = 1;
                [self.login.underButton setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
            }
        } else {
            self.login.underButton.userInteractionEnabled = NO;
            self.login.underButton.alpha = 0.5;
            [self.login.underButton setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        }
        return YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)phoneNumnberViewClick {
    [self.phoneNumnTF becomeFirstResponder];
}

- (void)passwordViewClick {
    [self.passwordTF becomeFirstResponder];
}


#pragma mark — delegate
- (void)loginView:(LoginView *)view withName:(NSString *)name {
    if ([name isEqualToString:@"验证码登录"]) {
        //验证码登录
        [self viewControllerPushOther:@"FHVerificationCodeLoginController"];
    } else if ([name isEqualToString:@"忘记密码"]) {
        [self viewControllerPushOther:@"FHForgetPasswordController"];
    } else if ([name isEqualToString:@"登录"]) {
        //登录请求
        [self.view endEditing:YES];
        if (0 == self.phoneNumnTF.text.length) {
            [self.view makeToast:@"亲，请先输入手机号码"];
            return;
        }
        if (0 == self.passwordTF.text.length) {
            [self.view makeToast:@"亲，未填写密码"];
            return;
        }
        
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"dialing_code"] = self.dialing_code;
//        params[@"phone"] = self.phoneNumnTF.text;
//        params[@"password"] = self.passwordTF.text;
//        [LoginService loginWithParams:@{@"session":params} success:^(Account *accout) {
//            [self.view.window makeToast:@"登录成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"PERSONLOGIN" object:nil];
//        } failure:^(NSString *msg) {
//            [self.view makeToast:msg];
//        }];
    } else if ([name isEqualToString:@"注册"]) {
        [self viewControllerPushOther:@"FHRigisterController"];
    } else {
        [self.view makeToast:@"亲，请输入有效的手机号码"];
    }
}

/**
 *  从 A 控制器跳转到 B 控制器
 *
 *  @param nameVC B 控制器名称
 *  @param param  可选参数
 */
- (void)viewControllerPushOther:(nonnull NSString *)nameVC {
    UIViewController *vc = [[NSClassFromString(nameVC) alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Getters and Setters
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
    }
    return _titleView;
}

- (LoginView *)login {
    if (_login == nil) {
        _login = [[LoginView alloc] init];
        _login.delegate = self;
        //        _login.frame = MAKEFRAME(0, self.codeTF.bottom, self.view.width, 135);
    }
    return _login;
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

- (UIView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[UIView alloc]init];
        _passwordView.layer.cornerRadius = 25;
        _passwordView.backgroundColor = [UIColor whiteColor];
        _passwordView.layer.borderColor = HEX_COLOR(0xC0C0C0).CGColor;
        _passwordView.layer.borderWidth = 0.5;
        _passwordView.clipsToBounds = YES;
        _passwordView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passwordViewClick)];
        [_passwordView addGestureRecognizer:tap];
    }
    return _passwordView;
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
        _phoneNumnTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"账号" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xA6A6A6)}];
    }
    return _phoneNumnTF;
}

- (RWTextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [[RWTextField alloc]init];
        _passwordTF.delegate = self;
        _passwordTF.tag = 200;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.textColor = HEX_COLOR(0x333333);
        _passwordTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xA6A6A6)}];
    }
    return _passwordTF;
}

- (UIButton *)passwordRightBtn {
    if (!_passwordRightBtn) {
        _passwordRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _passwordRightBtn.selected = NO;
        [_passwordRightBtn setImage:[UIImage imageNamed:@"password_to_login_can_not_see"] forState:UIControlStateNormal];
        [_passwordRightBtn setImage:[UIImage imageNamed:@"password_to_login_see"] forState:UIControlStateSelected];
        [_passwordRightBtn addTarget:self action:@selector(eyesTouchOn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordRightBtn;
}

- (void)dealloc {
    
}

@end
