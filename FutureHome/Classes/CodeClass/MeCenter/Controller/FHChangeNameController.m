//
//  FHChangeNameController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  修改昵称

#import "FHChangeNameController.h"

@interface FHChangeNameController () <UITextFieldDelegate>
/** 标题提示label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 修改昵称的TF */
@property (nonatomic, strong) UITextField *nameTF;

@end

@implementation FHChangeNameController

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
    titleLabel.text = @"修改昵称";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
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
    [self.navigationController popViewControllerAnimated:YES];
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
        _nameTF.placeholder = @"请输入10个字符以内的新昵称";
    }
}

#pragma mark — setter && getter
- (UILabel  *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,MainSizeHeight + 20, SCREEN_WIDTH - 24, 20)];
        _titleLabel.text = @"昵称支持1-10个字符";
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
        _nameTF.text = self.strNikeName;
        _nameTF.backgroundColor = [UIColor lightGrayColor];
    }
    return _nameTF;
}

@end
