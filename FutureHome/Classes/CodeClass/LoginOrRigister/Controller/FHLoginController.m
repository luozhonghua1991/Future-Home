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

@interface FHLoginController () <UITextFieldDelegate>
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

@end

@implementation FHLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}



@end
