//
//  FHAutographController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHAutographController.h"

@interface FHAutographController () <UITextFieldDelegate>
/** 标题提示label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 修改昵称的TF */
@property (nonatomic, strong) UITextField *nameTF;

@end

@implementation FHAutographController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    [self fh_creatUI];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"修改个性签名";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(SCREEN_WIDTH - MainNavgationBarHeight - 5 , MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:finishBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishBtnClick {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               account.nickname,@"nickname",
                               self.nameTF.text,@"autograph",
                               nil];
    [AFNetWorkTool post:@"userCenter/updateNickname" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"修改个性签名成功"];
            account.autograph = self.nameTF.text;
            [AccountStorage saveAccount:account];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)fh_creatUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.nameTF];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)nikeNameTextFiledChangeOnClick:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        _nameTF.placeholder = @"请输入20个字符以内的个性签名";
    }
}

#pragma mark — setter && getter
- (UILabel  *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,MainSizeHeight + 20, SCREEN_WIDTH - 24, 20)];
        _titleLabel.text = @"个性签名支持1-20个字符";
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(12,MainSizeHeight + 70, SCREEN_WIDTH - 24, 40)];
        _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_nameTF addTarget:self action:@selector(nikeNameTextFiledChangeOnClick:) forControlEvents:UIControlEventEditingChanged];
        _nameTF.delegate = self;
        _nameTF.font = [UIFont systemFontOfSize:20];
        _nameTF.text = self.strAutograph;
        _nameTF.backgroundColor = [UIColor lightGrayColor];
    }
    return _nameTF;
}

@end
