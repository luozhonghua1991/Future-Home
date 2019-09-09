//
//  FHAddPersonController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHAddPersonController.h"
#import "FHAccountApplicationTFView.h"

@interface FHAddPersonController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 账户名字View */
@property (nonatomic, strong) FHAccountApplicationTFView *ownerNameView;
/** 身份证View */
@property (nonatomic, strong) FHAccountApplicationTFView *ownerCodeView;
/** 性别 */
@property (nonatomic, strong) FHAccountApplicationTFView *sexView;
/** 出生年月 */
@property (nonatomic, strong) FHAccountApplicationTFView *birthView;
/** 社保卡号 */
@property (nonatomic, strong) FHAccountApplicationTFView *healthCodeView;
/** 手机号 */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;

@end

@implementation FHAddPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    [self creatBottomBtn];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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
    [self.scrollView addSubview:self.ownerNameView];
    [self.scrollView addSubview:self.ownerCodeView];
    [self.scrollView addSubview:self.sexView];
    [self.scrollView addSubview:self.birthView];
    [self.scrollView addSubview:self.healthCodeView];
    [self.scrollView addSubview:self.phoneNumberView];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.ownerNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.ownerCodeView.frame = CGRectMake(0, MaxY(self.ownerNameView), SCREEN_WIDTH, commonCellHeight);
    self.sexView.frame = CGRectMake(0, MaxY(self.ownerCodeView), SCREEN_WIDTH, commonCellHeight);
    self.birthView.frame = CGRectMake(0, MaxY(self.sexView), SCREEN_WIDTH, commonCellHeight);
    self.healthCodeView.frame = CGRectMake(0, MaxY(self.birthView), SCREEN_WIDTH, commonCellHeight);
    self.phoneNumberView.frame = CGRectMake(0, MaxY(self.healthCodeView), SCREEN_WIDTH, commonCellHeight);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.phoneNumberView.frame) + MainSizeHeight + 20);
}

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}


#pragma mark — event
- (void)sureBtnClick {
    /** 确定 */
    [self.navigationController popViewControllerAnimated:YES];
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
        _ownerNameView.titleLabel.text = @"姓名";
        _ownerNameView.contentTF.placeholder = @"请输入真实姓名";
    }
    return _ownerNameView;
}

- (FHAccountApplicationTFView *)ownerCodeView {
    if (!_ownerCodeView) {
        _ownerCodeView = [[FHAccountApplicationTFView alloc] init];
        _ownerCodeView.titleLabel.text = @"身份证号";
        _ownerCodeView.contentTF.placeholder = @"请输入身份证号";
    }
    return _ownerCodeView;
}

- (FHAccountApplicationTFView *)sexView {
    if (!_sexView) {
        _sexView = [[FHAccountApplicationTFView alloc] init];
        _sexView.titleLabel.text = @"性别";
        _sexView.contentTF.placeholder = @"请选择性别";
    }
    return _sexView;
}

- (FHAccountApplicationTFView *)birthView {
    if (!_birthView) {
        _birthView = [[FHAccountApplicationTFView alloc] init];
        _birthView.titleLabel.text = @"出生年月";
        _birthView.contentTF.placeholder = @"请选择出生年月";
    }
    return _birthView;
}

- (FHAccountApplicationTFView *)healthCodeView {
    if (!_healthCodeView) {
        _healthCodeView = [[FHAccountApplicationTFView alloc] init];
        _healthCodeView.titleLabel.text = @"社保卡号";
        _healthCodeView.contentTF.placeholder = @"请输入社保卡号";
    }
    return _healthCodeView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"手机号码";
        _phoneNumberView.contentTF.placeholder = @"请输入手机号码";
    }
    return _phoneNumberView;
}

@end
