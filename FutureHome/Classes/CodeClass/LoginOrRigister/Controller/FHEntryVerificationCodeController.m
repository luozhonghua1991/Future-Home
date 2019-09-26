//
//  FHEntryVerificationCodeController.m
//  RWGame
//
//  Created by luozhonghua on 2018/7/18.
//  Copyright © 2018年 chao.liu. All rights reserved.
//  输入验证码界面

#import "FHEntryVerificationCodeController.h"
#import "RWPasswordView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "RWTextField.h"
//#import "LoginService.h"
#import "FHSetPasswordController.h"
//#import "RWResettingPasswordController.h"
//#import "LoginService.h"
//#import "LoginViewController.h"

@interface FHEntryVerificationCodeController ()

/** <#Description#> */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/**标题label*/
@property (nonatomic,strong) UILabel                       *titleLabel;
/**提示label*/
@property (nonatomic,strong) UILabel                       *logLabel;
/**手机号码label*/
@property (nonatomic,strong) UILabel                       *phoneNumLabel;
/**密码输入View*/
@property (nonatomic,strong) RWPasswordView                *passwordView;
/**重新获取验证码的按钮*/
@property (nonatomic,strong) UIButton                      *verCodeButton;
/**确认按钮*/
@property (nonatomic,strong) UIButton                      *sureBtn;
/**密码登录按钮*/
@property (nonatomic,strong) UIButton                      *passwordLoginBtn;
/**验证码*/
@property (nonatomic,copy)   NSString                      *verificCode;
/** 验证码回来的 校验ID */
@property (nonatomic, copy) NSString *BizId;

@end

@implementation FHEntryVerificationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.logLabel];
    [self.scrollView addSubview:self.phoneNumLabel];
    [self.scrollView addSubview:self.passwordView];
    [self.scrollView addSubview:self.sureBtn];
    [self.scrollView addSubview:self.verCodeButton];
    
    if (self.vcType == VERIFICATIONLOGIN_VC) {
        //验证码登录的情况下才有 密码登录按钮
        [self.scrollView addSubview:self.passwordLoginBtn];
    }
    
    self.phoneNumLabel.text = [NSString stringWithFormat:@"+86 %@",self.phoneNumber];
    //发送验证码
    [self sendVerCodeEvent];
    WS(weakSelf);
    self.passwordView.passwordBlock = ^(NSString *password) {
        weakSelf.verificCode = password;
        if (password.length == 6) {
            weakSelf.sureBtn.userInteractionEnabled = YES;
            weakSelf.sureBtn.alpha = 1;
            [weakSelf.sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
        } else {
            weakSelf.sureBtn.userInteractionEnabled = NO;
            weakSelf.sureBtn.alpha = 0.5;
            [weakSelf.sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        }
    };
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
    
    [self.logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(13);
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logLabel.mas_bottom).offset(7.5);
        make.centerX.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(13);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumLabel.mas_bottom).offset(35);
        make.left.mas_equalTo(27.5);
        make.width.mas_equalTo(kScreenWidth - 55);
        make.height.mas_equalTo(30);
    }];
    
    //确认按钮
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumLabel.mas_bottom).offset(110);
        make.left.mas_equalTo(20.5);
//        make.right.mas_equalTo(-20.5);
        make.width.mas_equalTo(kScreenWidth - 41);
        make.height.mas_equalTo(55);
    }];
    
    if (self.vcType == VERIFICATIONLOGIN_VC) {
        //发送验证码按钮
        [self.verCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(25);
            make.left.mas_equalTo(27.5);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(80);
        }];
        //密码登录
        [self.passwordLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(25);
            make.right.mas_equalTo(-27.5);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(48);
        }];
    } else {
        //发送验证码按钮
        [self.verCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(25);
            make.centerX.mas_equalTo(self.scrollView);
            make.height.mas_equalTo(12);
        }];
    }
    
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
 确认按钮 校验验证码是否输入正确
 */
- (void)sureBtnClick {
    [self quickLogin];
}

- (void)quickLogin {
    if (self.vcType == BOUNDPHONE_VC) {
//        //绑定手机号
//        Account *account = [AccountStorage readAccount];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"token"] = account.token;
//        params[@"phone"] = @{@"phone":self.phoneNumber,
//                             @"code":self.verificCode,
//                             @"dialing_code":self.dialing_code
//                             };
//        WS(weakSelf);
//        LoadingBegan;
//        [LoginService loginBoundPhoneParams:params success:^(NSDictionary *respond) {
//             LoadingGIFEnd;
//             [AccountStorage saveAccount:account];
//             [weakSelf dismissViewControllerAnimated:YES completion:nil];
//         } failure:^(NSString *msg) {
//
//             LoadingGIFEnd;
//             [weakSelf.view makeToast:msg];
//         }];
    } else if (self.vcType == REGISTER_VC && self.type == 1) {
        //用户注册的时候 需要设置密码
        FHSetPasswordController *setPassword = [[FHSetPasswordController alloc]init];
        setPassword.titleString = @"设置密码";
        setPassword.phoneNumber = self.phoneNumber;
        setPassword.verificCode = self.verificCode;
        setPassword.BizId = self.BizId;
        [self.navigationController pushViewController:setPassword animated:YES];
//        //新用户注册 快捷登录
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"phone"] = self.phoneNumber;
//        params[@"code"] = self.verificCode;
//        WS(weakSelf);
//        [LoginService loginWithParams:@{@"session":params} success:^(Account *accout) {

//        } failure:^(NSString *msg) {
//            [weakSelf.view makeToast:msg];
//        }];
    } else if (self.vcType == PASSWORD_VC) {
//        Account *account = [AccountStorage readAccount];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"token"] = account.token;
//        params[@"phone"] = @{@"phone":self.phoneNumber,
//                             @"code":self.verificCode,
//                             @"dialing_code":self.dialing_code
//                             };
//        WS(weakSelf);
//        LoadingBegan;
//        [LoginService loginBoundPhoneParams:params success:^(NSDictionary *respond)
//         {
//             LoadingGIFEnd;
//             [AccountStorage saveAccount:account];
//             //重置密码
//             RWResettingPasswordController *resettingPassword = [[RWResettingPasswordController alloc]init];
//             resettingPassword.phoneNumber = weakSelf.phoneNumber;
//             [weakSelf.navigationController pushViewController:resettingPassword animated:YES];
//         } failure:^(NSString *msg) {
//
//             LoadingGIFEnd;
//             [weakSelf.view makeToast:msg];
//         }];
     } else if (self.vcType == THIRDLOGIN_VC){
     } else if(self.vcType == VERIFICATIONLOGIN_VC && self.type == 2) {
         //验证码登录 登录成功回到首页
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         params[@"mobile"] = self.phoneNumber;
         params[@"verify_code"] = self.verificCode;
         params[@"BizId"] = self.BizId;
         WS(weakSelf);
         [AFNetWorkTool post:@"login/codeLogin" params:params success:^(id responseObj) {
             if ([responseObj[@"code"] integerValue] == 0) {
                 /**  */
                 [self.view makeToast:responseObj[@"msg"]];
                 [self.navigationController popViewControllerAnimated:YES];
             } else {
                 /** 保存用户信息 */
                 Account *account = [Account mj_objectWithKeyValues:responseObj[@"data"]];
                 [AccountStorage saveAccount:account];
                 [weakSelf.view makeToast:@"登录成功"];
                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             }
         } failure:^(NSError *error) {
             
         }];
     } else if(self.vcType == FORGETPASSWORD_VC) {
//         //忘记密码 去重置密码
//         //用户注册的时候 需要设置密码
         FHSetPasswordController *setPassword = [[FHSetPasswordController alloc]init];
         setPassword.titleString = @"重置密码";
         setPassword.phoneNumber = self.phoneNumber;
         setPassword.verificCode = self.verificCode;
         setPassword.BizId = self.BizId;
         [self.navigationController pushViewController:setPassword animated:YES];
     }
}

/**
 密码登录
 */
//- (void)passwordLoginClick {
//    //密码登录 回到密码登录页
//    __block LoginViewController *meVC ;
//    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *  obj, NSUInteger idx, BOOL *  stop) {
//        if([obj isKindOfClass:[LoginViewController class]]){
//            meVC = (LoginViewController *)obj;
//        }
//    }];
//    [self.navigationController popToViewController:meVC animated:YES];
//}

/**
 重新发送短信验证码

 @param btn
 */
- (void)sendBtnClick:(UIButton *)btn {
    [self sendVerCodeEvent];
}

/**
 发送验证码
 */
- (void)sendVerCodeEvent {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.phoneNumber;
    params[@"type"] = @(self.type);
    [AFNetWorkTool post:@"login/sendCode" params:params success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            /** 发送失败 */
             [self.view makeToast:responseObj[@"msg"]];
             [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.BizId = responseObj[@"data"];
            [self.view makeToast:@"发送成功"];
            //倒计时
            [self steupCountdown];
        }
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)steupCountdown {
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                NSString *attriStr = @"重新发送";
                [self.verCodeButton setTitle:attriStr forState:UIControlStateNormal];
                [self.verCodeButton setTitleColor:HEX_COLOR(0x4393D9) forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.verCodeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.verCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                [self.verCodeButton setTitleColor:HEX_COLOR(0x999999) forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.verCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
        _titleLabel.text = @"请输入验证码";
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)logLabel {
    if (!_logLabel) {
        _logLabel = [[UILabel alloc]init];
        _logLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _logLabel.text = @"已发送6位数验证码至";
        _logLabel.textColor = UIColorFromRGB(0x999999);
        _logLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _logLabel;
}

- (UILabel *)phoneNumLabel {
    if (!_phoneNumLabel) {
        _phoneNumLabel = [[UILabel alloc]init];
        _phoneNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _phoneNumLabel.textColor = UIColorFromRGB(0x333333);
        _phoneNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneNumLabel;
}

- (RWPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[RWPasswordView alloc]init];
        _passwordView.elementCount = 6;
        _passwordView.elementMargin = 28;
        _passwordView.elementColor = HEX_COLOR(0xd8d8d8);
    }
    return _passwordView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        _sureBtn.alpha = 0.5;
        [_sureBtn setTitleColor:HEX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
    return _sureBtn;
}

- (UIButton *)verCodeButton {
    if (!_verCodeButton) {
        //获取验证码按钮
        _verCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_verCodeButton setTitleColor:HEX_COLOR(0x999999) forState:UIControlStateNormal];
        [_verCodeButton setTitle:@"重新发送(60s)" forState:UIControlStateNormal];
        [_verCodeButton addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _verCodeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _verCodeButton;
}

- (UIButton *)passwordLoginBtn {
    if (!_passwordLoginBtn) {
        //密码登录按钮
        _passwordLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _passwordLoginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_passwordLoginBtn setTitleColor:HEX_COLOR(0x666666) forState:UIControlStateNormal];
        [_passwordLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        [_passwordLoginBtn addTarget:self action:@selector(passwordLoginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordLoginBtn;
}

@end
