//
//  FHSetPasswordController.m
//  RWGame
//
//  Created by luozhonghua on 2018/7/18.
//  Copyright © 2018年 chao.liu. All rights reserved.
//  设置密码界面

#import "FHSetPasswordController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "RWTextField.h"
#import "FHUserAgreementView.h"
#import "FHWebViewController.h"
//#import "LoginService.h"

@interface FHSetPasswordController () <UITextFieldDelegate,FHUserAgreementViewDelegate>
/** <#Description#> */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/**标题label*/
@property (nonatomic,strong) UILabel                       *titleLabel;
/**输入密码View*/
@property (nonatomic,strong) UIView                        *passwordView;
/**输入密码TF*/
@property (nonatomic,strong) RWTextField                   *passwordTF;
/**密码右边眼睛按钮*/
@property (nonatomic,strong) UIButton                      *passwordRightBtn;

/**确认密码View*/
@property (nonatomic,strong) UIView                        *surePasswordView;
/**确认密码TF*/
@property (nonatomic,strong) RWTextField                   *surePasswordTF;
/**确认密码右边眼睛按钮*/
@property (nonatomic,strong) UIButton                      *surePasswordRightBtn;

/**loglabel*/
@property (nonatomic,strong) UILabel                       *logLabel;

/**邀请码View*/
@property (nonatomic,strong) UIView                        *inviteCodeView;
/**邀请码TF*/
@property (nonatomic,strong) RWTextField                   *inviteCodeTF;

/**确认按钮*/
@property (nonatomic,strong) UIButton                      *sureBtn;
/** 用户协议 */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectCount;

@end

@implementation FHSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectCount = 0;
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    //左边返回按钮
//    [self navLeftButtonItemIcon:@"rw_login_back" highIcon:@"rw_login_back"];
    if ([self.titleString isEqualToString:@"设置密码"]) {
    }
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.titleLabel];
    
    [self.scrollView addSubview:self.passwordView];
    [self.passwordView addSubview:self.passwordTF];
    [self.passwordView addSubview:self.passwordRightBtn];
    
    [self.scrollView addSubview:self.surePasswordView];
    [self.surePasswordView addSubview:self.surePasswordTF];
    [self.surePasswordView addSubview:self.surePasswordRightBtn];
    
    [self.scrollView addSubview:self.logLabel];
    
    //新用户注册设置密码
//    [self.scrollView addSubview:self.inviteCodeView];
//    [self.inviteCodeView addSubview:self.inviteCodeTF];
    
    [self.scrollView addSubview:self.sureBtn];
    
    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0 ));
    }];
    
    if ([self.titleString isEqualToString:@"设置密码"]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.left.mas_equalTo(27.5);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(300);
        }];
        
        //密码区域的布局
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(62);
            make.left.mas_equalTo(27.5);
            make.width.mas_equalTo(kScreenWidth - 55);
            make.height.mas_equalTo(47);
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
        
        //确认密码区域的布局
        [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.passwordView.mas_bottom).offset(14);
            make.left.mas_equalTo(27.5);
            make.width.mas_equalTo(kScreenWidth - 55);
            make.height.mas_equalTo(47);
        }];
        
        [self.surePasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(self.surePasswordView.width - 40 - 35);
            make.height.mas_equalTo(15);
            make.centerY.mas_equalTo(self.surePasswordView);
        }];
        
        [self.surePasswordRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.surePasswordView);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [self.logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.surePasswordView.mas_bottom).offset(14);
            make.left.mas_equalTo(self.titleLabel);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(300);
        }];
        //确认按钮
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.surePasswordView.mas_bottom).offset(107);
            make.left.mas_equalTo(20.5);
//            make.right.mas_equalTo(-20.5);
            make.width.mas_equalTo(kScreenWidth - 41);
            make.height.mas_equalTo(55);
        }];
        
        
    } else {
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.left.mas_equalTo(27.5);
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(300);
        }];
        
        //密码区域的布局
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.left.mas_equalTo(27.5);
            make.width.mas_equalTo(kScreenWidth - 55);
            make.height.mas_equalTo(47);
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
        
        //确认密码区域的布局
        [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.passwordView.mas_bottom).offset(14);
            make.left.mas_equalTo(27.5);
            make.width.mas_equalTo(kScreenWidth - 55);
            make.height.mas_equalTo(47);
        }];
        
        [self.surePasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(self.surePasswordView.width - 40 - 35);
            make.height.mas_equalTo(15);
            make.centerY.mas_equalTo(self.surePasswordView);
        }];
        
        [self.surePasswordRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.surePasswordView);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [self.logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.surePasswordView.mas_bottom).offset(14);
            make.left.mas_equalTo(self.titleLabel);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(300);
        }];
        
        //确认按钮
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logLabel.mas_bottom).offset(14);
            make.left.mas_equalTo(20.5);
//            make.right.mas_equalTo(-20.5);
            make.width.mas_equalTo(kScreenWidth - 41);
            make.height.mas_equalTo(55);
        }];
    }
    
    //用户协议
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(25);
        make.left.mas_equalTo(0);
        //            make.right.mas_equalTo(-20.5);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(15);
    }];
    
    [self.scrollView contentSizeToFit];
}


/** 跳转协议 */
- (void)FHUserAgreementViewClick {
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = @"https://sheyunlife.com/wap/Agreement/index?id=10";
    web.typeString = @"information";
    web.hidesBottomBarWhenPushed = YES;
    web.type = @"noShow";
    [self.navigationController pushViewController:web animated:YES];
}

/** 确认协议 */
- (void)fh_fhuserAgreementWithBtn:(UIButton *)sender {
    if (self.selectCount % 2 == 0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    self.selectCount++;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    // 限制y轴不动
    point.x = 0.f;
    
    scrollView.contentOffset = point;
}


#pragma mark -- events
- (void)onNavRightItemClick {
    //用户点击跳过 就相当于直接登录了
    [self.navigationController popToRootViewControllerAnimated:NO];
//    [RWManager shareManager].isRegister = YES;
    //恭喜注册成功的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REGISTERSUCCESS" object:nil];

}

/**
 输入密码按钮 眼睛的点击事件
 
 @param sender 
 */
- (void)passwordEyesTouchOn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        self.passwordTF.secureTextEntry = NO;
    }else{
        self.passwordTF.secureTextEntry = YES;
    }
}

/**
 确认密码按钮 眼睛的点击事件
 
 @param sender
 */
- (void)surePasswordEyesTouchOn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        self.surePasswordTF.secureTextEntry = NO;
    }else{
        self.surePasswordTF.secureTextEntry = YES;
    }
}

/**
 用户注册设置密码
 */
- (void)sureBtnClick {
    //新用户注册设置密码
    [self.view endEditing:YES];
    if (0 == self.passwordTF.text.length) {
        [self.view makeToast:@"亲，请先输入密码"];
        return;
    }
    if (![self checkPassword:self.passwordTF.text]) {
        [self.view makeToast:@"密码格式不正确"];
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.surePasswordTF.text]) {
        [self.view makeToast:@"两次输入密码不一致"];
        return;
    }
    if (self.selectCount % 2 == 0) {
        [self.view makeToast:@"请同意用户信息授权协议"];
        return;
    }
    if([self.titleString isEqualToString:@"设置密码"]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"password"] = self.surePasswordTF.text;
        params[@"mobile"] = self.phoneNumber;
        params[@"verify_code"] = self.verificCode;
        params[@"BizId"] = self.BizId;
        [AFNetWorkTool post:@"login/register" params:params success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 0) {
                /** 发送失败 */
                [self.view makeToast:responseObj[@"msg"]];
            } else {
                [self.view makeToast:responseObj[@"msg"]];
                /** 用户注册完成后 自动登录 */
                [self personFastLogin];
            }
        } failure:^(NSError *error) {
            
        }];
    } else if ([self.titleString isEqualToString:@"重置密码"]) {
        //用户忘记密码
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.phoneNumber;
        params[@"password"] = self.surePasswordTF.text;
        params[@"verify_code"] = self.verificCode;
        params[@"BizId"] = self.BizId;
        [AFNetWorkTool post:@"login/updatePassword" params:params success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 0) {
                /** 发送失败 */
                [self.view makeToast:responseObj[@"msg"]];
            } else {
                /** 保存用户信息 */
                Account *account = [Account mj_objectWithKeyValues:responseObj[@"data"]];
                [AccountStorage saveAccount:account];
                [self.view makeToast:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
        }];
    }
}

- (void)personFastLogin {
    /** 用户快速登录 */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = self.phoneNumber;
    params[@"password"] = self.passwordTF.text;
    [AFNetWorkTool post:@"login/login" params:params success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            /** 发送失败 */
            [self.view makeToast:responseObj[@"msg"]];
        } else {
            /** 保存用户信息 */
            Account *account = [Account mj_objectWithKeyValues:responseObj[@"data"]];
            [AccountStorage saveAccount:account];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
    }];
}


#pragma mark - ValidateMobile Functions
- (BOOL)checkPassword:(NSString *)passwordNum
{
    NSString *passwordStr = @"[A-Za-z0-9]{6,16}";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStr];
    
    if ([regextestmobile evaluateWithObject:passwordNum]){
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -- 输入框文字判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 200) {
        if(((((int)range.location>=0)&&(![string isEqualToString:@""])) || (((int)range.location>=1)&&[string isEqualToString:@""]))) {
            if (![self.passwordTF.text isEqualToString:@""]) {
                self.sureBtn.userInteractionEnabled = YES;
                self.sureBtn.alpha = 1;
                [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
            }
        } else {
            self.sureBtn.userInteractionEnabled = NO;
            self.sureBtn.alpha = 0.5;
            [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        }
        return YES;
    } else {
        if(((((int)range.location>=0)&&(![string isEqualToString:@""])) || (((int)range.location>=1)&&[string isEqualToString:@""]))) {
            if (![self.surePasswordTF.text isEqualToString:@""]) {
                self.sureBtn.userInteractionEnabled = YES;
                self.sureBtn.alpha = 1;
                [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
            }
        } else {
            self.sureBtn.userInteractionEnabled = NO;
            self.sureBtn.alpha = 0.5;
            [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        }
        return YES;
    }
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
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _titleLabel.text = @"设置你的密码便于直接登录";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[UIView alloc]init];
        _passwordView.layer.cornerRadius = 25;
        _passwordView.backgroundColor = [UIColor whiteColor];
        _passwordView.layer.borderColor = HEX_COLOR(0xC0C0C0).CGColor;
        _passwordView.layer.borderWidth = 0.5;
        _passwordView.clipsToBounds = YES;
    }
    return _passwordView;
}

- (RWTextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [[RWTextField alloc]init];
        _passwordTF.delegate = self;
        _passwordTF.tag = 100;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.textColor = HEX_COLOR(0x333333);
        _passwordTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入您的密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xA6A6A6)}];
    }
    return _passwordTF;
}

- (UIButton *)passwordRightBtn {
    if (!_passwordRightBtn) {
        _passwordRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _passwordRightBtn.selected = NO;
        [_passwordRightBtn setImage:[UIImage imageNamed:@"password_to_login_can_not_see"] forState:UIControlStateNormal];
        [_passwordRightBtn setImage:[UIImage imageNamed:@"password_to_login_see"] forState:UIControlStateSelected];
        [_passwordRightBtn addTarget:self action:@selector(passwordEyesTouchOn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordRightBtn;
}

- (UIView *)surePasswordView {
    if (!_surePasswordView) {
        _surePasswordView = [[UIView alloc]init];
        _surePasswordView.layer.cornerRadius = 25;
        _surePasswordView.backgroundColor = [UIColor whiteColor];
        _surePasswordView.layer.borderColor = HEX_COLOR(0xC0C0C0).CGColor;
        _surePasswordView.layer.borderWidth = 0.5;
        _surePasswordView.clipsToBounds = YES;
    }
    return _surePasswordView;
}

- (RWTextField *)surePasswordTF {
    if (!_surePasswordTF) {
        _surePasswordTF = [[RWTextField alloc]init];
        _surePasswordTF.delegate = self;
        _surePasswordTF.tag = 200;
        _surePasswordTF.secureTextEntry = YES;
        _surePasswordTF.textColor = HEX_COLOR(0x333333);
        _surePasswordTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _surePasswordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xA6A6A6)}];
    }
    return _surePasswordTF;
}

- (UIButton *)surePasswordRightBtn {
    if (!_surePasswordRightBtn) {
        _surePasswordRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _surePasswordRightBtn.selected = NO;
        [_surePasswordRightBtn setImage:[UIImage imageNamed:@"password_to_login_can_not_see"] forState:UIControlStateNormal];
        [_surePasswordRightBtn setImage:[UIImage imageNamed:@"password_to_login_see"] forState:UIControlStateSelected];
        [_surePasswordRightBtn addTarget:self action:@selector(surePasswordEyesTouchOn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surePasswordRightBtn;
}

- (UILabel *)logLabel {
    if (!_logLabel) {
        _logLabel = [[UILabel alloc]init];
        _logLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _logLabel.text = @"6-16位密码、数字或字母";
        _logLabel.textColor = UIColorFromRGB(0x333333);
        _logLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _logLabel;
}

- (UIView *)inviteCodeView {
    if (!_inviteCodeView) {
        _inviteCodeView = [[UIView alloc]init];
        _inviteCodeView.layer.cornerRadius = 25;
        _inviteCodeView.backgroundColor = [UIColor whiteColor];
        _inviteCodeView.layer.borderColor = HEX_COLOR(0xC0C0C0).CGColor;
        _inviteCodeView.layer.borderWidth = 0.5;
        _inviteCodeView.clipsToBounds = YES;
    }
    return _inviteCodeView;
}

- (RWTextField *)inviteCodeTF {
    if (!_inviteCodeTF) {
        _inviteCodeTF = [[RWTextField alloc]init];
        _inviteCodeTF.textColor = HEX_COLOR(0x333333);
        _inviteCodeTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _inviteCodeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邀请码(可不填)" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xA6A6A6)}];
    }
    return _inviteCodeTF;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        _sureBtn.alpha = 0.5;
        [_sureBtn setTitleColor:HEX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _sureBtn.userInteractionEnabled = NO;
    }
    return _sureBtn;
}

- (FHUserAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[FHUserAgreementView alloc] init];
        _agreementView.delegate = self;
    }
    return _agreementView;
}

@end
