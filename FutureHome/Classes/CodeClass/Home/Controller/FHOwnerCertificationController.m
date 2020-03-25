//
//  FHOwnerCertificationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHOwnerCertificationController.h"
#import "FHOwnerCertificationViewController.h"
#import "FHAccountApplicationTFView.h"

@interface FHOwnerCertificationController () <UITextFieldDelegate,UIScrollViewDelegate>
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

@end

@implementation FHOwnerCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.type isEqualToString:@"我的业委"]) {
        [self fh_creatNav];
        //显示用户所填资料
        [self fh_creatUI];
        [self fh_layoutSubViews];
    } else {
        if (self.authModel.audit_status == 0) {
            /** 没有填过认证资料 */
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake(10, ScreenHeight / 2 - 30, ScreenWidth - 20, 50);
            _button.backgroundColor = HEX_COLOR(0x1296db);
            _button.layer.cornerRadius = 25;
            _button.layer.masksToBounds = YES;
            _button.clipsToBounds = YES;
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(goOwnerCertification) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_button];
            [_button setTitle:@"前往认证业主信息" forState:UIControlStateNormal];
        } else if (self.authModel.audit_status == 1) {
            /** 资料审核中 */
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake(10, ScreenHeight / 2 - 30, ScreenWidth - 20, 50);
            _button.backgroundColor = HEX_COLOR(0x1296db);
            _button.layer.cornerRadius = 25;
            _button.layer.masksToBounds = YES;
            _button.clipsToBounds = YES;
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _button.enabled = NO;
            [self.view addSubview:_button];
            [_button setTitle:@"资料审核中" forState:UIControlStateNormal];
        } else if (self.authModel.audit_status == 2) {
            //显示用户所填资料
            [self fh_creatUI];
            [self fh_layoutSubViews];
        } else if (self.authModel.audit_status == 3) {
            /** 审核失败 */
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake(10, ScreenHeight / 2 - 30, ScreenWidth - 20, 50);
            _button.backgroundColor = HEX_COLOR(0x1296db);
            _button.layer.cornerRadius = 25;
            _button.layer.masksToBounds = YES;
            _button.clipsToBounds = YES;
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(goOwnerCertification) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_button];
            [_button setTitle:@"审核失败,请重新前往认证业主信息" forState:UIControlStateNormal];
        }
    }
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.type;
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
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.areaNameView];
    [self.scrollView addSubview:self.louNumberView];
    [self.scrollView addSubview:self.houseNumberView];
    [self.scrollView addSubview:self.houseAreaView];
}

#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    if ([self.type isEqualToString:@"我的业委"]) {
        self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight);
    } else {
        self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    self.ownerNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.ownerCodeView.frame = CGRectMake(0, MaxY(self.ownerNameView), SCREEN_WIDTH, commonCellHeight);
    self.phoneNumberView.frame = CGRectMake(0, MaxY(self.ownerCodeView), SCREEN_WIDTH, commonCellHeight);
    self.areaView.frame = CGRectMake(0, MaxY(self.phoneNumberView), SCREEN_WIDTH, commonCellHeight);
    self.addressView.frame = CGRectMake(0, MaxY(self.areaView), SCREEN_WIDTH, commonCellHeight);
    self.areaNameView.frame = CGRectMake(0, MaxY(self.addressView), SCREEN_WIDTH, commonCellHeight);
    self.louNumberView.frame = CGRectMake(0, MaxY(self.areaNameView), SCREEN_WIDTH, commonCellHeight);
    self.houseNumberView.frame = CGRectMake(0, MaxY(self.louNumberView), SCREEN_WIDTH, commonCellHeight);
    self.houseAreaView.frame = CGRectMake(0, MaxY(self.houseNumberView), SCREEN_WIDTH, commonCellHeight);
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.houseAreaView.frame) + MainSizeHeight + 20);
}

- (void)goOwnerCertification {
    /** 去业主认证 */
//    [self viewControllerPushOther:@"FHOwnerCertificationViewController"];
    
    FHOwnerCertificationViewController *vc = [[FHOwnerCertificationViewController alloc] init];
    vc.property_id = self.property_id;
    vc.hidesBottomBarWhenPushed = YES;
    vc.path = @"property";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setAuthModel:(FHAuthModel *)authModel {
    _authModel = authModel;
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
        _ownerNameView.contentTF.text = self.authModel.name;
    }
    return _ownerNameView;
}

- (FHAccountApplicationTFView *)ownerCodeView {
    if (!_ownerCodeView) {
        _ownerCodeView = [[FHAccountApplicationTFView alloc] init];
        _ownerCodeView.titleLabel.text = @"身份证号";
        _ownerCodeView.contentTF.placeholder = @"请输入业主身份证号";
        _ownerCodeView.contentTF.text = self.authModel.id_num;
    }
    return _ownerCodeView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"手机号码";
        _phoneNumberView.contentTF.placeholder = @"请输入手机号码";
        _phoneNumberView.contentTF.text = self.authModel.mobile;
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"所在区域";
        _areaView.contentTF.placeholder = @"请选择所在区域 >";
        _areaView.contentTF.text = [NSString stringWithFormat:@"%@%@%@",self.authModel.province_id,self.authModel.city_id,self.authModel.area_id];
    }
    return _areaView;
}

- (FHAccountApplicationTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHAccountApplicationTFView alloc] init];
        _addressView.titleLabel.text = @"街道地址";
        _addressView.contentTF.placeholder = @"请输入街道地址";
        _addressView.contentTF.text = self.authModel.street_name;
    }
    return _addressView;
}

- (FHAccountApplicationTFView *)areaNameView {
    if (!_areaNameView) {
        _areaNameView = [[FHAccountApplicationTFView alloc] init];
        _areaNameView.titleLabel.text = @"小区名称";
        _areaNameView.contentTF.placeholder = @"请输入小区名称";
        _areaNameView.contentTF.text = self.authModel.cell_name;
    }
    return _areaNameView;
}

- (FHAccountApplicationTFView *)louNumberView {
    if (!_louNumberView) {
        _louNumberView = [[FHAccountApplicationTFView alloc] init];
        _louNumberView.titleLabel.text = @"楼栋单元";
        _louNumberView.contentTF.placeholder = @"请输入楼栋单元";
        _louNumberView.contentTF.text = [NSString stringWithFormat:@"%ld栋",(long)self.authModel.build_num];
    }
    return _louNumberView;
}

- (FHAccountApplicationTFView *)houseNumberView {
    if (!_houseNumberView) {
        _houseNumberView = [[FHAccountApplicationTFView alloc] init];
        _houseNumberView.titleLabel.text = @"楼层房号";
        _houseNumberView.contentTF.placeholder = @"请输入楼层房号";
        _houseNumberView.contentTF.text = [NSString stringWithFormat:@"%ld",(long)self.authModel.room_num];
    }
    return _houseNumberView;
}

- (FHAccountApplicationTFView *)houseAreaView {
    if (!_houseAreaView) {
        _houseAreaView = [[FHAccountApplicationTFView alloc] init];
        _houseAreaView.titleLabel.text = @"建筑面积";
        _houseAreaView.contentTF.placeholder = @"请输入建筑面积";
        _houseAreaView.contentTF.text = [NSString stringWithFormat:@"%ld㎡",(long)self.authModel.area];
    }
    return _houseAreaView;
}

@end
