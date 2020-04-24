//
//  FHProprietaryAccountController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  联合开通业主服务/物业服务平台账户界面

#import "FHProprietaryAccountController.h"
#import "FHAccountApplicationTFView.h"
#import "FHPersonCodeView.h"
#import "FHCertificationImgView.h"
#import "FHUserAgreementView.h"
#import "FHDetailAddressView.h"
#import "FHProofOfOwnershipView.h"
#import "NSArray+JSON.h"
#import "FHAddressPickerView.h"
#import "FHCommonALiPayTool.h"
#import "WXApi.h"
#import "FHCommonPaySelectView.h"
#import "FHAppDelegate.h"
#import "FHWebViewController.h"
#import "LeoPayManager.h"

@interface FHProprietaryAccountController () <UITextFieldDelegate,UIScrollViewDelegate,FHCertificationImgViewDelegate,FHUserAgreementViewDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,FHCommonPaySelectViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 账户类型View */
@property (nonatomic, strong) FHAccountApplicationTFView *accountTypeView;
/** 基本信息蓝色btn */
@property (nonatomic, strong) UIButton *normalBlueBtn;
/** 业主服务平台View */
@property (nonatomic, strong) FHAccountApplicationTFView *personServiceDeskView;
/** 服务平台View */
@property (nonatomic, strong) FHAccountApplicationTFView *serviceDeskView;
/** 服务平台TF */
@property (nonatomic, strong) UITextField *serviceDeskNameTF;
/** 小区名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *cellNameView;
/** 管理员名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *managerNameView;
/**管理员身份证*/
@property (nonatomic, strong) FHAccountApplicationTFView *managerCardView;

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
/** 区域View */
@property (nonatomic, strong) FHAccountApplicationTFView *areaView;
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

/** 省的ID */
@property (nonatomic, copy) NSString *province_id;
/** 市的ID */
@property (nonatomic, copy) NSString *city_id;
/** 区的ID */
@property (nonatomic, copy) NSString *area_id;
/** 选择的是第几个 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 选择的是哪个用户的 */
@property (nonatomic, assign) NSInteger selectTag;
/** 选择的ID cards 图片数组 */
@property (nonatomic, strong) NSMutableArray *selectIDCardsImgArrs;

@property (nonatomic, strong) FHAddressPickerView *addressPickerView;

@property (nonatomic, strong) FHCommonPaySelectView *payView;
/** 1支付宝  2 微信 */
@property (nonatomic, assign) NSInteger payType;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectCount;
/** 用户名字 */
@property (nonatomic, strong) NSMutableArray *personNameArrs;
/** 身份证 */
@property (nonatomic, strong) NSMutableArray *idNumberArrs;
/** 手机号 */
@property (nonatomic, strong) NSMutableArray *phoneNumberArrs;
/** 房间号 */
@property (nonatomic, strong) NSMutableArray *houseNumberArrs;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

@end

@implementation FHProprietaryAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectCount = 0;
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
    titleLabel.text = @"联合开通业主服务/物业服务平台账户";
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

- (void)fh_creatUI {
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.normalBlueBtn];
    
    [self.scrollView addSubview:self.personServiceDeskView];
    [self.scrollView addSubview:self.serviceDeskView];
    [self.serviceDeskView addSubview:self.serviceDeskNameTF];
    [self.scrollView addSubview:self.cellNameView];
    [self.scrollView addSubview:self.managerNameView];
    [self.scrollView addSubview:self.managerCardView];
//    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
    
    [self.scrollView addSubview:self.topGreenBtn];
    [self.scrollView addSubview:self.person1NameView];
    [self.scrollView addSubview:self.person1CodeView];
    [self.scrollView addSubview:self.person1PhoneView];
    [self.scrollView addSubview:self.person1HourseNumberView];
    /** 业主1申请人身份证 */
    self.person1CertificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 120)];
    self.person1CertificationView.delegate = self;
    self.person1CertificationView.tag = 1;
    [self.person1ApplicationCodeView addSubview:self.person1CertificationView];
    self.person1CertificationView.changeTitleLabel.height = 35;
    self.person1CertificationView.changeTitleLabel.text = @"房产证件信息页\n购房合同信息页";
    [self.scrollView addSubview:self.person1ApplicationCodeView];
    
    [self.scrollView addSubview:self.centerGreenBtn];
    [self.scrollView addSubview:self.person2NameView];
    [self.scrollView addSubview:self.person2CodeView];
    [self.scrollView addSubview:self.person2PhoneView];
    [self.scrollView addSubview:self.person2HourseNumberView];
    /** 业主2申请人身份证 */
    self.person2CertificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 120)];
    self.person2CertificationView.delegate = self;
    self.person2CertificationView.tag = 2;
    [self.person2ApplicationCodeView addSubview:self.person2CertificationView];
    self.person2CertificationView.changeTitleLabel.height = 35;
    self.person2CertificationView.changeTitleLabel.text = @"房产证件信息页\n购房合同信息页";
    [self.scrollView addSubview:self.person2ApplicationCodeView];
    
    [self.scrollView addSubview:self.bottomGreenBtn];
    [self.scrollView addSubview:self.person3NameView];
    [self.scrollView addSubview:self.person3CodeView];
    [self.scrollView addSubview:self.person3PhoneView];
    [self.scrollView addSubview:self.person3HourseNumberView];
    /** 业主3申请人身份证 */
    self.person3CertificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 120)];
    self.person3CertificationView.delegate = self;
    self.person3CertificationView.tag = 3;
    [self.person3ApplicationCodeView addSubview:self.person3CertificationView];
    self.person3CertificationView.changeTitleLabel.height = 35;
    self.person3CertificationView.changeTitleLabel.text = @"房产证件信息页\n购房合同信息页";
    [self.scrollView addSubview:self.person3ApplicationCodeView];
//    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
//    /** 确认并提交按钮 */
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
        
//        self.detailAddressView.leftProvinceDataLabel.text = province;
//        self.detailAddressView.centerProvinceDataLabel.text = city;
//        self.detailAddressView.rightProvinceDataLabel.text = district;
        
        self.areaView.contentTF.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        self.province_id = provienceCode;
        self.city_id = parentCode;
        self.area_id = addressCode;
        //移除掉地址选择器
        [self.addressPickerView hiddenInView];
    };
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.normalBlueBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.personServiceDeskView.frame = CGRectMake(0, CGRectGetMaxY(self.normalBlueBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.serviceDeskView.frame = CGRectMake(0, CGRectGetMaxY(self.personServiceDeskView.frame), SCREEN_WIDTH, commonCellHeight);
    self.serviceDeskNameTF.frame = CGRectMake(SCREEN_WIDTH - 270, 20, 260, 20);
    self.cellNameView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceDeskView.frame), SCREEN_WIDTH, commonCellHeight);
    self.managerNameView.frame = CGRectMake(0, CGRectGetMaxY(self.cellNameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.managerCardView.frame = CGRectMake(0, CGRectGetMaxY(self.managerNameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.managerCardView.frame), SCREEN_WIDTH, commonCellHeight);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, commonCellHeight);
    
    self.areaView.frame = CGRectMake(0, CGRectGetMaxY(self.mailView.frame), SCREEN_WIDTH, commonCellHeight);
    
//    self.detailAddressView.frame = CGRectMake(0, CGRectGetMaxY(self.areaView.frame), SCREEN_WIDTH, commonCellHeight);
    self.addressView.frame =  CGRectMake(0, CGRectGetMaxY(self.areaView.frame), SCREEN_WIDTH, commonCellHeight);
    
    self.topGreenBtn.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame) + 20, SCREEN_WIDTH, commonCellHeight - 5);
    self.person1NameView.frame = CGRectMake(0, CGRectGetMaxY(self.topGreenBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1CodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person1NameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1PhoneView.frame = CGRectMake(0, CGRectGetMaxY(self.person1CodeView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1HourseNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.person1PhoneView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person1ApplicationCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person1HourseNumberView.frame), SCREEN_WIDTH, 200);
    
    self.centerGreenBtn.frame = CGRectMake(0, CGRectGetMaxY(self.person1ApplicationCodeView.frame) + 30, SCREEN_WIDTH, commonCellHeight - 5);
    self.person2NameView.frame = CGRectMake(0, CGRectGetMaxY(self.centerGreenBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2CodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person2NameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2PhoneView.frame = CGRectMake(0, CGRectGetMaxY(self.person2CodeView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2HourseNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.person2PhoneView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person2ApplicationCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person2HourseNumberView.frame), SCREEN_WIDTH, 200);
    
    self.bottomGreenBtn.frame = CGRectMake(0, CGRectGetMaxY(self.person2ApplicationCodeView.frame) + 30, SCREEN_WIDTH, commonCellHeight - 5);
    self.person3NameView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomGreenBtn.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3CodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person3NameView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3PhoneView.frame = CGRectMake(0, CGRectGetMaxY(self.person3CodeView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3HourseNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.person3PhoneView.frame), SCREEN_WIDTH, commonCellHeight);
    self.person3ApplicationCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.person3HourseNumberView.frame), SCREEN_WIDTH, 200);
    
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
///** 地址选择 */
//- (void)addressClick {
//    [self.managerCardView.contentTF resignFirstResponder];
//    [self.addressPickerView showInView:self.view];
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.areaView.contentTF) {
        [self.areaView.contentTF resignFirstResponder];
        [self.addressPickerView showInView:self.view];
    }
}

- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger )index view:(nonnull UIView *)view {
    [self.person1HourseNumberView.contentTF resignFirstResponder];
    [self.person2HourseNumberView.contentTF resignFirstResponder];
    [self.person3HourseNumberView.contentTF resignFirstResponder];
    /** 选取图片 */
    self.selectTag = view.tag;
    self.selectIndex = index;
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}

#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
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
            if (self.selectTag == 1) {
                if (self.selectIndex == 1) {
                    self.person1CertificationView.leftImgView.image = image;
                    
                } else if (self.selectIndex == 2) {
                    self.person1CertificationView.centerImgView.image = image;
                    
                } else {
                    self.person1CertificationView.rightImgView.image = image;
                    
                }
            } else if (self.selectTag == 2) {
                if (self.selectIndex == 1) {
                    self.person2CertificationView.leftImgView.image = image;
                    
                } else if (self.selectIndex == 2) {
                    self.person2CertificationView.centerImgView.image = image;
                    
                } else {
                    self.person2CertificationView.rightImgView.image = image;
                    
                }
            } else {
                if (self.selectIndex == 1) {
                    self.person3CertificationView.leftImgView.image = image;
                    
                } else if (self.selectIndex == 2) {
                    self.person3CertificationView.centerImgView.image = image;
                    
                } else {
                    self.person3CertificationView.rightImgView.image = image;
                    
                }
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
    if (self.selectTag == 1) {
        if (self.selectIndex == 1) {
            self.person1CertificationView.leftImgView.image = image;
            
        } else if (self.selectIndex == 2) {
            self.person1CertificationView.centerImgView.image = image;
            
        } else {
            self.person1CertificationView.rightImgView.image = image;
            
        }
    } else if (self.selectTag == 2) {
        if (self.selectIndex == 1) {
            self.person2CertificationView.leftImgView.image = image;
            
        } else if (self.selectIndex == 2) {
            self.person2CertificationView.centerImgView.image = image;
            
        } else {
            self.person2CertificationView.rightImgView.image = image;
            
        }
    } else {
        if (self.selectIndex == 1) {
            self.person3CertificationView.leftImgView.image = image;
            
        } else if (self.selectIndex == 2) {
            self.person3CertificationView.centerImgView.image = image;
            
        } else {
            self.person3CertificationView.rightImgView.image = image;
            
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.personServiceDeskView.contentTF) {
        // 这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.personServiceDeskView.contentTF.text.length >= 16) {
            self.personServiceDeskView.contentTF.text = [textField.text substringToIndex:16];
            [self.view makeToast:@"业主服务平台名称不超过16个字"];
            return NO;
        }
    } else if (textField == self.serviceDeskNameTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.serviceDeskNameTF.text.length >= 16) {
            self.serviceDeskNameTF.text = [textField.text substringToIndex:16];
            [self.view makeToast:@"物业服务平台名称不超过16个字"];
            return NO;
        }
    }  else if (textField == self.cellNameView.contentTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.cellNameView.contentTF.text.length >= 16) {
            self.cellNameView.contentTF.text = [textField.text substringToIndex:16];
            [self.view makeToast:@"小区名称不超过16个字"];
            return NO;
        }
    }
    return YES;
}

- (void)submitBtnClick {
    /** 确认并提交 */
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
    self.selectIDCardsImgArrs = [[NSMutableArray alloc] init];
    if (self.person1CertificationView.leftImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person1CertificationView.leftImgView.image];
    }
    if (self.person1CertificationView.centerImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person1CertificationView.centerImgView.image];
    }
    if (self.person1CertificationView.rightImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person1CertificationView.rightImgView.image];
    }
    
    if (self.person2CertificationView.leftImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person2CertificationView.leftImgView.image];
    }
    if (self.person2CertificationView.centerImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person2CertificationView.centerImgView.image];
    }
    if (self.person2CertificationView.rightImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person2CertificationView.rightImgView.image];
    }
    
    if (self.person3CertificationView.leftImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person3CertificationView.leftImgView.image];
    }
    if (self.person3CertificationView.centerImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person3CertificationView.centerImgView.image];
    }
    if (self.person3CertificationView.rightImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.person3CertificationView.rightImgView.image];
    }
    
    if (self.selectIDCardsImgArrs.count < 9) {
        [self.view makeToast:@"请上传完所有图片信息"];
        return;
    }
    /** 判空 */
    
    if (self.personServiceDeskView.contentTF.text.length <= 0) {
        [self.view makeToast:self.personServiceDeskView.contentTF.placeholder];
        return;
    }
    if (self.serviceDeskNameTF.text.length <= 0) {
        [self.view makeToast:self.serviceDeskNameTF.placeholder];
        return;
    }
    if (self.cellNameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.cellNameView.contentTF.placeholder];
        return;
    }
    if (self.managerNameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.managerNameView.contentTF.placeholder];
        return;
    }
    if (self.managerCardView.contentTF.text.length <= 0) {
        [self.view makeToast:self.managerCardView.contentTF.placeholder];
        return;
    }
    if (self.managerCardView.contentTF.text.length < 18) {
        [self.view makeToast:@"身份证格式不正确,请重新填写"];
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
    if (self.areaView.contentTF.text.length <= 0) {
        [self.view makeToast:self.areaView.contentTF.placeholder];
        return;
    }
    if (self.addressView.contentTF.text.length <= 0) {
        [self.view makeToast:self.addressView.contentTF.placeholder];
        return;
    }
    
    
    if (self.person1NameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person1NameView.contentTF.placeholder];
        return;
    }
    if (self.person1CodeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person1CodeView.contentTF.placeholder];
        return;
    }
    if (self.person1PhoneView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person1PhoneView.contentTF.placeholder];
        return;
    }
    if (self.person1HourseNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person1HourseNumberView.contentTF.placeholder];
        return;
    }
    
    
    if (self.person2NameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person2NameView.contentTF.placeholder];
        return;
    }
    if (self.person2CodeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person2CodeView.contentTF.placeholder];
        return;
    }
    if (self.person2PhoneView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person2PhoneView.contentTF.placeholder];
        return;
    }
    if (self.person2HourseNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person2HourseNumberView.contentTF.placeholder];
        return;
    }
    
    
    if (self.person3NameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person3NameView.contentTF.placeholder];
        return;
    }
    if (self.person3CodeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person3CodeView.contentTF.placeholder];
        return;
    }
    if (self.person3PhoneView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person3PhoneView.contentTF.placeholder];
        return;
    }
    if (self.person3HourseNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.person3HourseNumberView.contentTF.placeholder];
        return;
    }
    
    
    WS(weakSelf);
    self.personNameArrs = [[NSMutableArray alloc] init];
    self.idNumberArrs = [[NSMutableArray alloc] init];
    self.phoneNumberArrs = [[NSMutableArray alloc] init];
    self.houseNumberArrs = [[NSMutableArray alloc] init];
    
    Account *account = [AccountStorage readAccount];
    [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    [self.personNameArrs addObject:self.person1NameView.contentTF.text];
    [self.personNameArrs addObject:self.person2NameView.contentTF.text];
    [self.personNameArrs addObject:self.person3NameView.contentTF.text];
    
    [self.idNumberArrs addObject:self.person1CodeView.contentTF.text];
    [self.idNumberArrs addObject:self.person2CodeView.contentTF.text];
    [self.idNumberArrs addObject:self.person3CodeView.contentTF.text];
    
    [self.phoneNumberArrs addObject:self.person1PhoneView.contentTF.text];
    [self.phoneNumberArrs addObject:self.person2PhoneView.contentTF.text];
    [self.phoneNumberArrs addObject:self.person3PhoneView.contentTF.text];
    
    [self.houseNumberArrs addObject:self.person1HourseNumberView.contentTF.text];
    [self.houseNumberArrs addObject:self.person2HourseNumberView.contentTF.text];
    [self.houseNumberArrs addObject:self.person3HourseNumberView.contentTF.text];
    
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.personServiceDeskView.contentTF.text,@"owner_name",
                               self.serviceDeskNameTF.text,@"property_name",
                               self.cellNameView.contentTF.text,@"cell_name",
                               self.managerNameView.contentTF.text,@"applyname",
                               self.managerCardView.contentTF.text,@"idcard",
                               self.province_id,@"province_id",
                               self.city_id,@"city_id",
                               self.area_id,@"area_id",
                               self.addressView.contentTF.text,@"detailedaddress",
                               self.phoneView.contentTF.text,@"phone",
                               self.mailView.contentTF.text,@"email",
                               self.price,@"total",
                               @(self.payType),@"type",
                               @"2",@"ordertype",
                               self.selectIDCardsImgArrs,@"file[]",
                                [NSJSONSerialization dataWithJSONObject:self.personNameArrs options:0 error:NULL],@"person_name",
                                [NSJSONSerialization dataWithJSONObject:self.idNumberArrs options:0 error:NULL],@"id_number",
                                [NSJSONSerialization dataWithJSONObject:self.phoneNumberArrs options:0 error:NULL],@"person_mobile",
                                [NSJSONSerialization dataWithJSONObject:self.houseNumberArrs options:0 error:NULL],@"house_num",
                               nil];
    
    [AFNetWorkTool uploadImagesWithUrl:@"owner/applyAccount" parameters:paramsDic image:self.selectIDCardsImgArrs success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1) {
            if (self.payType == 1) {
                /** 支付宝支付 */
                if ([responseObj[@"code"] integerValue] == 1) {
                    if (weakSelf.payType == 1) {
                        /** 支付宝支付 */
                        LeoPayManager *manager = [LeoPayManager getInstance];
                        WS(weakSelf);
                        [manager aliPayOrder: responseObj[@"data"] scheme:@"alisdkdemo" respBlock:^(NSInteger respCode, NSString *respMsg) {
                            [weakSelf.lodingHud hideAnimated:YES];
                            weakSelf.lodingHud = nil;
                            if (respCode == 0) {
                                /** 支付成功 */
                                WS(weakSelf);
                                [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"亲爱的用户您好：您的申请已经成功提交，社云平台会在1-3个工作日内完成审核，审核通过后将账号信息，以短信的形式发送到您的手机，请注意查收，谢谢。" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
                            } else {
                                [weakSelf.lodingHud hideAnimated:YES];
                                weakSelf.lodingHud = nil;
                                [self.view makeToast:respMsg];
                            }
                        }];
                    }
                } else {
                    [weakSelf.lodingHud hideAnimated:YES];
                    weakSelf.lodingHud = nil;
                    [self.view makeToast:responseObj[@"data"][@"msg"]];
                }
            } else if (self.payType == 2) {
                /** 微信支付 */
                if ([responseObj[@"code"] integerValue] == 1) {
                    LeoPayManager *manager = [LeoPayManager getInstance];
                    WS(weakSelf);
                    [manager wechatPayWithAppId:responseObj[@"data"][@"appid"] partnerId:responseObj[@"data"][@"partnerid"] prepayId:responseObj[@"data"][@"prepay_id"] package:responseObj[@"data"][@"package"] nonceStr:responseObj[@"data"][@"nonce_str"] timeStamp:responseObj[@"data"][@"timestamp"] sign:responseObj[@"data"][@"sign"] respBlock:^(NSInteger respCode, NSString *respMsg) {
                        [weakSelf.lodingHud hideAnimated:YES];
                        weakSelf.lodingHud = nil;
                        //处理支付结果
                        if (respCode == 0) {
                            /** 支付成功 */
                            WS(weakSelf);
                            [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"亲爱的用户您好：您的申请已经成功提交，社云平台会在1-3个工作日内完成审核，审核通过后将账号信息，以短信的形式发送到您的手机，请注意查收，谢谢。" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        } else {
                            [weakSelf.lodingHud hideAnimated:YES];
                            weakSelf.lodingHud = nil;
                            [self.view makeToast:respMsg];
                        }
                    }];
                } else {
                    [weakSelf.lodingHud hideAnimated:YES];
                    weakSelf.lodingHud = nil;
                    [self.view makeToast:responseObj[@"data"][@"msg"]];
                }
            }
        } else {
            [weakSelf.lodingHud hideAnimated:YES];
            weakSelf.lodingHud = nil;
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.lodingHud hideAnimated:YES];
        weakSelf.lodingHud = nil;
        [self.view makeToast:@"提交资料失败,请稍后重试"];
    }];
}

- (void)fh_selectPayTypeWIthTag:(NSInteger)selectType {
    /** 请求支付宝签名 */
    self.payType = selectType;
    [self commitAccountDataRequest];
}


#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak FHProprietaryAccountController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.submitBtn.userInteractionEnabled = YES;
    }];
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
        _personServiceDeskView.titleLabel.text = @"业主服务平台名称";
        _personServiceDeskView.contentTF.text = @"";
        _personServiceDeskView.contentTF.placeholder = @"请输入业主服务平台名称(限16字)";
        _personServiceDeskView.contentTF.delegate = self;
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
        _serviceDeskNameTF.text = @"";
        _serviceDeskNameTF.placeholder = @"请输入物业服务平台名称(限16字)";
        _serviceDeskNameTF.delegate = self;
    }
    return _serviceDeskNameTF;
}

- (FHAccountApplicationTFView *)cellNameView {
    if (!_cellNameView) {
        _cellNameView = [[FHAccountApplicationTFView alloc] init];
        _cellNameView.titleLabel.text = @"小区名称";
        _cellNameView.contentTF.placeholder = @"请输入小区名称(限16字)";
        _cellNameView.contentTF.delegate = self;
    }
    return _cellNameView;
}

- (FHAccountApplicationTFView *)managerNameView {
    if (!_managerNameView) {
        _managerNameView = [[FHAccountApplicationTFView alloc] init];
        _managerNameView.titleLabel.text = @"管理员姓名";
        _managerNameView.contentTF.delegate = self;
        _managerNameView.contentTF.placeholder = @"请输入管理员姓名";
    }
    return _managerNameView;
}

- (FHAccountApplicationTFView *)managerCardView {
    if (!_managerCardView) {
        _managerCardView = [[FHAccountApplicationTFView alloc] init];
        _managerCardView.titleLabel.text = @"管理员证件";
        _managerCardView.contentTF.delegate = self;
        _managerCardView.contentTF.placeholder = @"请输入管理员身份证号码";
    }
    return _managerCardView;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"管理员电话";
        _phoneView.contentTF.delegate = self;
        _phoneView.contentTF.placeholder = @"(手机)";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)mailView {
    if (!_mailView) {
        _mailView = [[FHAccountApplicationTFView alloc] init];
        _mailView.titleLabel.text = @"管理员邮箱(接收账号密码)";
        _mailView.contentTF.delegate = self;
        _mailView.contentTF.placeholder = @"请输入管理员邮箱";
    }
    return _mailView;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"所在区域";
        _areaView.contentTF.delegate = self;
        _areaView.contentTF.placeholder = @"请选择所在区域 >";
    }
    return _areaView;
}


- (FHAccountApplicationTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHAccountApplicationTFView alloc] init];
        _addressView.titleLabel.text = @"街道地址";
        _addressView.contentTF.delegate = self;
        _addressView.contentTF.placeholder = @"请输入街道地址(准确到门牌号)";
    }
    return _addressView;
}

- (UIButton *)topGreenBtn {
    if (!_topGreenBtn) {
        _topGreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topGreenBtn setTitle:@"联名申请业主1基本信息" forState:UIControlStateNormal];
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
        _person1NameView.titleLabel.text = @"真实姓名";
        _person1NameView.contentTF.delegate = self;
        _person1NameView.contentTF.placeholder = @"请输入真实姓名";
    }
    return _person1NameView;
}

- (FHAccountApplicationTFView *)person1CodeView {
    if (!_person1CodeView) {
        _person1CodeView = [[FHAccountApplicationTFView alloc] init];
        _person1CodeView.titleLabel.text = @"身份证号";
        _person1CodeView.contentTF.delegate = self;
        _person1CodeView.contentTF.placeholder = @"请输入身份证号";
    }
    return _person1CodeView;
}

- (FHAccountApplicationTFView *)person1PhoneView {
    if (!_person1PhoneView) {
        _person1PhoneView = [[FHAccountApplicationTFView alloc] init];
        _person1PhoneView.titleLabel.text = @"手机号码";
        _person1PhoneView.contentTF.delegate = self;
        _person1PhoneView.contentTF.placeholder = @"请输入手机号码";
        
    }
    return _person1PhoneView;
}

- (FHAccountApplicationTFView *)person1HourseNumberView {
    if (!_person1HourseNumberView) {
        _person1HourseNumberView = [[FHAccountApplicationTFView alloc] init];
        _person1HourseNumberView.titleLabel.text = @"业主房号";
        _person1HourseNumberView.contentTF.delegate = self;
        _person1HourseNumberView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        _person1HourseNumberView.contentTF.placeholder = @"请输入业主房号";
    }
    return _person1HourseNumberView;
}

- (FHPersonCodeView *)person1ApplicationCodeView {
    if (!_person1ApplicationCodeView) {
        _person1ApplicationCodeView = [[FHPersonCodeView alloc] init];
        _person1ApplicationCodeView.height = 200;
        _person1ApplicationCodeView.titleLabel.text = @"业主申请人身份证";
    }
    return _person1ApplicationCodeView;
}

- (FHAccountApplicationTFView *)person2NameView {
    if (!_person2NameView) {
        _person2NameView = [[FHAccountApplicationTFView alloc] init];
        _person2NameView.titleLabel.text = @"真实姓名";
        _person2NameView.contentTF.delegate = self;
        _person2NameView.contentTF.placeholder = @"请输入真实姓名";
    }
    return _person2NameView;
}

- (FHAccountApplicationTFView *)person2CodeView {
    if (!_person2CodeView) {
        _person2CodeView = [[FHAccountApplicationTFView alloc] init];
        _person2CodeView.titleLabel.text = @"身份证号";
        _person2CodeView.contentTF.delegate = self;
        _person2CodeView.contentTF.placeholder = @"请输入身份证号";
    }
    return _person2CodeView;
}

- (FHAccountApplicationTFView *)person2PhoneView {
    if (!_person2PhoneView) {
        _person2PhoneView = [[FHAccountApplicationTFView alloc] init];
        _person2PhoneView.titleLabel.text = @"手机号码";
        _person2PhoneView.contentTF.delegate = self;
        _person2PhoneView.contentTF.placeholder = @"请输入手机号码";
        
    }
    return _person2PhoneView;
}

- (FHAccountApplicationTFView *)person2HourseNumberView {
    if (!_person2HourseNumberView) {
        _person2HourseNumberView = [[FHAccountApplicationTFView alloc] init];
        _person2HourseNumberView.titleLabel.text = @"业主房号";
        _person2HourseNumberView.contentTF.delegate = self;
        _person2HourseNumberView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        _person2HourseNumberView.contentTF.placeholder = @"请输入业主房号";
    }
    return _person2HourseNumberView;
}

- (FHPersonCodeView *)person2ApplicationCodeView {
    if (!_person2ApplicationCodeView) {
        _person2ApplicationCodeView = [[FHPersonCodeView alloc] init];
        _person2ApplicationCodeView.height = 200;
        _person2ApplicationCodeView.titleLabel.text = @"业主申请人身份证";
    }
    return _person2ApplicationCodeView;
}

- (FHAccountApplicationTFView *)person3NameView {
    if (!_person3NameView) {
        _person3NameView = [[FHAccountApplicationTFView alloc] init];
        _person3NameView.titleLabel.text = @"真实姓名";
        _person3NameView.contentTF.delegate = self;
        _person3NameView.contentTF.placeholder = @"请输入真实姓名";
    }
    return _person3NameView;
}

- (FHAccountApplicationTFView *)person3CodeView {
    if (!_person3CodeView) {
        _person3CodeView = [[FHAccountApplicationTFView alloc] init];
        _person3CodeView.titleLabel.text = @"身份证号";
        _person3CodeView.contentTF.delegate = self;
        _person3CodeView.contentTF.placeholder = @"请输入身份证号";
    }
    return _person3CodeView;
}

- (FHAccountApplicationTFView *)person3PhoneView {
    if (!_person3PhoneView) {
        _person3PhoneView = [[FHAccountApplicationTFView alloc] init];
        _person3PhoneView.titleLabel.text = @"手机号码";
        _person3PhoneView.contentTF.delegate = self;
        _person3PhoneView.contentTF.placeholder = @"请输入手机号码";
        
    }
    return _person3PhoneView;
}

- (FHAccountApplicationTFView *)person3HourseNumberView {
    if (!_person3HourseNumberView) {
        _person3HourseNumberView = [[FHAccountApplicationTFView alloc] init];
        _person3HourseNumberView.titleLabel.text = @"业主房号";
        _person3HourseNumberView.contentTF.delegate = self;
        _person3HourseNumberView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        _person3HourseNumberView.contentTF.placeholder = @"请输入业主房号";
    }
    return _person3HourseNumberView;
}

- (FHPersonCodeView *)person3ApplicationCodeView {
    if (!_person3ApplicationCodeView) {
        _person3ApplicationCodeView = [[FHPersonCodeView alloc] init];
        _person3ApplicationCodeView.titleLabel.text = @"业主申请人身份证";
        _person3ApplicationCodeView.height = 200;
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
        _submitBtn.backgroundColor = HEX_COLOR(0x1296db);
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


- (FHCommonPaySelectView *)payView {
    if (!_payView) {
        self.payView = [[FHCommonPaySelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260) nowPrice:self.price oldPrice:self.open discounted:self.discount];
        _payView.delegate = self;
        self.payView.showType = @"";
    }
    FHAppDelegate *delegate  = (FHAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
    
    return _payView;
}


- (MBProgressHUD *)lodingHud{
    if (_lodingHud == nil) {
        _lodingHud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _lodingHud.mode = MBProgressHUDModeIndeterminate;
        _lodingHud.removeFromSuperViewOnHide = YES;
        _lodingHud.label.text = @"资料提交中...";
        [_lodingHud showAnimated:YES];
    }
    return _lodingHud;
}

@end
