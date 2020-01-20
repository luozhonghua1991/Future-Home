//
//  FHNormalBuinsesAccountController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  开通商业服务平台账户

#import "FHNormalBuinsesAccountController.h"
#import "FHAccountApplicationTFView.h"
#import "FHPersonCodeView.h"
#import "FHCertificationImgView.h"
#import "FHUserAgreementView.h"
#import "FHDetailAddressView.h"
#import "FHProofOfOwnershipView.h"
#import "BRPlaceholderTextView.h"
#import "NSArray+JSON.h"
#import "FHAddressPickerView.h"
#import "FHCommonALiPayTool.h"
#import "WXApi.h"
#import "FHCommonPaySelectView.h"
#import "FHAppDelegate.h"
#import "FHWebViewController.h"
#import "LeoPayManager.h"

@interface FHNormalBuinsesAccountController ()
<
UITextFieldDelegate,
UIScrollViewDelegate,
FHCertificationImgViewDelegate,
FHUserAgreementViewDelegate,
FDActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
FHCommonPaySelectViewDelegate
>
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
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;
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

/** 省的ID */
@property (nonatomic, copy) NSString *province_id;
/** 市的ID */
@property (nonatomic, copy) NSString *city_id;
/** 区的ID */
@property (nonatomic, copy) NSString *area_id;
/** 选择的是第几个 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 选择的ID cards 图片数组 */
@property (nonatomic, strong) NSMutableArray *selectIDCardsImgArrs;

@property (nonatomic, strong) FHAddressPickerView *addressPickerView;

@property (nonatomic, strong) FHCommonPaySelectView *payView;
/** 1支付宝  2 微信 */
@property (nonatomic, assign) NSInteger payType;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectCount;

@end

@implementation FHNormalBuinsesAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectCount = 0;
    self.selectIDCardsImgArrs = [[NSMutableArray alloc] init];
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    [self creatAleat];
}

- (void)creatAleat {
    NSArray *buttonTitleColorArray = @[[UIColor blackColor], [UIColor blueColor]] ;
    
    [UIAlertController ba_alertShowInViewController:self
                                              title:@"提示"
                                            message:self.tips2
                                   buttonTitleArray:@[@"取 消", @"确 定"]
                              buttonTitleColorArray:buttonTitleColorArray
                                              block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0) {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                                  
                                              }];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"开通商业服务平台账户";
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
    
//    [self.scrollView addSubview:self.accountTypeView];
    [self.scrollView addSubview:self.serviceDeskView];
    [self.serviceDeskView addSubview:self.serviceDeskNameTF];
    
    [self.scrollView addSubview:self.applicantNameView];
    [self.scrollView addSubview:self.applicantCardView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.businessDescriptionTextView];
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


#pragma mark -- layout
- (void)fh_layoutSubViews {
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.accountTypeView.frame =
    self.serviceDeskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.serviceDeskNameTF.frame = CGRectMake(SCREEN_WIDTH - 270, 20, 260, 20);
    self.applicantNameView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceDeskView.frame), SCREEN_WIDTH, 50);
    self.applicantCardView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantNameView.frame), SCREEN_WIDTH, 50);
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantCardView.frame), SCREEN_WIDTH, 50);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneNumberView.frame), SCREEN_WIDTH, 50);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, 50);
    self.detailAddressView.frame = CGRectMake(0, CGRectGetMaxY(self.mailView.frame), SCREEN_WIDTH, 50);
    self.addressView.frame =  CGRectMake(0, CGRectGetMaxY(self.detailAddressView.frame), SCREEN_WIDTH, 50);
    self.businessDescriptionTextView.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 30, SCREEN_WIDTH, 100);
    self.personCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.businessDescriptionTextView.frame), SCREEN_WIDTH, 180);
    self.shipView.frame = CGRectMake(0, CGRectGetMaxY(self.personCodeView.frame), SCREEN_WIDTH, 60);
    [self updateViewsFrame];
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
    [self.addressPickerView showInView:self.view];
}

- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger )index {
    /** 选取图片 */
    self.selectIndex = index;
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}

#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:
        {
            [self addCamera];
            break;
        }
        case 1:
        {
            [self addPhotoClick];
            break;
        }
        case 2:
        {
            ZHLog(@"取消");
            break;
        }
        default:
            
            break;
    }
}

//调用系统相机
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * cameraPicker = [[UIImagePickerController alloc]init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = NO;  //是否可编辑
        //摄像头
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

/**
 *  跳转相册页面
 */
- (void)addPhotoClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.naviBgColor = HEX_COLOR(0x1296db);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            if (self.selectIndex == 1) {
                self.certificationView.leftImgView.image = image;
                [self.selectIDCardsImgArrs addObject:image];
            } else if (self.selectIndex == 2) {
                self.certificationView.centerImgView.image = image;
                [self.selectIDCardsImgArrs addObject:image];
            } else {
                self.certificationView.rightImgView.image = image;
                [self.selectIDCardsImgArrs addObject:image];
            }
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - <相册处理区域>
/**
 *  拍摄完成后要执行的方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.selectIndex == 1) {
        self.certificationView.leftImgView.image = image;
        [self.selectIDCardsImgArrs addObject:image];
    } else if (self.selectIndex == 2) {
        self.certificationView.centerImgView.image = image;
        [self.selectIDCardsImgArrs addObject:image];
    } else {
        self.certificationView.rightImgView.image = image;
        [self.selectIDCardsImgArrs addObject:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/** 跳转协议 */
- (void)FHUserAgreementViewClick {
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = self.protocol;
    web.typeString = @"information";
    web.hidesBottomBarWhenPushed = YES;
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
    /** 确认并提交 */
//    if (self.selectIDCardsImgArrs.count != 3) {
//        [self.view makeToast:@"身份认证信息认证不能为空"];
//        return;
//    }
    if (self.selectCount % 2 == 0) {
        [self.view makeToast:@"请同意用户信息授权协议"];
        return;
    }
    /** 先加一个弹框提示 */
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf payView];
            weakSelf.submitBtn.userInteractionEnabled = NO;
            [weakSelf showPayView];
        }
    }];
}

- (void)commitAccountDataRequest {
    WS(weakSelf);
    [ZHProgressHUD showMessage:@"提交资料中..." inView:self.view];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.serviceDeskNameTF.text,@"shopname",
                               self.province_id,@"province_id",
                               self.city_id,@"city_id",
                               self.area_id,@"area_id",
                               self.applicantNameView.contentTF.text,@"name",
                               self.applicantCardView.contentTF.text,@"idcard",
                               self.phoneNumberView.contentTF.text,@"phone",
                               self.phoneView.contentTF.text,@"shopmobile",
                               self.mailView.contentTF.text,@"email",
                               self.addressView.contentTF.text,@"streetaddress",
                               self.businessDescriptionTextView.text,@"maininformation",
                               self.price,@"total",
                               @(self.payType),@"type",
                               @"4",@"ordertype",
                               self.selectIDCardsImgArrs,@"idCardFile[]",
                               [self getSmallImageArray],@"file[]",
                               nil];
    
    [AFNetWorkTool uploadImagesWithUrl:@"shop/applyAccount" parameters:paramsDic image:[self getSmallImageArray] otherImage:self.selectIDCardsImgArrs success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1) {
            if (weakSelf.payType == 1) {
                /** 支付宝支付 */
                if ([responseObj[@"code"] integerValue] == 1) {
                    if (weakSelf.payType == 1) {
                        /** 支付宝支付 */
                        [ZHProgressHUD hide];
                        LeoPayManager *manager = [LeoPayManager getInstance];
                        [manager aliPayOrder: responseObj[@"data"] scheme:@"alisdkdemo" respBlock:^(NSInteger respCode, NSString *respMsg) {
                            if (respCode == 0) {
                                /** 支付成功 */
                                WS(weakSelf);
                                [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"账号信息已经提交成功" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
                            } else {
                                [self.view makeToast:respMsg];
                            }
                        }];
                    }
                } else {
                    [self.view makeToast:responseObj[@"data"][@"msg"]];
                }
            } else if (weakSelf.payType == 2) {
                /** 微信支付 */
                if ([responseObj[@"code"] integerValue] == 1) {
                    [ZHProgressHUD hide];
                    LeoPayManager *manager = [LeoPayManager getInstance];
                    [manager wechatPayWithAppId:responseObj[@"data"][@"appid"] partnerId:responseObj[@"data"][@"partnerid"] prepayId:responseObj[@"data"][@"prepay_id"] package:responseObj[@"data"][@"package"] nonceStr:responseObj[@"data"][@"nonce_str"] timeStamp:responseObj[@"data"][@"timestamp"] sign:responseObj[@"data"][@"sign"] respBlock:^(NSInteger respCode, NSString *respMsg) {
                        //处理支付结果
                        if (respCode == 0) {
                            /** 支付成功 */
                            WS(weakSelf);
                            [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"账号信息已经提交成功" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        } else {
                            [self.view makeToast:respMsg];
                        }
                    }];
                } else {
                    [self.view makeToast:responseObj[@"data"][@"msg"]];
                }
            }
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)fh_selectPayTypeWIthTag:(NSInteger)selectType {
    /** 请求支付宝签名 */
    self.payType = selectType;
    [self commitAccountDataRequest];
}


#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak FHNormalBuinsesAccountController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.submitBtn.userInteractionEnabled = YES;
    }];
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
        _accountTypeView.contentTF.text = @"普通商业服务平台账号";
        _accountTypeView.contentTF.enabled = NO;
    }
    return _accountTypeView;
}

- (FHAccountApplicationTFView *)serviceDeskView {
    if (!_serviceDeskView) {
        _serviceDeskView = [[FHAccountApplicationTFView alloc] init];
        _serviceDeskView.titleLabel.text = @"普通商业服务平台名称";
        [_serviceDeskView.contentTF removeFromSuperview];
    }
    return _serviceDeskView;
}

- (UITextField *)serviceDeskNameTF{
    if (!_serviceDeskNameTF) {
        _serviceDeskNameTF = [[UITextField alloc] init];
        _serviceDeskNameTF.textAlignment = NSTextAlignmentRight;
        _serviceDeskNameTF.font = [UIFont systemFontOfSize:15];
        _serviceDeskNameTF.text = @"";
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

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] init];
        _businessDescriptionTextView.layer.borderWidth = 1;
        _businessDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"主营业务简述(限30-100字为宜)";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:6 legth:12]];
        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
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
        NSString *titleString = @"营业证明(营业执照,营业资质等证明文件)";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:4 legth:16]];
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

- (FHCommonPaySelectView *)payView {
    if (!_payView) {
        self.payView = [[FHCommonPaySelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260) andNSString:[NSString stringWithFormat:@"在线支付支付价格为:￥%@",self.open]];
        _payView.delegate = self;
    }
    FHAppDelegate *delegate  = (FHAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
    
    return _payView;
}

@end
