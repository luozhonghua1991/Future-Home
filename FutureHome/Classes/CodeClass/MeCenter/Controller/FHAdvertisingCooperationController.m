//
//  FHAdvertisingCooperationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/5.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  广告合作界面

#import "FHAdvertisingCooperationController.h"
#import "FHBuinessAccountApplicationController.h"
#import "FHAccountApplicationTFView.h"
#import "FHPersonCodeView.h"
#import "FHCertificationImgView.h"
#import "FHUserAgreementView.h"
#import "FHDetailAddressView.h"
#import "FHProofOfOwnershipView.h"
#import "NSArray+JSON.h"
#import "FHAddressPickerView.h"
#import "FHCommonPaySelectView.h"
#import "FHAppDelegate.h"
#import "FHWebViewController.h"
#import "LeoPayManager.h"

@interface FHAdvertisingCooperationController ()
<UITextFieldDelegate,
UIScrollViewDelegate,
FHUserAgreementViewDelegate,
FHCommonPaySelectViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 单位名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantNameView;
/** 单位区域详情地址选择View */
@property (nonatomic, strong) FHDetailAddressView *detailAddressView;
/** 地址View */
@property (nonatomic, strong) FHAccountApplicationTFView *addressView;
/** 联系人姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *personNameView;
/** 联系人身份证View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantCardView;
/** 联系人手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneView;
/** 接收邮箱 */
@property (nonatomic, strong) FHAccountApplicationTFView *mailView;
/** 广告类型 */
@property (nonatomic, strong) FHAccountApplicationTFView *adverTypeView;
/** 投放时间 */
@property (nonatomic, strong) FHAccountApplicationTFView *showDayView;
/** 投放时长 */
@property (nonatomic, strong) FHAccountApplicationTFView *showTimeView;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *selectWhereView;
/** 投放说明 */
@property (nonatomic, strong) FHAccountApplicationTFView *showLogView;
/** 投放区域 */
@property (nonatomic, strong) FHAccountApplicationTFView *showWhereView;
/** 投放账号 */
@property (nonatomic, strong) FHAccountApplicationTFView *showNumberView;
/** 省的ID */
@property (nonatomic, copy) NSString *province_id;
/** 市的ID */
@property (nonatomic, copy) NSString *city_id;
/** 区的ID */
@property (nonatomic, copy) NSString *area_id;
/** 选择的是第几个 */
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) FHAddressPickerView *addressPickerView;

/** 用户协议 */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** 确认并提交 */
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation FHAdvertisingCooperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    [self creatAleat];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"广告合作";
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


- (void)creatAleat {
    NSArray *buttonTitleColorArray = @[[UIColor blackColor], [UIColor blueColor]] ;
    
    [UIAlertController ba_alertShowInViewController:self
                                              title:@"温馨提示"
                                            message:@"提示正文(没有支付功能)"
                                   buttonTitleArray:@[@"取 消", @"确 定"]
                              buttonTitleColorArray:buttonTitleColorArray
                                              block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0) {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                                  
                                              }];
}


- (void)fh_creatUI {
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.applicantNameView];
    
    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.personNameView];
    [self.scrollView addSubview:self.applicantCardView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    [self.scrollView addSubview:self.adverTypeView];
    [self.scrollView addSubview:self.showDayView];
    [self.scrollView addSubview:self.showTimeView];
    [self.scrollView addSubview:self.selectWhereView];
    [self.scrollView addSubview:self.showLogView];
    [self.scrollView addSubview:self.showWhereView];
    [self.scrollView addSubview:self.showNumberView];
    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
    /** 确认并提交按钮 */
    [self.scrollView addSubview:self.submitBtn];
    
    @weakify(self)
    //调用方法(核心)根据后面的枚举,传入不同的枚举,展示不同的模式
    _addressPickerView = [[FHAddressPickerView alloc] initWithkAddressPickerViewModel:kAddressPickerViewModelAll];
    //默认为NO
    //_addressPickerView.showLastSelect = YES;
    _addressPickerView.cancelBtnBlock = ^() {
        @strongify(self)
        //移除掉地址选择器
        [self.addressPickerView hiddenInView];
    };
    _addressPickerView.sureBtnBlock = ^(NSString *province,
                                        NSString *city,
                                        NSString *district,
                                        NSString *addressCode,
                                        NSString *parentCode,
                                        NSString *provienceCode) {
        //返回过来的信息在后面的这四个参数中,使用的时候要做非空判断,(province和addressCode为必返回参数,可以不做非空判断)
        @strongify(self)
        NSString *showString;
        if (city != nil) {
            showString = [NSString stringWithFormat:@"%@",city];
        }else{
            showString = province;
        }
        
        if (district != nil) {
            showString = [NSString stringWithFormat:@"%@%@", showString, district];
        }
        
        self.detailAddressView.leftProvinceDataLabel.text = province;
        self.detailAddressView.centerProvinceDataLabel.text = city;
        self.detailAddressView.rightProvinceDataLabel.text = district;
        self.province_id = provienceCode;
        self.city_id = parentCode;
        self.area_id = addressCode;
        //移除掉地址选择器
        [self.addressPickerView hiddenInView];
        
    };
}

- (void)fh_layoutSubViews {
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.applicantNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.detailAddressView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantNameView.frame), SCREEN_WIDTH, 50);
    self.addressView.frame =  CGRectMake(0, CGRectGetMaxY(self.detailAddressView.frame), SCREEN_WIDTH, 50);
    self.personNameView.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame), SCREEN_WIDTH, 50);
    self.applicantCardView.frame = CGRectMake(0, CGRectGetMaxY(self.personNameView.frame), SCREEN_WIDTH, 50);
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantCardView.frame), SCREEN_WIDTH, 50);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneNumberView.frame), SCREEN_WIDTH, 50);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, 50);
    self.adverTypeView.frame = CGRectMake(0, CGRectGetMaxY(self.mailView.frame), SCREEN_WIDTH, 50);
    self.showDayView.frame = CGRectMake(0, CGRectGetMaxY(self.adverTypeView.frame), SCREEN_WIDTH, 50);
    self.showTimeView.frame = CGRectMake(0, CGRectGetMaxY(self.showDayView.frame), SCREEN_WIDTH, 50);
    self.selectWhereView.frame = CGRectMake(0, CGRectGetMaxY(self.showTimeView.frame), SCREEN_WIDTH, 200);
    self.showLogView.frame = CGRectMake(0, CGRectGetMaxY(self.selectWhereView.frame), SCREEN_WIDTH, 50);
    
    self.showWhereView.frame = CGRectMake(0, CGRectGetMaxY(self.showLogView.frame), SCREEN_WIDTH, 50);
    self.showNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.showWhereView.frame), SCREEN_WIDTH, 50);
    self.agreementView.frame = CGRectMake(0, CGRectGetMaxY(self.showNumberView.frame) + 100, SCREEN_WIDTH, 15);
    self.submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
    self.submitBtn.centerX = self.view.width / 2;
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + MainSizeHeight + 20);
    
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
    [self.addressPickerView showInView:self.view];
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

- (void)submitBtnClick {
    /** 确认并提交 */
    //    if (self.selectIDCardsImgArrs.count != 3) {
    //        [self.view makeToast:@"身份证信息认证不能为空"];
    //        return;
    //    }
//    if (self.selectCount % 2 == 0) {
//        [self.view makeToast:@"请同意用户信息授权协议"];
//        return;
//    }
    
    /** 先加一个弹框提示 */
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
//            [weakSelf payView];
            weakSelf.submitBtn.userInteractionEnabled = NO;
//            [weakSelf showPayView];
        }
    }];
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)applicantNameView {
    if (!_applicantNameView) {
        _applicantNameView = [[FHAccountApplicationTFView alloc] init];
        _applicantNameView.titleLabel.text = @"单位名称";
        _applicantNameView.contentTF.delegate = self;
        _applicantNameView.contentTF.placeholder = @"请输入单位名称";
    }
    return _applicantNameView;
}

- (FHAccountApplicationTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHAccountApplicationTFView alloc] init];
        _addressView.titleLabel.text = @"具体地址";
        _addressView.contentTF.delegate = self;
        _addressView.contentTF.placeholder = @"请输入单位信息地址";
    }
    return _addressView;
}

- (FHAccountApplicationTFView *)personNameView {
    if (!_personNameView) {
        _personNameView = [[FHAccountApplicationTFView alloc] init];
        _personNameView.titleLabel.text = @"联系人姓名";
        _personNameView.contentTF.delegate = self;
        _personNameView.contentTF.placeholder = @"请输入联系人姓名";
    }
    return _personNameView;
}

- (FHAccountApplicationTFView *)applicantCardView {
    if (!_applicantCardView) {
        _applicantCardView = [[FHAccountApplicationTFView alloc] init];
        _applicantCardView.titleLabel.text = @"联系人身份证";
        _applicantCardView.contentTF.delegate = self;
        _applicantCardView.contentTF.placeholder = @"请输入联系人身份证";
    }
    return _applicantCardView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"手机号码";
        _phoneNumberView.contentTF.delegate = self;
        _phoneNumberView.contentTF.placeholder = @"请输入手机号码";
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"联系电话";
        _phoneView.contentTF.delegate = self;
        _phoneView.contentTF.placeholder = @"座机选填";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)mailView {
    if (!_mailView) {
        _mailView = [[FHAccountApplicationTFView alloc] init];
        _mailView.titleLabel.text = @"电子邮箱";
        _mailView.contentTF.delegate = self;
        _mailView.contentTF.placeholder = @"请输入电子邮箱";
    }
    return _mailView;
}

- (FHAccountApplicationTFView *)adverTypeView {
    if (!_adverTypeView) {
        _adverTypeView = [[FHAccountApplicationTFView alloc] init];
        _adverTypeView.titleLabel.text = @"广告类型";
        _adverTypeView.contentTF.delegate = self;
        _adverTypeView.contentTF.placeholder = @"请选择广告类型 >";
    }
    return _adverTypeView;
}

- (FHAccountApplicationTFView *)showDayView {
    if (!_showDayView) {
        _showDayView = [[FHAccountApplicationTFView alloc] init];
        _showDayView.titleLabel.text = @"投放时间";
        _showDayView.contentTF.delegate = self;
        _showDayView.contentTF.placeholder = @"请选择投放时间 >";
    }
    return _showDayView;
}

- (FHAccountApplicationTFView *)showTimeView {
    if (!_showTimeView) {
        _showTimeView = [[FHAccountApplicationTFView alloc] init];
        _showTimeView.titleLabel.text = @"投放天数";
        _showTimeView.contentTF.delegate = self;
        _showTimeView.contentTF.placeholder = @"请选择投放天数 >";
    }
    return _showTimeView;
}

- (UIView *)selectWhereView {
    if (!_selectWhereView) {
        _selectWhereView = [[UIView alloc] init];
        _selectWhereView.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _selectWhereView;
}

- (FHAccountApplicationTFView *)showLogView {
    if (!_showLogView) {
        _showLogView = [[FHAccountApplicationTFView alloc] init];
        _showLogView.titleLabel.width = 300;
        _showLogView.titleLabel.text = @"物业/业主服务广告选择精确投放位置";
        _showLogView.contentTF.delegate = self;
        _showLogView.contentTF.placeholder = @"";
        _showLogView.contentTF.userInteractionEnabled = NO;
    }
    return _showLogView;
}

- (FHAccountApplicationTFView *)showWhereView {
    if (!_showWhereView) {
        _showWhereView = [[FHAccountApplicationTFView alloc] init];
        _showWhereView.titleLabel.text = @"投放区域";
        _showWhereView.contentTF.delegate = self;
        _showWhereView.contentTF.placeholder = @"请选择投放区域 >";
    }
    return _showWhereView;
}

- (FHAccountApplicationTFView *)showNumberView {
    if (!_showNumberView) {
        _showNumberView = [[FHAccountApplicationTFView alloc] init];
        _showNumberView.titleLabel.text = @"投放账号";
        _showNumberView.contentTF.delegate = self;
        _showNumberView.contentTF.placeholder = @"准确填写物业/业主服务账号";
    }
    return _showNumberView;
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
