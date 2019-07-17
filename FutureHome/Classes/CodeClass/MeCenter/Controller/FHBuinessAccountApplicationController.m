//
//  FHAccountApplicationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商业账户申请的界面

#import "FHBuinessAccountApplicationController.h"
#import "FHAccountApplicationTFView.h"

@interface FHBuinessAccountApplicationController () <UITextFieldDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
/** 账户类型View */
@property (nonatomic, strong) FHAccountApplicationTFView *accountTypeView;
/** 服务平台View */
@property (nonatomic, strong) FHAccountApplicationTFView *serviceDeskView;
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
@property (nonatomic, strong) UIView *detailAddressView;
/** 地址View */
@property (nonatomic, strong) FHAccountApplicationTFView *addressView;

/** 省市区 */
@property (nonatomic, strong) UILabel *leftProvinceLabel;
/** 省市区 */
@property (nonatomic, strong) UILabel *centerProvinceLabel;
/** 省市区 */
@property (nonatomic, strong) UILabel *rightProvinceLabel;

/** 省市区数据 */
@property (nonatomic, strong) UILabel *leftProvinceDataLabel;
/** 省市区数据 */
@property (nonatomic, strong) UILabel *centerProvinceDataLabel;
/** 省市区数据 */
@property (nonatomic, strong) UILabel *rightProvinceDataLabel;

@end

@implementation FHBuinessAccountApplicationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatUI];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"账户申请";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
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
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.accountTypeView];
    [self.scrollView addSubview:self.serviceDeskView];
    [self.scrollView addSubview:self.applicantNameView];
    [self.scrollView addSubview:self.applicantCardView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.addressView];
    /** 申请人身份证 */
    
    /** 建筑物业权属证明 */
    
    /** 确定授权View */
    
    /** 确认并提交按钮 */
    
}


#pragma mark -- layout
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
    
    [self.scrollView contentSizeToFit];
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
        self.detailAddressView = [[UIView alloc] init];
        self.detailAddressView.backgroundColor = [UIColor redColor];
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


#pragma mark - Getters and Setters
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
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
        _serviceDeskView.titleLabel.text = @"物业服务平台名称(限12字)";
        _serviceDeskView.contentTF.text = @"龙湖U城B馆物业服务平台";
        _serviceDeskView.contentTF.enabled = NO;
    }
    return _serviceDeskView;
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
        _phoneView.titleLabel.text = @"联系电话(座机选填)";
        _phoneView.contentTF.delegate = self;
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
    }
    return _addressView;
}

@end
