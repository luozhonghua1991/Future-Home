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
#import "FHSelectWhereCollectionCell.h"

@interface FHAdvertisingCooperationController ()
<UITextFieldDelegate,
UIScrollViewDelegate,
FHUserAgreementViewDelegate,
FHCommonPaySelectViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 单位名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantNameView;
/** 单位区域详情地址选择View */
//@property (nonatomic, strong) FHDetailAddressView *detailAddressView;
/** 区域View */
@property (nonatomic, strong) FHAccountApplicationTFView *areaView;
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
/** 广告跳转账号 */
@property (nonatomic, strong) FHAccountApplicationTFView *adverNumberView;
/** 投放时间 */
@property (nonatomic, strong) FHAccountApplicationTFView *showDayView;
/** 投放时长 */
@property (nonatomic, strong) FHAccountApplicationTFView *showTimeView;
/** 请选择投放位置 */
@property (nonatomic, strong) FHAccountApplicationTFView *selectWhereTF;
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
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectCount;

/** <#strong属性注释#> */
@property (nonatomic, strong) UICollectionView *selectWhereCollection;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSArray *selectWhereArrs;

@property (nonatomic, strong) UIButton * oldSelectBtn;
/** 选择投放的位置 */
@property (nonatomic, assign) NSInteger selectWhereType;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL selectBottomAdderss;
/** 广告类型 1纯图片 2图片+电商链接 3图片+视频 4 图片+视频+电商链接 */
@property (nonatomic, assign) NSInteger adventtype;
/** 投放广告的所在位置 */
@property (nonatomic, copy) NSString *adventString;

/** 投放区域省的ID */
@property (nonatomic, copy) NSString *bottom_province_id;
/** 投放区域市的ID */
@property (nonatomic, copy) NSString *bottom_city_id;
/** 投放区域区的ID */
@property (nonatomic, copy) NSString *bottom_area_id;

@end

@implementation FHAdvertisingCooperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectWhereArrs = @[@"社云主⻚广告A1 (上)",
                                 @"健康服务广告B1 (上)",
                                 @"社云主页广告A2 (下)",
                                 @"健康服务广告B2 (下)",
                                 @"资讯服务广告C1 (上)",
                                 @"客服服务广告D1 (上)",
                                 @"资讯服务广告C2 (下)",
                                 @"客服服务广告D2 (下)",
                                 @"物业服务广告W1 (上)",
                                 @"业主服务广告Y1 (上)",
                                 @"物业服务广告W2 (下)",
                                 @"业主服务广告Y2 (下)"];
    self.selectCount = 0;
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
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
                                            message:self.tips2
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
//    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.personNameView];
//    [self.scrollView addSubview:self.applicantCardView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    [self.scrollView addSubview:self.adverTypeView];
    [self.scrollView addSubview:self.adverNumberView];
    [self.scrollView addSubview:self.showDayView];
    [self.scrollView addSubview:self.showTimeView];
    [self.scrollView addSubview:self.selectWhereTF];
    [self.scrollView addSubview:self.selectWhereView];
    [self.scrollView addSubview:self.showLogView];
    [self.scrollView addSubview:self.showWhereView];
    [self.scrollView addSubview:self.showNumberView];
    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
    /** 确认并提交按钮 */
    [self.scrollView addSubview:self.submitBtn];
    
    self.showLogView.contentTF.userInteractionEnabled = NO;
    self.showWhereView.contentTF.userInteractionEnabled = NO;
    self.showNumberView.contentTF.userInteractionEnabled = NO;
    
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
        if (self.selectBottomAdderss) {
            self.showWhereView.contentTF.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
            self.bottom_province_id = provienceCode;
            self.bottom_city_id = parentCode;
            self.bottom_area_id = addressCode;
        } else {
//            self.detailAddressView.leftProvinceDataLabel.text = province;
//            self.detailAddressView.centerProvinceDataLabel.text = city;
//            self.detailAddressView.rightProvinceDataLabel.text = district;
            self.areaView.contentTF.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
            self.province_id = provienceCode;
            self.city_id = parentCode;
            self.area_id = addressCode;
        }
        //移除掉地址选择器
        [self.addressPickerView hiddenInView];
        
    };
}

- (void)fh_layoutSubViews {
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.applicantNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.areaView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantNameView.frame), SCREEN_WIDTH, 50);
    self.addressView.frame =  CGRectMake(0, CGRectGetMaxY(self.areaView.frame), SCREEN_WIDTH, 50);
    self.personNameView.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame), SCREEN_WIDTH, 50);
//    self.applicantCardView.frame = CGRectMake(0, CGRectGetMaxY(self.personNameView.frame), SCREEN_WIDTH, 50);
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.personNameView.frame), SCREEN_WIDTH, 50);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneNumberView.frame), SCREEN_WIDTH, 50);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, 50);
    self.adverTypeView.frame = CGRectMake(0, CGRectGetMaxY(self.mailView.frame), SCREEN_WIDTH, 50);
    self.adverNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.adverTypeView.frame), SCREEN_WIDTH, 50);
    self.showDayView.frame = CGRectMake(0, CGRectGetMaxY(self.adverNumberView.frame), SCREEN_WIDTH, 50);
    self.showTimeView.frame = CGRectMake(0, CGRectGetMaxY(self.showDayView.frame), SCREEN_WIDTH, 50);
    self.selectWhereTF.frame = CGRectMake(0, CGRectGetMaxY(self.showTimeView.frame), SCREEN_WIDTH, 50);
    self.selectWhereView.frame = CGRectMake(0, CGRectGetMaxY(self.selectWhereTF.frame), SCREEN_WIDTH, 200);
    [self.selectWhereView addSubview:self.selectWhereCollection];
    self.showLogView.frame = CGRectMake(0, CGRectGetMaxY(self.selectWhereView.frame), SCREEN_WIDTH, 50);
    self.showWhereView.frame = CGRectMake(0, CGRectGetMaxY(self.showLogView.frame), SCREEN_WIDTH, 50);
    self.showNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.showWhereView.frame), SCREEN_WIDTH, 50);
    self.agreementView.frame = CGRectMake(0, CGRectGetMaxY(self.showNumberView.frame) + 100, SCREEN_WIDTH, 15);
    self.submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
    self.submitBtn.centerX = self.view.width / 2;
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + MainSizeHeight + 20);
    
}


//- (void)fh_creatDetailAddressView {
//    if (!self.detailAddressView) {
//        self.detailAddressView = [[FHDetailAddressView alloc] init];
//        self.view.userInteractionEnabled = YES;
//        self.scrollView.userInteractionEnabled = YES;
//        self.detailAddressView.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick)];
//        [self.detailAddressView addGestureRecognizer:tap];
//        [self.scrollView addSubview:self.detailAddressView];
//    }
//}


#pragma mark — event
/** 地址选择 */
//- (void)addressClick {
//    self.selectBottomAdderss = NO;
//    [self.addressPickerView showInView:self.view];
//}

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.adverNumberView.contentTF) {
        if (self.adventtype == 0) {
            [self.view makeToast:@"请先选择广告类型"];
            return NO;
        } else {
            if (self.adventtype == 1 || self.adventtype == 2) {
                [self.view makeToast:@"该广告类型不支持跳转"];
                return NO;
            }
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.adverTypeView.contentTF) {
        [self.adverTypeView.contentTF resignFirstResponder];
        /** 选择广告类型 */
        [ZJNormalPickerView zj_showStringPickerWithTitle:@"选择广告类型" dataSource:@[@"1图片类型无跳转广告",@"2视频类型无跳转广告",@"3视频跳转电商广告",@"4图片跳转电商广告"] defaultSelValue:@"" isAutoSelect: NO resultBlock:^(id selectValue, NSInteger index) {
            NSLog(@"index---%ld",index);
            self.adventtype = index + 1;
            self.adverTypeView.contentTF.text = selectValue;
        } cancelBlock:^{
            
        }];
    } else if (textField == self.showWhereView.contentTF) {
        /** 投放区域 */
        [self.showWhereView.contentTF resignFirstResponder];
        self.selectBottomAdderss = YES;
        [self.addressPickerView showInView:self.view];
    } else if (textField == self.areaView.contentTF) {
        [self.areaView.contentTF resignFirstResponder];
        self.selectBottomAdderss = NO;
        [self.addressPickerView showInView:self.view];
    } else if (textField == self.showTimeView.contentTF) {
        [self.showTimeView.contentTF resignFirstResponder];
        /** 选择结束投放时间 */
        [ZJDatePickerView zj_showDatePickerWithTitle:@"选择结束投放时间" dateType:ZJDatePickerModeYMD defaultSelValue:@"" resultBlock:^(NSString *selectValue) {
            NSString *starTimer = self.showDayView.contentTF.text;
            NSString *finishTimer = self.showTimeView.contentTF.text;
            BOOL result = [starTimer compare:finishTimer] == NSOrderedSame;
            NSLog(@"result:%d",result);
            if (result == 1) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"开始时间和结束时间相等" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                self.showTimeView.contentTF.text = @"请重新选择结束时间";
                return;
            }
            
            BOOL result1 = [starTimer compare:finishTimer]==NSOrderedDescending;
            NSLog(@"result1:%d",result1);
            if (result1 == 1) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"结束时间不能早于开始时间" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                self.showTimeView.contentTF.text = @"请重新选择结束时间";
                return;
            }
            self.showTimeView.contentTF.text = selectValue;
        } ];
    } else if (textField == self.showDayView.contentTF) {
        [self.showDayView.contentTF resignFirstResponder];
        /** 选择具体投放时间 */
        [ZJDatePickerView zj_showDatePickerWithTitle:@"选择开始投放时间" dateType:ZJDatePickerModeYMD defaultSelValue:@"" resultBlock:^(NSString *selectValue) {
            self.showDayView.contentTF.text = selectValue;
        } ];
    }
}

/** 跳转协议 */
- (void)FHUserAgreementViewClick {
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = self.protocol;
    web.typeString = @"information";
    web.hidesBottomBarWhenPushed = YES;
    web.type = @"noShow";
    web.titleString = @"用户协议";
    [self.navigationController pushViewController:web animated:YES];
}

/** 确认协议 */
- (void)fh_fhuserAgreementWithBtn:(UIButton *)sender {
    if (self.selectCount % 2 == 0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    self.selectCount++;
}

- (void)submitBtnClick {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATESUCCESS" object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    return;
    
    
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf commitRequest];
        }
    }];
}

- (void)commitRequest {
    if (self.selectCount % 2 == 0) {
        [self.view makeToast:@"请同意用户信息授权协议"];
        return;
    }
    /** 判空 */
    if (self.applicantNameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.applicantNameView.contentTF.placeholder];
        return;
    }
    if (self.areaView.contentTF.text.length <= 0) {
        [self.view makeToast:self.areaView.contentTF.placeholder];
        return;
    }
    if (self.addressView.contentTF.text.length <= 0) {
        [self.view makeToast:self.addressView.contentTF.placeholder];
        return;
    }
    if (self.personNameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.personNameView.contentTF.placeholder];
        return;
    }
//    if (self.applicantCardView.contentTF.text.length <= 0) {
//        [self.view makeToast:self.applicantCardView.contentTF.placeholder];
//        return;
//    }
//    if (self.applicantCardView.contentTF.text.length < 18) {
//        [self.view makeToast:@"身份证格式不正确,请重新填写"];
//        return;
//    }
    if (self.phoneNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.phoneNumberView.contentTF.placeholder];
        return;
    }
    if (self.phoneNumberView.contentTF.text.length < 11) {
        [self.view makeToast:@"手机号码格式不正确,请重新填写"];
        return;
    }
    if (self.phoneView.contentTF.text.length <= 0) {
        [self.view makeToast:self.phoneView.contentTF.placeholder];
        return;
    }
    if (self.mailView.contentTF.text.length <= 0) {
        [self.view makeToast:self.mailView.contentTF.placeholder];
        return;
    }
    if (self.adverTypeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.adverTypeView.contentTF.placeholder];
        return;
    }
    if (self.adventtype == 3 || self.adventtype == 4) {
        if (self.adverNumberView.contentTF.text.length <= 0) {
            [self.view makeToast:self.adverNumberView.contentTF.placeholder];
            return;
        }
    }
    if (self.showDayView.contentTF.text.length <= 0) {
        [self.view makeToast:self.showDayView.contentTF.placeholder];
        return;
    }
    if (self.showTimeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.showTimeView.contentTF.placeholder];
        return;
    }
    if (IsStringEmpty(self.adventString)) {
        [self.view makeToast:@"请选择广告投放位置"];
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHud];
    /** 直接提交操作就行 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.applicantNameView.contentTF.text,@"unitname",
                               self.addressView.contentTF.text,@"unitaddress",
                               self.personNameView.contentTF.text,@"contactname",
                               self.phoneNumberView.contentTF.text,@"phone",
                               self.phoneView.contentTF.text,@"landline",
                               self.mailView.contentTF.text,@"email",
                               @(self.adventtype),@"adventtype",
                               self.adventString,@"putpositive",
                               self.showDayView.contentTF.text,@"putinstarttime",
                               self.showTimeView.contentTF.text,@"putinendttime",
                               self.province_id,@"unitprovince",
                               self.city_id,@"unitarea",
                               self.area_id,@"unitcity",
                               self.adverNumberView.contentTF.text,@"idcard",
                               /** 投放区域的id参数 */
                               self.bottom_province_id,@"province_id",
                               self.bottom_city_id,@"city_id",
                               self.bottom_area_id,@"area_id",
                               self.showNumberView.contentTF.text,@"dropaccount",
                               nil];
    
    [AFNetWorkTool post:@"advent/saveinfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:@"广告合作申请提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATESUCCESS" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        [weakSelf.loadingHud hideAnimated:YES];
        weakSelf.loadingHud = nil;
    }];
}


#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectWhereArrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHSelectWhereCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHSelectWhereCollectionCell class]) forIndexPath:indexPath];
    [cell.selectBtn setTitle:[NSString stringWithFormat:@"%@",self.selectWhereArrs[indexPath.item]] forState:UIControlStateNormal];
    cell.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cell.selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [cell.selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.tag = indexPath.item + 1;
    if (indexPath.item > 7) {
        [cell.selectBtn setTitleColor:HEX_COLOR(0x008b8b) forState:UIControlStateNormal];
    } else {
        [cell.selectBtn setTitleColor:HEX_COLOR(0x1c86ee) forState:UIControlStateNormal];
    }
    return cell;
}


#pragma mark -tableView代理方法
- (void)selectBtnClick:(UIButton *)btn {
    if (self.oldSelectBtn == btn) {
    } else {
        [btn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        [self.oldSelectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    self.oldSelectBtn = btn;
    self.selectWhereType = btn.tag;
    self.adventString = [self.oldSelectBtn.currentTitle substringWithRange:NSMakeRange(6, 2)];
    if (self.selectWhereType >=0 && self.selectWhereType <=8) {
        /** 选择A1-D2的位
         置，物业/业主服务 ⼴广告选择精确投放位 置，将保持灰度显示 锁定不不能选择和填写 */
        self.showLogView.contentTF.userInteractionEnabled = NO;
        self.showWhereView.contentTF.userInteractionEnabled = NO;
        self.showNumberView.contentTF.userInteractionEnabled = NO;
        self.showLogView.titleLabel.textColor = HEX_COLOR(0x878787);
        self.showWhereView.titleLabel.textColor = HEX_COLOR(0x878787);
        self.showNumberView.titleLabel.textColor = HEX_COLOR(0x878787);
    } else {
        /** 选择W1-W2;Y1-
         Y2的位置，蓝⾊色⾼高亮 显示物业/业主服务 ⼴广告选择精确投放位 置，将并选择填写， 账号位数检验 */
        self.showLogView.contentTF.userInteractionEnabled = YES;
        self.showWhereView.contentTF.userInteractionEnabled = YES;
        self.showNumberView.contentTF.userInteractionEnabled = YES;
        self.showLogView.titleLabel.textColor = [UIColor blueColor];
        self.showWhereView.titleLabel.textColor = [UIColor blueColor];
        self.showNumberView.titleLabel.textColor = [UIColor blueColor];

    }
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

- (FHAccountApplicationTFView *)adverNumberView {
    if (!_adverNumberView) {
        _adverNumberView = [[FHAccountApplicationTFView alloc] init];
        _adverNumberView.titleLabel.text = @"广告跳转账号";
        _adverNumberView.contentTF.delegate = self;
        _adverNumberView.contentTF.placeholder = @"请准确输入广告跳转的账号";
    }
    return _adverNumberView;
}

- (FHAccountApplicationTFView *)showDayView {
    if (!_showDayView) {
        _showDayView = [[FHAccountApplicationTFView alloc] init];
        _showDayView.titleLabel.text = @"预计开始投放时间";
        _showDayView.contentTF.delegate = self;
        _showDayView.contentTF.placeholder = @"请选择开始投放时间 >";
    }
    return _showDayView;
}

- (FHAccountApplicationTFView *)showTimeView {
    if (!_showTimeView) {
        _showTimeView = [[FHAccountApplicationTFView alloc] init];
        _showTimeView.titleLabel.text = @"预计投放结束时间";
        _showTimeView.contentTF.delegate = self;
        _showTimeView.contentTF.placeholder = @"请选择投放结束时间 >";
    }
    return _showTimeView;
}

- (FHAccountApplicationTFView *)selectWhereTF {
    if (!_selectWhereTF) {
        _selectWhereTF = [[FHAccountApplicationTFView alloc] init];
        _selectWhereTF.bottomLineView.hidden = YES;
        _selectWhereTF.titleLabel.textColor = [UIColor blackColor];
        _selectWhereTF.titleLabel.text = @"请选择投放位置";
    }
    return _selectWhereTF;
}

- (UIView *)selectWhereView {
    if (!_selectWhereView) {
        _selectWhereView = [[UIView alloc] init];
        _selectWhereView.backgroundColor = [UIColor whiteColor];
        
    }
    return _selectWhereView;
}

- (UICollectionView *)selectWhereCollection {
    if (!_selectWhereCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, 200 / 6);
        
        _selectWhereCollection = [[UICollectionView alloc]initWithFrame:self.selectWhereView.bounds collectionViewLayout:flowLayout];
        _selectWhereCollection.showsHorizontalScrollIndicator = NO;
        _selectWhereCollection.showsVerticalScrollIndicator = NO;
        _selectWhereCollection.backgroundColor = [UIColor clearColor];
        [_selectWhereCollection registerClass:[FHSelectWhereCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FHSelectWhereCollectionCell class])];
        _selectWhereCollection.dataSource = self;
        _selectWhereCollection.delegate = self;
        
    }
    return _selectWhereCollection;
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
        _submitBtn.backgroundColor = HEX_COLOR(0x1296db);
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"单位所在区域";
        _areaView.contentTF.delegate = self;
        _areaView.contentTF.placeholder = @"请选择单位所在区域 >";
    }
    return _areaView;
}

@end
