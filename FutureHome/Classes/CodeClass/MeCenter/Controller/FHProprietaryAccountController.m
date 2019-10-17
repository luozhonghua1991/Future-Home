//
//  FHProprietaryAccountController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  业主账户界面

#import "FHProprietaryAccountController.h"
#import "FHAccountApplicationTFView.h"
#import "FHPersonCodeView.h"
#import "FHCertificationImgView.h"
#import "FHUserAgreementView.h"
#import "FHDetailAddressView.h"
#import "FHProofOfOwnershipView.h"

@interface FHProprietaryAccountController () <UITextFieldDelegate,UIScrollViewDelegate,FHCertificationImgViewDelegate,FHUserAgreementViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 账户类型View */
@property (nonatomic, strong) FHAccountApplicationTFView *accountTypeView;
/** 基本信息蓝色btn */
@property (nonatomic, strong) UIButton *normalBlueBtn;
/** 社区服务平台View */
@property (nonatomic, strong) FHAccountApplicationTFView *personServiceDeskView;
/** 服务平台View */
@property (nonatomic, strong) FHAccountApplicationTFView *serviceDeskView;
/** 服务平台TF */
@property (nonatomic, strong) UITextField *serviceDeskNameTF;

///** 申请人姓名View */
//@property (nonatomic, strong) FHAccountApplicationTFView *applicantNameView;
///** 申请人身份证View */
//@property (nonatomic, strong) FHAccountApplicationTFView *applicantCardView;
///** 联系人手机号View */
//@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 详情地址选择View */
@property (nonatomic, strong) FHDetailAddressView *detailAddressView;
/** 地址View */
@property (nonatomic, strong) FHAccountApplicationTFView *addressView;
/** 手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneView;
/** 接收邮箱 */
@property (nonatomic, strong) FHAccountApplicationTFView *mailView;

/** 最上面的绿色btn */
@property (nonatomic, strong) UIButton *topGreenBtn;
/** 业主1姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *person1NameView;
/** 业主1身份证 */
@property (nonatomic, strong) FHAccountApplicationTFView *person1CodeView;
/** 业主1电话 */
@property (nonatomic, strong) FHAccountApplicationTFView *person1PhoneView;
/** 业主1房号 */
@property (nonatomic, strong) FHAccountApplicationTFView *person1HourseNumberView;
/** 业主1申请人身份证 */
@property (nonatomic, strong) FHPersonCodeView *person1ApplicationCodeView;
/** 业主1身份证图标 */
@property (nonatomic, strong) FHCertificationImgView *person1CertificationView;

/** 中间的绿色btn */
@property (nonatomic, strong) UIButton *centerGreenBtn;
/** 业主2姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *person2NameView;
/** 业主2身份证 */
@property (nonatomic, strong) FHAccountApplicationTFView *person2CodeView;
/** 业主2电话 */
@property (nonatomic, strong) FHAccountApplicationTFView *person2PhoneView;
/** 业主2房号 */
@property (nonatomic, strong) FHAccountApplicationTFView *person2HourseNumberView;
/** 业主2申请人身份证 */
@property (nonatomic, strong) FHPersonCodeView *person2ApplicationCodeView;
/** 业主2身份证图标 */
@property (nonatomic, strong) FHCertificationImgView *person2CertificationView;

/** 下面的绿色btn */
@property (nonatomic, strong) UIButton *bottomGreenBtn;
/** 业主3姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *person3NameView;
/** 业主3身份证 */
@property (nonatomic, strong) FHAccountApplicationTFView *person3CodeView;
/** 业主3电话 */
@property (nonatomic, strong) FHAccountApplicationTFView *person3PhoneView;
/** 业主3房号 */
@property (nonatomic, strong) FHAccountApplicationTFView *person3HourseNumberView;
/** 业主3申请人身份证 */
@property (nonatomic, strong) FHPersonCodeView *person3ApplicationCodeView;
/** 业主3哎身份证图标 */
@property (nonatomic, strong) FHCertificationImgView *person3CertificationView;

/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 同意协议 *//** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** 用户协议 */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** 确认并提交 */
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation FHProprietaryAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"业主账户申请";
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
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.accountTypeView];
    [self.scrollView addSubview:self.normalBlueBtn];
    
    [self.scrollView addSubview:self.personServiceDeskView];
    [self.scrollView addSubview:self.serviceDeskView];
    [self.serviceDeskView addSubview:self.serviceDeskNameTF];
    
//    [self.scrollView addSubview:self.applicantNameView];
//    [self.scrollView addSubview:self.applicantCardView];
//    [self.scrollView addSubview:self.phoneNumberView];
    
    [self fh_creatDetailAddressView];
    
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    
    [self.scrollView addSubview:self.topGreenBtn];
    [self.scrollView addSubview:self.person1NameView];
    [self.scrollView addSubview:self.person1CodeView];
    [self.scrollView addSubview:self.person1PhoneView];
    [self.scrollView addSubview:self.person1HourseNumberView];
    /** 业主1申请人身份证 */
    self.person1CertificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 100)];
    self.person1CertificationView.delegate = self;
    [self.person1ApplicationCodeView addSubview:self.person1CertificationView];
    [self.scrollView addSubview:self.person1ApplicationCodeView];
    
    [self.scrollView addSubview:self.centerGreenBtn];
    [self.scrollView addSubview:self.person2NameView];
    [self.scrollView addSubview:self.person2CodeView];
    [self.scrollView addSubview:self.person2PhoneView];
    [self.scrollView addSubview:self.person2HourseNumberView];
    /** 业主2申请人身份证 */
    self.person2CertificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 100)];
    self.person2CertificationView.delegate = self;
    [self.person2ApplicationCodeView addSubview:self.person2CertificationView];
    [self.scrollView addSubview:self.person2ApplicationCodeView];
    
    [self.scrollView addSubview:self.bottomGreenBtn];
    [self.scrollView addSubview:self.person3NameView];
    [self.scrollView addSubview:self.person3CodeView];
    [self.scrollView addSubview:self.person3PhoneView];
    [self.scrollView addSubview:self.person3HourseNumberView];
    /** 业主3申请人身份证 */
    self.person3CertificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 100)];
    self.person3CertificationView.delegate = self;
    [self.person3ApplicationCodeView addSubview:self.person3CertificationView];
    [self.scrollView addSubview:self.person3ApplicationCodeView];
//    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
//    /** 确认并提交按钮 */
    [self.scrollView addSubview:self.submitBtn];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.accountTypeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.normalBlueBtn.frame = CGRectMake(0, CGRectGetMaxY(self.accountTypeView.frame) + 20, SCREEN_WIDTH, commonCellHeight - 5);
    self.personServiceDeskView.frame = CGRectMake(0, CGRectGetMaxY(self.normalBlueBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.serviceDeskView.frame = CGRectMake(0, CGRectGetMaxY(self.personServiceDeskView.frame), SCREEN_WIDTH, commonCellHeight);
    self.serviceDeskNameTF.frame = CGRectMake(SCREEN_WIDTH - 270, 20, 260, 20);
    self.detailAddressView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceDeskView.frame), SCREEN_WIDTH, commonCellHeight);
    self.addressView.frame =  CGRectMake(0, CGRectGetMaxY(self.detailAddressView.frame), SCREEN_WIDTH, commonCellHeight);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame), SCREEN_WIDTH, commonCellHeight);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, commonCellHeight);
    
    self.topGreenBtn.frame = CGRectMake(0, CGRectGetMaxY(self.mailView.frame) + 20, SCREEN_WIDTH, commonCellHeight - 5);
    self.person1NameView.frame = CGRectMake(0, CGRectGetMaxY(self.topGreenBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1CodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person1NameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1PhoneView.frame = CGRectMake(0, CGRectGetMaxY(self.person1CodeView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1HourseNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.person1PhoneView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1ApplicationCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person1HourseNumberView.frame), SCREEN_WIDTH, 180);
    
    self.centerGreenBtn.frame = CGRectMake(0, CGRectGetMaxY(self.person1ApplicationCodeView.frame) + 30, SCREEN_WIDTH, commonCellHeight - 5);
    self.person2NameView.frame = CGRectMake(0, CGRectGetMaxY(self.centerGreenBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2CodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person2NameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2PhoneView.frame = CGRectMake(0, CGRectGetMaxY(self.person2CodeView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2HourseNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.person2PhoneView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2ApplicationCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person2HourseNumberView.frame), SCREEN_WIDTH, 180);
    
    self.bottomGreenBtn.frame = CGRectMake(0, CGRectGetMaxY(self.person2ApplicationCodeView.frame) + 30, SCREEN_WIDTH, commonCellHeight - 5);
    self.person3NameView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomGreenBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3CodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person3NameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3PhoneView.frame = CGRectMake(0, CGRectGetMaxY(self.person3CodeView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3HourseNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.person3PhoneView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3ApplicationCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person3HourseNumberView.frame), SCREEN_WIDTH, 180);
    
    self.agreementView.frame = CGRectMake(0, CGRectGetMaxY(self.person3ApplicationCodeView.frame) + 30, SCREEN_WIDTH, 15);
    self.submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
    self.submitBtn.centerX = self.view.width / 2;
     self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + MainSizeHeight + 20);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    scrollView.contentOffset = point;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)fh_creatDetailAddressView {
    if (!self.detailAddressView) {
        self.detailAddressView = [[FHDetailAddressView alloc] init];
        self.view.userInteractionEnabled = YES;
        self.scrollView.userInteractionEnabled = YES;
        self.detailAddressView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick)];
        [self.detailAddressView addGestureRecognizer:tap];
        [self.scrollView addSubview:self.detailAddressView];
    }
}


#pragma mark — event
/** 地址选择 */
- (void)addressClick {
    
}

- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger )index {
    
}

- (void)submitBtnClick {
    /** 确认并提交 */
    
}


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)accountTypeView {
    if (!_accountTypeView) {
        _accountTypeView = [[FHAccountApplicationTFView alloc] init];
        _accountTypeView.titleLabel.text = @"账号类型";
        _accountTypeView.contentTF.text = @"业委服务/物业服务平台联合申请";
        _accountTypeView.contentTF.enabled = NO;
    }
    return _accountTypeView;
}

- (UIButton *)normalBlueBtn {
    if (!_normalBlueBtn) {
        _normalBlueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_normalBlueBtn setTitle:@"服务平台基本信息" forState:UIControlStateNormal];
        _normalBlueBtn.userInteractionEnabled = NO;
        _normalBlueBtn.backgroundColor = HEX_COLOR(0x1296db);
    }
    return _normalBlueBtn;
}

- (FHAccountApplicationTFView *)personServiceDeskView {
    if (!_personServiceDeskView) {
        _personServiceDeskView = [[FHAccountApplicationTFView alloc] init];
        _personServiceDeskView.titleLabel.text = @"社区服务平台名称";
        _personServiceDeskView.contentTF.text = @"恒大未来城物业服务平台";
        _personServiceDeskView.contentTF.placeholder = @"(限12字)";
    }
    return _personServiceDeskView;
}

- (FHAccountApplicationTFView *)serviceDeskView {
    if (!_serviceDeskView) {
        _serviceDeskView = [[FHAccountApplicationTFView alloc] init];
        _serviceDeskView.titleLabel.text = @"物业服务平台名称";
        [_serviceDeskView.contentTF removeFromSuperview];
    }
    return _serviceDeskView;
}

- (UITextField *)serviceDeskNameTF{
    if (!_serviceDeskNameTF) {
        _serviceDeskNameTF = [[UITextField alloc] init];
        _serviceDeskNameTF.textAlignment = NSTextAlignmentRight;
        _serviceDeskNameTF.font = [UIFont systemFontOfSize:15];
        _serviceDeskNameTF.text = @"龙湖U城B馆物业服务平台";
        _serviceDeskNameTF.placeholder = @"(限12字)";
    }
    return _serviceDeskNameTF;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"主要联系电话";
        _phoneView.contentTF.delegate = self;
        _phoneView.contentTF.placeholder = @"(手机)";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)mailView {
    if (!_mailView) {
        _mailView = [[FHAccountApplicationTFView alloc] init];
        _mailView.titleLabel.text = @"账号接收邮箱";
        _mailView.contentTF.delegate = self;
        _mailView.contentTF.placeholder = @"非常重要用于接收账号登录信息";
    }
    return _mailView;
}

- (FHAccountApplicationTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHAccountApplicationTFView alloc] init];
        _addressView.titleLabel.text = @"街道地址";
        _addressView.contentTF.delegate = self;
        _addressView.contentTF.placeholder = @"(准确到门牌号)";
    }
    return _addressView;
}

- (UIButton *)topGreenBtn {
    if (!_topGreenBtn) {
        _topGreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topGreenBtn setTitle:@"主要申请业主基本信息" forState:UIControlStateNormal];
        _topGreenBtn.userInteractionEnabled = NO;
        _topGreenBtn.backgroundColor = ZH_COLOR(124, 202, 155);
    }
    return _topGreenBtn;
}

- (UIButton *)centerGreenBtn {
    if (!_centerGreenBtn) {
        _centerGreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerGreenBtn setTitle:@"联名申请业主2基本信息" forState:UIControlStateNormal];
        _centerGreenBtn.userInteractionEnabled = NO;
        _centerGreenBtn.backgroundColor = ZH_COLOR(124, 202, 155);
    }
    return _centerGreenBtn;
}

- (UIButton *)bottomGreenBtn {
    if (!_bottomGreenBtn) {
        _bottomGreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomGreenBtn setTitle:@"联名申请业主3基本信息" forState:UIControlStateNormal];
        _bottomGreenBtn.userInteractionEnabled = NO;
        _bottomGreenBtn.backgroundColor = ZH_COLOR(124, 202, 155);
    }
    return _bottomGreenBtn;
}

- (FHAccountApplicationTFView *)person1NameView {
    if (!_person1NameView) {
        _person1NameView = [[FHAccountApplicationTFView alloc] init];
        _person1NameView.titleLabel.text = @"业主1姓名";
        _person1NameView.contentTF.delegate = self;
    }
    return _person1NameView;
}

- (FHAccountApplicationTFView *)person1CodeView {
    if (!_person1CodeView) {
        _person1CodeView = [[FHAccountApplicationTFView alloc] init];
        _person1CodeView.titleLabel.text = @"业主1身份证";
        _person1CodeView.contentTF.delegate = self;
    }
    return _person1CodeView;
}

- (FHAccountApplicationTFView *)person1PhoneView {
    if (!_person1PhoneView) {
        _person1PhoneView = [[FHAccountApplicationTFView alloc] init];
        _person1PhoneView.titleLabel.text = @"业主1联系电话";
        _person1PhoneView.contentTF.delegate = self;
        _person1PhoneView.contentTF.placeholder = @"(电话)";
        
    }
    return _person1PhoneView;
}

- (FHAccountApplicationTFView *)person1HourseNumberView {
    if (!_person1HourseNumberView) {
        _person1HourseNumberView = [[FHAccountApplicationTFView alloc] init];
        _person1HourseNumberView.titleLabel.text = @"业主1房号";
        _person1HourseNumberView.contentTF.delegate = self;
        _person1HourseNumberView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _person1HourseNumberView;
}

- (FHPersonCodeView *)person1ApplicationCodeView {
    if (!_person1ApplicationCodeView) {
        _person1ApplicationCodeView = [[FHPersonCodeView alloc] init];
        _person1ApplicationCodeView.titleLabel.text = @"业主1申请人身份证";
    }
    return _person1ApplicationCodeView;
}

- (FHAccountApplicationTFView *)person2NameView {
    if (!_person2NameView) {
        _person2NameView = [[FHAccountApplicationTFView alloc] init];
        _person2NameView.titleLabel.text = @"业主2姓名";
        _person2NameView.contentTF.delegate = self;
    }
    return _person2NameView;
}

- (FHAccountApplicationTFView *)person2CodeView {
    if (!_person2CodeView) {
        _person2CodeView = [[FHAccountApplicationTFView alloc] init];
        _person2CodeView.titleLabel.text = @"业主2身份证";
        _person2CodeView.contentTF.delegate = self;
    }
    return _person2CodeView;
}

- (FHAccountApplicationTFView *)person2PhoneView {
    if (!_person2PhoneView) {
        _person2PhoneView = [[FHAccountApplicationTFView alloc] init];
        _person2PhoneView.titleLabel.text = @"业主2联系电话";
        _person2PhoneView.contentTF.delegate = self;
        _person2PhoneView.contentTF.placeholder = @"(电话)";
        
    }
    return _person2PhoneView;
}

- (FHAccountApplicationTFView *)person2HourseNumberView {
    if (!_person2HourseNumberView) {
        _person2HourseNumberView = [[FHAccountApplicationTFView alloc] init];
        _person2HourseNumberView.titleLabel.text = @"业主2房号";
        _person2HourseNumberView.contentTF.delegate = self;
        _person2HourseNumberView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _person2HourseNumberView;
}

- (FHPersonCodeView *)person2ApplicationCodeView {
    if (!_person2ApplicationCodeView) {
        _person2ApplicationCodeView = [[FHPersonCodeView alloc] init];
        _person2ApplicationCodeView.titleLabel.text = @"业主2申请人身份证";
    }
    return _person2ApplicationCodeView;
}

- (FHAccountApplicationTFView *)person3NameView {
    if (!_person3NameView) {
        _person3NameView = [[FHAccountApplicationTFView alloc] init];
        _person3NameView.titleLabel.text = @"业主3姓名";
        _person3NameView.contentTF.delegate = self;
    }
    return _person3NameView;
}

- (FHAccountApplicationTFView *)person3CodeView {
    if (!_person3CodeView) {
        _person3CodeView = [[FHAccountApplicationTFView alloc] init];
        _person3CodeView.titleLabel.text = @"业主3身份证";
        _person3CodeView.contentTF.delegate = self;
    }
    return _person3CodeView;
}

- (FHAccountApplicationTFView *)person3PhoneView {
    if (!_person3PhoneView) {
        _person3PhoneView = [[FHAccountApplicationTFView alloc] init];
        _person3PhoneView.titleLabel.text = @"业主3联系电话";
        _person3PhoneView.contentTF.delegate = self;
        _person3PhoneView.contentTF.placeholder = @"(电话)";
        
    }
    return _person3PhoneView;
}

- (FHAccountApplicationTFView *)person3HourseNumberView {
    if (!_person3HourseNumberView) {
        _person3HourseNumberView = [[FHAccountApplicationTFView alloc] init];
        _person3HourseNumberView.titleLabel.text = @"业主3房号";
        _person3HourseNumberView.contentTF.delegate = self;
        _person3HourseNumberView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _person3HourseNumberView;
}

- (FHPersonCodeView *)person3ApplicationCodeView {
    if (!_person3ApplicationCodeView) {
        _person3ApplicationCodeView = [[FHPersonCodeView alloc] init];
        _person3ApplicationCodeView.titleLabel.text = @"业主3申请人身份证";
    }
    return _person3ApplicationCodeView;
}

- (FHUserAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[FHUserAgreementView alloc] init];
        _agreementView.delegate = self;
    }
    return _agreementView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}



@end
