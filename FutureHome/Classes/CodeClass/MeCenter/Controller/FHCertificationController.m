//
//  FHCertificationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  实名认证

#import "FHCertificationController.h"
#import "FHUserAgreementView.h"
#import "FHCertificationView.h"
#import "FHCertificationImgView.h"
#import "FHWebViewController.h"

@interface FHCertificationController () <FHUserAgreementViewDelegate,UITextFieldDelegate,FHCertificationImgViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 上面的label提示 */
@property (nonatomic, strong) UILabel *topLabel;
/** 同意协议View */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** 真实姓名 */
@property (nonatomic, strong) FHCertificationView *trueNameView;
/** 身份证件号 */
@property (nonatomic, strong) FHCertificationView *personCodeView;
/** 用来上传图片用的View */
@property (nonatomic, strong) FHCertificationImgView *imgView;
/** 提交按钮 */
@property (nonatomic, strong) UIButton *submitBtn;
/** 选择的是第几个 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 选择的ID cards 图片数组 */
@property (nonatomic, strong) NSMutableArray *selectIDCardsImgArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectCount;
/** 服务器返回的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrays;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

@end

@implementation FHCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectCount = 0;
    self.selectIDCardsImgArrs = [[NSMutableArray alloc] init];
    [self fh_creatNav];
    [self fh_creatUI];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES; self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"实名认证";
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
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.topLabel];
    [self.scrollView addSubview:self.trueNameView];
    [self.scrollView addSubview:self.personCodeView];
    [self.scrollView addSubview:self.imgView];
    self.imgView.changeTitleLabel.text = @"手持证件合影照/单位营业执照";
    self.imgView.changeTitleLabel.height = 35;
    [self.scrollView addSubview:self.agreementView];
    
    self.submitBtn.centerX = self.view.width / 2;
    [self.scrollView addSubview:self.submitBtn];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark — event
- (void)submitBtnClick {
    if (self.selectCount % 2 == 0) {
        [self.view makeToast:@"请同意用户信息授权协议"];
        return;
    }
    
    /** 先加一个弹框提示 */
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf commitAccountDataRequest];
        }
    }];
}

//获取当前的时间

- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

- (void)commitAccountDataRequest {
    /** 添加成员接口 */
    [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    /**先上传图片 在进行认证**/
    self.selectImgArrays = [[NSMutableArray alloc] init];
    /** 先上传多张图片*/
    Account *account = [AccountStorage readAccount];
    NSString *string = [self getCurrentTimes];
    NSArray *arr = @[string];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @"app",@"path",
                               arr,@"file[]",
                               nil];

    for (int i = 0; i< self.selectIDCardsImgArrs.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(self.selectIDCardsImgArrs[i],1);
        [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
            NSString *imgID = [responseObj[@"data"] objectAtIndex:0];
            [self.selectImgArrays addObject:imgID];
            if (self.selectImgArrays.count == self.selectIDCardsImgArrs.count) {
                /** 图片获取完毕 */
                [self commitInfo];
            }
        } failure:^(NSError *error) {

        }];
    }
}

- (void)commitInfo {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *imgArrsString = [self.selectImgArrays componentsJoinedByString:@","];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.trueNameView.contentTF.text,@"real_name",
                               self.personCodeView.contentTF.text,@"id_number",
                               imgArrsString,@"img_ids",
                               nil];
    [AFNetWorkTool post:@"userCenter/realName" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.lodingHud hideAnimated:YES];
            weakSelf.lodingHud = nil;
            [weakSelf.view makeToast:@"实名认证已经提交"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
            [weakSelf.lodingHud hideAnimated:YES];
            weakSelf.lodingHud = nil;
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark — delegate
- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger)index {
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
                self.imgView.leftImgView.image = image;
                [self.selectIDCardsImgArrs addObject:image];
            } else if (self.selectIndex == 2) {
                self.imgView.centerImgView.image = image;
                [self.selectIDCardsImgArrs addObject:image];
            } else {
                self.imgView.rightImgView.image = image;
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
        self.imgView.leftImgView.image = image;
        [self.selectIDCardsImgArrs addObject:image];
    } else if (self.selectIndex == 2) {
        self.imgView.centerImgView.image = image;
        [self.selectIDCardsImgArrs addObject:image];
    } else {
        self.imgView.rightImgView.image = image;
        [self.selectIDCardsImgArrs addObject:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


/** 跳转协议 */
- (void)FHUserAgreementViewClick {
    FHWebViewController *web = [[FHWebViewController alloc] init];
//    web.urlString = self.protocol;
    web.typeString = @"information";
    web.hidesBottomBarWhenPushed = YES;
    web.type = @"noShow";
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


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollView;
}


- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 35)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor = HEX_COLOR(0x919191);
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.numberOfLines = 0;
        _topLabel.text = @"个人实名认证：个人请上传身份证正面/背面/手持身份证的合影照；\n 单位实名认证：请上传认证负责人身份证正面/反面/单位营业执照，";
    }
    return _topLabel;
}

- (FHCertificationView *)trueNameView {
    if (!_trueNameView) {
        _trueNameView = [[FHCertificationView  alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(self.topLabel.frame) + 10, SCREEN_WIDTH - 6, 60)];
        _trueNameView.contentTF.delegate = self;
        _trueNameView.logoLabel.text = @"个人姓名/单位名称";
        _trueNameView.contentTF.placeholder = @"请输入真实姓名";
    }
    return _trueNameView;
}

- (FHCertificationView *)personCodeView {
    if (!_personCodeView) {
        _personCodeView = [[FHCertificationView  alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(self.trueNameView.frame) + 25, SCREEN_WIDTH - 6, 60)];
        _personCodeView.contentTF.delegate = self;
        _personCodeView.logoLabel.text = @"身份证件号/信用代码：";
        _personCodeView.contentTF.placeholder = @"请输入身份证号码";
    }
    return _personCodeView;
}

- (FHCertificationImgView *)imgView {
    if (!_imgView) {
        _imgView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.personCodeView.frame) + 100 , SCREEN_WIDTH, 120)];
        _imgView.delegate = self;
    }
    return _imgView;
}

- (FHUserAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[FHUserAgreementView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame) + 120 , SCREEN_WIDTH, 15)];
        _agreementView.delegate = self;
    }
    return _agreementView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
        _submitBtn.backgroundColor = HEX_COLOR(0x1296db);
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + MainSizeHeight + 20);
    }
    return _submitBtn;
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
