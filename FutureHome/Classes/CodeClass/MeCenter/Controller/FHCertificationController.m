//
//  FHCertificationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  实名认证

#import "FHCertificationController.h"
#import "FHUserAgreementView.h"
#import "FHCertificationView.h"
#import "FHCertificationImgView.h"

@interface FHCertificationController () <FHUserAgreementViewDelegate,UITextFieldDelegate,FHCertificationImgViewDelegate>
/** 上面的label提示 */
@property (nonatomic, strong) UILabel *topLabel;
/** 同意协议View */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** 真实姓名 */
@property (nonatomic, strong) FHCertificationView *trueNameView;
/** 身份证件号 */
@property (nonatomic, strong) FHCertificationView *personCodeView;
/** 用来上传图片用的View */
@property (nonatomic, strong) FHCertificationImgView *imgView;
/** 提交按钮 */
@property (nonatomic, strong) UIButton *submitBtn;



@end

@implementation FHCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatUI];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES; self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"实名认证";
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
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fh_creatUI {
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.trueNameView];
    [self.view addSubview:self.personCodeView];
    [self.view addSubview:self.imgView];
    self.imgView.changeTitleLabel.text = @"手持证件合影照/单位营业执照";
    self.imgView.changeTitleLabel.height = 35;
    [self.view addSubview:self.agreementView];
    self.submitBtn.centerX = self.view.width / 2;
    [self.view addSubview:self.submitBtn];
}


#pragma mark — event
- (void)submitBtnClick {
    
}


#pragma mark — delegate
- (void)FHUserAgreementViewClick {
    
}

- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger)index {
    if (index == 1) {
        //左边的图片
    } else if (index == 2) {
        
    } else if (index == 3) {
        
    }
}


#pragma mark — setter && getter
- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainSizeHeight + 3, SCREEN_WIDTH, 35)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor = [UIColor lightGrayColor];
        _topLabel.font = [UIFont systemFontOfSize:11];
        _topLabel.numberOfLines = 0;
        _topLabel.text = @"个人实名认证：个人请上传身份证正面/背面/手持身份证的合影照；\n 单位实名认证：请上传认证负责人身份证正面/反面/单位营业执照，";
    }
    return _topLabel;
}

- (FHCertificationView *)trueNameView {
    if (!_trueNameView) {
        _trueNameView = [[FHCertificationView  alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(self.topLabel.frame) + 10, SCREEN_WIDTH - 6, 60)];
        _trueNameView.contentTF.delegate = self;
        _trueNameView.contentTF.placeholder = @"个人姓名/单位名称";
        _trueNameView.logoLabel.width = 0;
        _trueNameView.contentTF.x = 0;
    }
    return _trueNameView;
}

- (FHCertificationView *)personCodeView {
    if (!_personCodeView) {
        _personCodeView = [[FHCertificationView  alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(self.trueNameView.frame) + 25, SCREEN_WIDTH - 6, 60)];
        _personCodeView.contentTF.delegate = self;
        _personCodeView.contentTF.placeholder = @"身份证件号/信用代码：";
        _personCodeView.logoLabel.width = 0;
        _personCodeView.contentTF.x = 0;
    }
    return _personCodeView;
}

- (FHCertificationImgView *)imgView {
    if (!_imgView) {
        _imgView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.personCodeView.frame) + 100 , SCREEN_WIDTH, 120)];
        _imgView.delegate = self;
    }
    return _imgView;
}

- (FHUserAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[FHUserAgreementView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame) + 120 , SCREEN_WIDTH, 15)];
        _agreementView.delegate = self;
    }
    return _agreementView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
