//
//  FHOwnerCertificationViewController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  业主认证 界面

#import "FHOwnerCertificationViewController.h"
#import "FHAccountApplicationTFView.h"
#import "FHCertificationImgView.h"
#import "FHPersonCodeView.h"

@interface FHOwnerCertificationViewController () <UITextFieldDelegate,UIScrollViewDelegate,FHCertificationImgViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 账户名字View */
@property (nonatomic, strong) FHAccountApplicationTFView *ownerNameView;
/** 身份证View */
@property (nonatomic, strong) FHAccountApplicationTFView *ownerCodeView;
/** 手机号 */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** u区域 */
@property (nonatomic, strong) FHAccountApplicationTFView *areaView;
/** 街道地址 */
@property (nonatomic, strong) FHAccountApplicationTFView *addressView;
/** 小区名称 */
@property (nonatomic, strong) FHAccountApplicationTFView *areaNameView;
/** 楼栋单元 */
@property (nonatomic, strong) FHAccountApplicationTFView *louNumberView;
/** 楼层房号 */
@property (nonatomic, strong) FHAccountApplicationTFView *houseNumberView;
/** 建筑面积 */
@property (nonatomic, strong) FHAccountApplicationTFView *houseAreaView;
/** 申请人身份证 */
@property (nonatomic, strong) FHPersonCodeView *personCodeView;
/** 身份证图标 */
@property (nonatomic, strong) FHCertificationImgView *certificationView;

@end

@implementation FHOwnerCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    [self fh_creatBottomBtn];
}

#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"业主认证";
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

- (void)fh_creatBottomBtn {
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    bottomBtn.backgroundColor = HEX_COLOR(0x1296db);
    [bottomBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [completedBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

- (void)fh_creatUI {
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.ownerNameView];
    [self.scrollView addSubview:self.ownerCodeView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.areaNameView];
    [self.scrollView addSubview:self.louNumberView];
    [self.scrollView addSubview:self.houseNumberView];
    [self.scrollView addSubview:self.houseAreaView];
    
    /** 申请人身份证 */
    self.certificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 100)];
    self.certificationView.delegate = self;
    [self.personCodeView addSubview:self.certificationView];
    [self.scrollView addSubview:self.personCodeView];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.ownerNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.ownerCodeView.frame = CGRectMake(0, MaxY(self.ownerNameView), SCREEN_WIDTH, commonCellHeight);
    self.phoneNumberView.frame = CGRectMake(0, MaxY(self.ownerCodeView), SCREEN_WIDTH, commonCellHeight);
    self.areaView.frame = CGRectMake(0, MaxY(self.phoneNumberView), SCREEN_WIDTH, commonCellHeight);
    self.addressView.frame = CGRectMake(0, MaxY(self.areaView), SCREEN_WIDTH, commonCellHeight);
    self.areaNameView.frame = CGRectMake(0, MaxY(self.addressView), SCREEN_WIDTH, commonCellHeight);
    self.louNumberView.frame = CGRectMake(0, MaxY(self.areaNameView), SCREEN_WIDTH, commonCellHeight);
    self.houseNumberView.frame = CGRectMake(0, MaxY(self.louNumberView), SCREEN_WIDTH, commonCellHeight);
    self.houseAreaView.frame = CGRectMake(0, MaxY(self.houseNumberView), SCREEN_WIDTH, commonCellHeight);
    self.personCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.houseAreaView.frame), SCREEN_WIDTH, 180);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.personCodeView.frame) + MainSizeHeight + 20);
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


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)ownerNameView {
    if (!_ownerNameView) {
        _ownerNameView = [[FHAccountApplicationTFView alloc] init];
        _ownerNameView.titleLabel.text = @"业主姓名";
        _ownerNameView.contentTF.placeholder = @"请输入业主姓名";
    }
    return _ownerNameView;
}

- (FHAccountApplicationTFView *)ownerCodeView {
    if (!_ownerCodeView) {
        _ownerCodeView = [[FHAccountApplicationTFView alloc] init];
        _ownerCodeView.titleLabel.text = @"身份证号";
        _ownerCodeView.contentTF.placeholder = @"请输入业主身份证号";
    }
    return _ownerCodeView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"手机号码";
        _phoneNumberView.contentTF.placeholder = @"请输入手机号码";
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"所在区域";
        _areaView.contentTF.placeholder = @"请选择所在区域 >";
    }
    return _areaView;
}

- (FHAccountApplicationTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHAccountApplicationTFView alloc] init];
        _addressView.titleLabel.text = @"街道地址";
        _addressView.contentTF.placeholder = @"请输入街道地址";
    }
    return _addressView;
}

- (FHAccountApplicationTFView *)areaNameView {
    if (!_areaNameView) {
        _areaNameView = [[FHAccountApplicationTFView alloc] init];
        _areaNameView.titleLabel.text = @"小区名称";
        _areaNameView.contentTF.placeholder = @"请输入小区名称";
    }
    return _areaNameView;
}

- (FHAccountApplicationTFView *)louNumberView {
    if (!_louNumberView) {
        _louNumberView = [[FHAccountApplicationTFView alloc] init];
        _louNumberView.titleLabel.text = @"楼栋单元";
        _louNumberView.contentTF.placeholder = @"请输入楼栋单元";
    }
    return _louNumberView;
}

- (FHAccountApplicationTFView *)houseNumberView {
    if (!_houseNumberView) {
        _houseNumberView = [[FHAccountApplicationTFView alloc] init];
        _houseNumberView.titleLabel.text = @"楼层房号";
        _houseNumberView.contentTF.placeholder = @"请输入楼层房号";
    }
    return _houseNumberView;
}

- (FHAccountApplicationTFView *)houseAreaView {
    if (!_houseAreaView) {
        _houseAreaView = [[FHAccountApplicationTFView alloc] init];
        _houseAreaView.titleLabel.text = @"建筑面积";
        _houseAreaView.contentTF.placeholder = @"请输入建筑面积";
    }
    return _houseAreaView;
}

- (FHPersonCodeView *)personCodeView {
    if (!_personCodeView) {
        _personCodeView = [[FHPersonCodeView alloc] init];
        _personCodeView.titleLabel.text = @"业主身份证";
    }
    return _personCodeView;
}

@end
