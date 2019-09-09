//
//  FHAccountApplicationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商业账户申请的界面

#import "FHBuinessAccountApplicationController.h"
#import "FHAccountApplicationTFView.h"
#import "FHPersonCodeView.h"
#import "FHCertificationImgView.h"
#import "FHUserAgreementView.h"
#import "FHDetailAddressView.h"
#import "FHProofOfOwnershipView.h"

@interface FHBuinessAccountApplicationController () <UITextFieldDelegate,UIScrollViewDelegate,FHCertificationImgViewDelegate,FHUserAgreementViewDelegate>
/** 大的滚动视图 */
//@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 账户类型View */
@property (nonatomic, strong) FHAccountApplicationTFView *accountTypeView;
/** 服务平台View */
@property (nonatomic, strong) FHAccountApplicationTFView *serviceDeskView;
/** 服务平台TF */
@property (nonatomic, strong) UITextField *serviceDeskNameTF;
/** 申请人姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantNameView;
/** 申请人身份证View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantCardView;
/** 联系人手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneView;
/** 接收邮箱 */
@property (nonatomic, strong) FHAccountApplicationTFView *mailView;
/** 详情地址选择View */
@property (nonatomic, strong) FHDetailAddressView *detailAddressView;
/** 地址View */
@property (nonatomic, strong) FHAccountApplicationTFView *addressView;
/** 申请人身份证 */
@property (nonatomic, strong) FHPersonCodeView *personCodeView;
/** 身份证图标 */
@property (nonatomic, strong) FHCertificationImgView *certificationView;
/** 权属说明View */
@property (nonatomic, strong) FHProofOfOwnershipView *shipView;
/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 同意协议 *//** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** 用户协议 */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** 确认并提交 */
@property (nonatomic, strong) UIButton *submitBtn;


@end

@implementation FHBuinessAccountApplicationController

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
    titleLabel.text = @"商业物业账户申请";
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
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
    
    [self.scrollView addSubview:self.accountTypeView];
    [self.scrollView addSubview:self.serviceDeskView];
    [self.serviceDeskView addSubview:self.serviceDeskNameTF];
    
    [self.scrollView addSubview:self.applicantNameView];
    [self.scrollView addSubview:self.applicantCardView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.addressView];
    /** 申请人身份证 */
    self.certificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 100)];
    self.certificationView.delegate = self;
    [self.personCodeView addSubview:self.certificationView];
    [self.scrollView addSubview:self.personCodeView];
    /** 建筑物业权属证明 */
    [self.scrollView addSubview:self.shipView];
    [self.scrollView addSubview:self.logoLabel];
    [self.scrollView addSubview:self.bottomLineView];
    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
    /** 确认并提交按钮 */
    [self.scrollView addSubview:self.submitBtn];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.accountTypeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.serviceDeskView.frame = CGRectMake(0, CGRectGetMaxY(self.accountTypeView.frame), SCREEN_WIDTH, 50);
    self.serviceDeskNameTF.frame = CGRectMake(SCREEN_WIDTH - 270, 20, 260, 20);
    self.applicantNameView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceDeskView.frame), SCREEN_WIDTH, 50);
    self.applicantCardView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantNameView.frame), SCREEN_WIDTH, 50);
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantCardView.frame), SCREEN_WIDTH, 50);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneNumberView.frame), SCREEN_WIDTH, 50);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, 50);
    self.detailAddressView.frame = CGRectMake(0, CGRectGetMaxY(self.mailView.frame), SCREEN_WIDTH, 50);
    self.addressView.frame =  CGRectMake(0, CGRectGetMaxY(self.detailAddressView.frame), SCREEN_WIDTH, 50);
    self.personCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame), SCREEN_WIDTH, 180);
    self.shipView.frame = CGRectMake(0, CGRectGetMaxY(self.personCodeView.frame), SCREEN_WIDTH, 60);
    [self updateViewsFrame];
}

/*
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0 ));
    }];
    
    [self.accountTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.serviceDeskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountTypeView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.serviceDeskNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(SCREEN_WIDTH - 270);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(20);
    }];
    
    [self.applicantNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.serviceDeskView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.applicantCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.applicantNameView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.phoneNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.applicantCardView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumberView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.mailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.detailAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mailView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailAddressView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    
    [self.personCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(180);
    }];
    
    [self.shipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personCodeView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(138);
    }];
    
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shipView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(15);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.agreementView.mas_bottom).offset(120);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(55);
    }];
}
 */

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

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    [self updatePickerViewFrameY:CGRectGetMaxY(self.shipView.frame)];
    self.logoLabel.frame = CGRectMake(15, (CGRectGetMaxY(self.shipView.frame) + [self getPickerViewFrame].size.height), SCREEN_WIDTH, 12);
    self.bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(self.logoLabel.frame) + 2.5, SCREEN_WIDTH, 0.5);
    self.agreementView.frame = CGRectMake(0, (CGRectGetMaxY(self.shipView.frame) + [self getPickerViewFrame].size.height) + 100, SCREEN_WIDTH, 15);
    self.submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
    self.submitBtn.centerX = self.view.width / 2;
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + MainSizeHeight + 20);
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
        _accountTypeView.contentTF.text = @"商业物业服务平台账号";
        _accountTypeView.contentTF.enabled = NO;
    }
    return _accountTypeView;
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

- (FHAccountApplicationTFView *)applicantNameView {
    if (!_applicantNameView) {
        _applicantNameView = [[FHAccountApplicationTFView alloc] init];
        _applicantNameView.titleLabel.text = @"申请人姓名";
        _applicantNameView.contentTF.delegate = self;
    }
    return _applicantNameView;
}

- (FHAccountApplicationTFView *)applicantCardView {
    if (!_applicantCardView) {
        _applicantCardView = [[FHAccountApplicationTFView alloc] init];
        _applicantCardView.titleLabel.text = @"申请人身份证";
        _applicantCardView.contentTF.delegate = self;
    }
    return _applicantCardView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"联系电话(手机)";
        _phoneNumberView.contentTF.delegate = self;
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"联系电话";
        _phoneView.contentTF.delegate = self;
        _phoneView.contentTF.placeholder = @"(座机选填)";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)mailView {
    if (!_mailView) {
        _mailView = [[FHAccountApplicationTFView alloc] init];
        _mailView.titleLabel.text = @"账号接收邮箱";
        _mailView.contentTF.delegate = self;
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

- (FHPersonCodeView *)personCodeView {
    if (!_personCodeView) {
        _personCodeView = [[FHPersonCodeView alloc] init];
        _personCodeView.titleLabel.text = @"申请人身份证";
    }
    return _personCodeView;
}

- (FHProofOfOwnershipView *)shipView {
    if (!_shipView) {
        _shipView = [[FHProofOfOwnershipView alloc] init];
        NSString *titleString = @"建筑物业权属证明(能够证明建筑物业的合同房产证等⽂文件拍照上传)";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:8 legth:24]];
        _shipView.titleLabel.attributedText = attributedTitle;
    }
    return _shipView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.textColor = [UIColor lightGrayColor];
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:12];
        _logoLabel.text = @"权属证件信息可上传9张";
    }
    return _logoLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
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
