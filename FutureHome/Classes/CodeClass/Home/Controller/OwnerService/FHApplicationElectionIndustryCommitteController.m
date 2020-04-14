//
//  FHApplicationElectionIndustryCommitteController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  选举服务申请界面

#import "FHApplicationElectionIndustryCommitteController.h"
#import "FHElectRepeatTFView.h"
#import "BRPlaceholderTextView.h"
#import "FHImageToolMethod.h"

@interface FHApplicationElectionIndustryCommitteController () <UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDActionSheetDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 姓名View */
@property (nonatomic, strong) FHElectRepeatTFView *nameView;
/** 年龄View */
@property (nonatomic, strong) FHElectRepeatTFView *ageView;
/** 性别 */
@property (nonatomic, strong) FHElectRepeatTFView *sexView;
/** 学历 */
@property (nonatomic, strong) FHElectRepeatTFView *xueliView;
/** 电话 */
@property (nonatomic, strong) FHElectRepeatTFView *phoneView;
/** 政治面貌 */
@property (nonatomic, strong) FHElectRepeatTFView *faceView;
/** 身份证号 */
@property (nonatomic, strong) FHElectRepeatTFView *cardView;
/** 居住地址View */
@property (nonatomic, strong) FHElectRepeatTFView *addressView;
/** 兼职全职View */
@property (nonatomic, strong) FHElectRepeatTFView *typeView;
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImageView;
/** 线 */
@property (nonatomic, strong) UIView *lineView;
/** 参选号码 */
@property (nonatomic, strong) UILabel *numberLabel;

/** 内容 */
@property (nonatomic, strong) UITextField *contentTF;
/** 最下面的View */
@property (nonatomic, strong) UIView *bigBottomView;
/** 大的线 */
@property (nonatomic, strong) UIView *bigLineView;
/** 基本情况 */
@property (nonatomic, strong) UILabel *normalLabel;
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;
/** 选择的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrs;
/** imgID */
@property (nonatomic, copy) NSString *imgID;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *sureBtn;


@end

@implementation FHApplicationElectionIndustryCommitteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    if (![self.titleString isEqualToString:@"选举人资料"]) {
        [self creatBottomBtn];
        [self getRequestData];
    } else {
        [self setDataWithModel:self.personModel];
    }
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.ageView];
    [self.scrollView addSubview:self.sexView];
    [self.scrollView addSubview:self.xueliView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.cardView];
    [self.scrollView addSubview:self.faceView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.typeView];
    [self.scrollView addSubview:self.headerImageView];
    [self.scrollView addSubview:self.lineView];
    [self.scrollView addSubview:self.numberLabel];
    [self.scrollView addSubview:self.contentTF];
    [self.scrollView addSubview:self.bigBottomView];
    [self.bigBottomView addSubview:self.bigLineView];
    [self.bigBottomView addSubview:self.normalLabel];
    [self.bigBottomView addSubview:self.businessDescriptionTextView];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 40.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50));
    self.nameView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, commonCellHeight);
    self.ageView.frame = CGRectMake(10, MaxY(self.nameView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.sexView.frame = CGRectMake(10, MaxY(self.ageView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.xueliView.frame = CGRectMake(10, MaxY(self.sexView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.phoneView.frame = CGRectMake(10, MaxY(self.xueliView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.cardView.frame = CGRectMake(10, MaxY(self.phoneView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.faceView.frame = CGRectMake(10, MaxY(self.cardView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.addressView.frame = CGRectMake(10, MaxY(self.faceView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.typeView.frame = CGRectMake(10, MaxY(self.addressView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.contentTF.frame = CGRectMake(10, MaxY(self.typeView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.bigBottomView.frame = CGRectMake(10, MaxY(self.contentTF) - 1, SCREEN_WIDTH - 20, 400);
    self.scrollView.contentSize = CGSizeMake(0, MaxY(self.bigBottomView) + MainSizeHeight + 20);
}

- (void)creatBottomBtn{
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    self.sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureBtn];
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

/** 获取以前的数据 */
- (void)getRequestData {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"owner_id",
                               self.pid,@"pid",
                               nil];
    [AFNetWorkTool get:@"owner/electorDetail" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.personModel = [FHCandidateListModel mj_objectWithKeyValues:responseObj[@"data"]];
            [weakSelf setDataWithModel:weakSelf.personModel];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)setDataWithModel:(FHCandidateListModel *)personModel {
    /** 数据赋值 */
    _personModel = personModel;
    self.phoneView.contentTF.text = _personModel.mobile;
    self.cardView.contentTF.text = _personModel.id_number;
    if ([self.phoneView.contentTF.text isEqualToString:@""]) {
        [self.sureBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
    } else {
        [self.sureBtn setTitle:@"编辑并提交" forState:UIControlStateNormal];
        self.nameView.contentTF.text = _personModel.name;
        self.ageView.contentTF.text = [NSString stringWithFormat:@"%ld",(long)personModel.age];
        self.sexView.contentTF.text = _personModel.getSex;
        self.xueliView.contentTF.text = _personModel.education;
        self.faceView.contentTF.text = _personModel.polity;
        self.addressView.contentTF.text = _personModel.home_num;
        self.typeView.contentTF.text = _personModel.getFull;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_personModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
        self.numberLabel.text = [NSString stringWithFormat:@"参选号: %@",_personModel.number];
        self.contentTF.text = [NSString stringWithFormat:@"   %@",_personModel.intro];
        self.businessDescriptionTextView.text = _personModel.describe;
        self.imgID = _personModel.img_ids;
    }
    
    if ([self.titleString isEqualToString:@"选举人资料"]) {
        CGSize size = [UIlabelTool sizeWithString:_personModel.describe font:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH - 20 - 98];
        CGFloat updateHeight = size.height + 50;
        self.businessDescriptionTextView.height = updateHeight;
        self.bigLineView.height = updateHeight;
        self.bigBottomView.frame = CGRectMake(10, MaxY(self.contentTF) - 1, SCREEN_WIDTH - 20, updateHeight);
        self.normalLabel.height = updateHeight;
        self.businessDescriptionTextView.scrollEnabled = NO;
        self.scrollView.contentSize = CGSizeMake(0, MaxY(self.bigBottomView) + MainSizeHeight + 20);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.contentTF) {
        // 这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.contentTF.text.length >= 20) {
            self.contentTF.text = [textField.text substringToIndex:20];
            [self.view makeToast:@"意愿不能超过20个字"];
            return NO;
        }
    } else if (textField == self.phoneView.contentTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.phoneView.contentTF.text.length >= 11) {
            self.phoneView.contentTF.text = [textField.text substringToIndex:11];
            [self.view makeToast:@"手机号不超过11位"];
            return NO;
        }
    }
    return YES;
}

- (void)sureBtnClick {
    /** 选举申请 */
    WS(weakSelf);
    if (self.nameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.nameView.contentTF.placeholder];
        return;
    }
    if (self.ageView.contentTF.text.length <= 0) {
        [self.view makeToast:self.ageView.contentTF.placeholder];
        return;
    }
    if (self.sexView.contentTF.text.length <= 0) {
        [self.view makeToast:self.sexView.contentTF.placeholder];
        return;
    }
    if (self.xueliView.contentTF.text.length <= 0) {
        [self.view makeToast:self.xueliView.contentTF.placeholder];
        return;
    }
    if (self.phoneView.contentTF.text.length <= 0) {
        [self.view makeToast:self.phoneView.contentTF.placeholder];
        return;
    }
    if (self.phoneView.contentTF.text.length < 11) {
        [self.view makeToast:@"手机号码格式不正确"];
        return;
    }
    if (self.cardView.contentTF.text.length < 18) {
        [self.view makeToast:@"身份证号码格式不正确"];
        return;
    }
    if (self.cardView.contentTF.text.length < 0) {
        [self.view makeToast:self.cardView.contentTF.placeholder];
        return;
    }
    if (self.faceView.contentTF.text.length <= 0) {
        [self.view makeToast:self.faceView.contentTF.placeholder];
        return;
    }
    if (self.addressView.contentTF.text.length <= 0) {
        [self.view makeToast:self.addressView.contentTF.placeholder];
        return;
    }
    if (self.typeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.typeView.contentTF.placeholder];
        return;
    }
    if (self.contentTF.text.length <= 0) {
        [self.view makeToast:self.contentTF.placeholder];
        return;
    }
    NSInteger sexType;
    if ([self.sexView.contentTF.text isEqualToString:@"男"]) {
        sexType = 1;
    } else if ([self.sexView.contentTF.text isEqualToString:@"女"]) {
        sexType = 2;
    } else {
        [self.view makeToast:@"请正确填写性别"];
        return;
    }
    NSInteger fullType;
    if ([self.typeView.contentTF.text isEqualToString:@"全职"]) {
        fullType = 1;
    } else if ([self.typeView.contentTF.text isEqualToString:@"兼职"]) {
        fullType = 2;
    } else {
        [self.view makeToast:@"请填写兼职/全职"];
        return;
    }
    
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf commitRequestWithSexType:sexType fullType:fullType];
        }
    }];
}

- (void)commitRequestWithSexType:(NSInteger )sexType
                        fullType:(NSInteger )fullType {
    WS(weakSelf);
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHud];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"owner_id",
                               self.nameView.contentTF.text,@"name",
                               self.ageView.contentTF.text,@"age",
                               @(sexType),@"sex",
                               self.xueliView.contentTF.text,@"education",
                               self.phoneView.contentTF.text,@"mobile",
                               self.cardView.contentTF.text,@"id_number",
                               self.faceView.contentTF.text,@"polity",
                               self.addressView.contentTF.text,@"home_num",
                               @(fullType),@"is_full",
                               self.contentTF.text,@"intro",
                               self.businessDescriptionTextView.text,@"describe",
                               self.pid,@"pid",
                               self.imgID,@"img_ids",
                               nil];
    
    [AFNetWorkTool post:@"owner/submitInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:@"申请信息已经提交"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf.navigationController popViewControllerAnimated:YES];
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

- (void)imgViewClick {
    if ([self.titleString isEqualToString:@"选举人资料"]) {
        [FHImageToolMethod showImage:self.headerImageView];
    } else {
        /** 选取图片 */
        FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
        [actionSheet addAnimation];
        [actionSheet show];
    }
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
            self.headerImageView.image = image;
            Account *account = [AccountStorage readAccount];
            NSArray *arr = @[@"111"];
            NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @(account.user_id),@"user_id",
                                       @"owner",@"path",
                                       arr,@"file[]",
                                       nil];
            
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
                self.imgID = [responseObj[@"data"] objectAtIndex:0];
            } failure:^(NSError *error) {
                
            }];
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
    self.headerImageView.image = image;
    Account *account = [AccountStorage readAccount];
    NSArray *arr = @[@"111"];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @"owner",@"path",
                               arr,@"file[]",
                               nil];
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
        self.imgID = [responseObj[@"data"] objectAtIndex:0];
    } failure:^(NSError *error) {
        
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHElectRepeatTFView *)nameView {
    if (!_nameView) {
        _nameView = [[FHElectRepeatTFView alloc] init];
        _nameView.titleLabel.text = @"姓名:";
        _nameView.contentTF.placeholder = @"请输入姓名";
        _nameView.contentTF.width = 130;
    }
    return _nameView;
}

- (FHElectRepeatTFView *)ageView {
    if (!_ageView) {
        _ageView = [[FHElectRepeatTFView alloc] init];
        _ageView.titleLabel.text = @"年龄:";
        _ageView.contentTF.placeholder = @"请输入年龄";
        _ageView.contentTF.width = 130;
    }
    return _ageView;
}

- (FHElectRepeatTFView *)sexView {
    if (!_sexView) {
        _sexView = [[FHElectRepeatTFView alloc] init];
        _sexView.titleLabel.text = @"性别:";
        _sexView.contentTF.placeholder = @"请输入性别";
        _sexView.contentTF.width = 130;
    }
    return _sexView;
}

- (FHElectRepeatTFView *)xueliView {
    if (!_xueliView) {
        _xueliView = [[FHElectRepeatTFView alloc] init];
        _xueliView.titleLabel.text = @"学历:";
        _xueliView.contentTF.placeholder = @"请选择学历";
        _xueliView.contentTF.width = 130;
    }
    return _xueliView;
}

- (FHElectRepeatTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHElectRepeatTFView alloc] init];
        _phoneView.titleLabel.text = @"电话:";
        _phoneView.contentTF.placeholder = @"请输入电话";
        _phoneView.contentTF.width = 130;
    }
    return _phoneView;
}

- (FHElectRepeatTFView *)cardView {
    if (!_cardView) {
        _cardView = [[FHElectRepeatTFView alloc] init];
        _cardView.titleLabel.text = @"身份证号";
        _cardView.contentTF.placeholder = @"请输入身份证号";
    }
    return _cardView;
}

- (FHElectRepeatTFView *)faceView {
    if (!_faceView) {
        _faceView = [[FHElectRepeatTFView alloc] init];
        _faceView.titleLabel.text = @"政治面貌";
        _faceView.contentTF.placeholder = @"请输入政治面貌";
    }
    return _faceView;
}

- (FHElectRepeatTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHElectRepeatTFView alloc] init];
        _addressView.titleLabel.text = @"居住地址:";
        _addressView.contentTF.placeholder = @"请输入居住地";
    }
    return _addressView;
}

- (FHElectRepeatTFView *)typeView {
    if (!_typeView) {
        _typeView = [[FHElectRepeatTFView alloc] init];
        _typeView.titleLabel.text = @"兼职/全职:";
        _typeView.contentTF.placeholder = @"请填写兼职/全职";
    }
    return _typeView;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 118 - 10, 10, 118, 118)];
        _headerImageView.image = [UIImage imageNamed:@"头像"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewClick)];
        _headerImageView.userInteractionEnabled = YES;
        [_headerImageView addGestureRecognizer:tap];
    }
    return _headerImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 117, MaxY(self.headerImageView),0.5, 40)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        if ([self.titleString isEqualToString:@"选举服务申请"]) {
            _lineView.hidden = YES;
        } else {
            _lineView.hidden = NO;
        }
    }
    return _lineView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 117, MaxY(self.headerImageView),118, 40)];
        _numberLabel.textColor = [UIColor redColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:13];
//        _numberLabel.text = @"参选号: 12号";
    }
    return _numberLabel;
}

- (UITextField *)contentTF {
    if (!_contentTF) {
        _contentTF = [[UITextField alloc] init];
        _contentTF.textAlignment = NSTextAlignmentLeft;
        _contentTF.font = [UIFont systemFontOfSize:13];
        _contentTF.placeholder = @"  一句话表达参选的意愿(限20字内)";
        _contentTF.layer.borderWidth = 1;
        _contentTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentTF.delegate = self;
    }
    return _contentTF;
}

- (UIView *)bigBottomView {
    if (!_bigBottomView) {
        _bigBottomView = [[UIView alloc] init];
        _bigBottomView.backgroundColor = [UIColor whiteColor];
        _bigBottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bigBottomView.layer.borderWidth = 1;
    }
    return _bigBottomView;
}

- (UIView *)bigLineView {
    if (!_bigLineView) {
        _bigLineView = [[UIView alloc] initWithFrame:CGRectMake(97.5, 0,0.5, 400)];
        _bigLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bigLineView;
}

- (UILabel *)normalLabel {
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,97, 400)];
        _normalLabel.textColor = [UIColor lightGrayColor];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        _normalLabel.font = [UIFont systemFontOfSize:15];
        _normalLabel.text = @"基本情况:";
    }
    return _normalLabel;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(98, 0, SCREEN_WIDTH - 20 - 98, 400)];
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor lightGrayColor];
        NSString *titleString = @" \n\n\n\n 请输入个人基本情况";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
}

@end
