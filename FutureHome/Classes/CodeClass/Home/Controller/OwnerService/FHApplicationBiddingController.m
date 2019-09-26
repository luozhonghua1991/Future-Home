//
//  FHApplicationBiddingController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  申请招标物业服务

#import "FHApplicationBiddingController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"

@interface FHApplicationBiddingController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *nameView;
/** 职位View */
@property (nonatomic, strong) FHAccountApplicationTFView *typeView;
/** 登记View */
@property (nonatomic, strong) FHAccountApplicationTFView *levealView;
/** 电话View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneView;
/** 公司名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *companyNameView;
/** 信用代码View */
@property (nonatomic, strong) FHAccountApplicationTFView *xinCodeView;
/** 公司地址View */
@property (nonatomic, strong) FHAccountApplicationTFView *companyAddressView;
/** 邮箱View */
@property (nonatomic, strong) FHAccountApplicationTFView *emailView;
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;
/** 提示语 */
@property (nonatomic, strong) UILabel *logoLabel;
/** 确认并提交 */
@property (nonatomic, strong) UIButton *submitBtn;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** 服务器返回的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrays;

@end

@implementation FHApplicationBiddingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"申请物业招标";
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
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.typeView];
    [self.scrollView addSubview:self.levealView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.companyNameView];
    [self.scrollView addSubview:self.xinCodeView];
    [self.scrollView addSubview:self.companyAddressView];
    [self.scrollView addSubview:self.emailView];
    [self.scrollView addSubview:self.businessDescriptionTextView];
    [self.scrollView addSubview:self.logoLabel];
    /** 确认并提交按钮 */
    [self.scrollView addSubview:self.submitBtn];
    
}

#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.nameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.typeView.frame = CGRectMake(0, MaxY(self.nameView), SCREEN_WIDTH, commonCellHeight);
    self.levealView.frame = CGRectMake(0, MaxY(self.typeView), SCREEN_WIDTH, commonCellHeight);
    self.phoneView.frame = CGRectMake(0, MaxY(self.levealView), SCREEN_WIDTH, commonCellHeight);
    self.companyNameView.frame = CGRectMake(0, MaxY(self.phoneView), SCREEN_WIDTH, commonCellHeight);
    self.xinCodeView.frame = CGRectMake(0, MaxY(self.companyNameView), SCREEN_WIDTH, commonCellHeight);
    self.companyAddressView.frame = CGRectMake(0, MaxY(self.xinCodeView), SCREEN_WIDTH, commonCellHeight);
    self.emailView.frame = CGRectMake(0, MaxY(self.companyAddressView), SCREEN_WIDTH, commonCellHeight);
    self.businessDescriptionTextView.frame = CGRectMake(5, MaxY(self.emailView), SCREEN_WIDTH - 10, 300);
    self.logoLabel.frame = CGRectMake(5, MaxY(self.businessDescriptionTextView) + 5, SCREEN_WIDTH - 10, 15);
    [self updateViewsFrame];
}

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    [self updatePickerViewFrameY:CGRectGetMaxY(self.logoLabel.frame)];
    self.submitBtn.frame = CGRectMake(0, MaxY(self.logoLabel) + [self getPickerViewFrame].size.height + 20, 160, 55);
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


#pragma mark — event
- (void)sureBtnClick {
    /** 提交发布信息 */
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
    self.selectImgArrays = [[NSMutableArray alloc] init];
    /** 先上传多张图片*/
    Account *account = [AccountStorage readAccount];
    NSString *string = [self getCurrentTimes];
    NSArray *arr = @[string];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @"property",@"path",
                               arr,@"file[]",
                               nil];
    for (int i = 0; i < self.imgSelectArrs.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(self.imgSelectArrs[i],1);
        [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
            NSArray *arr = responseObj[@"data"];
            if (!IS_NULL_ARRAY(arr)) {
                NSString *imgID = [arr objectAtIndex:0];
                [self.selectImgArrays addObject:imgID];
                if (self.selectImgArrays.count == self.imgSelectArrs.count) {
                    /** 图片获取完毕 */
                    [self commitInfo];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
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


- (void)commitInfo {
    /** 先传图片 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *imgArrsString = [self.selectImgArrays componentsJoinedByString:@","];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"owner_id",
                               self.nameView.contentTF.text,@"name",
                               self.typeView.contentTF.text,@"position",
                               self.levealView.contentTF.text,@"mobile",
                               self.companyNameView.contentTF.text,@"com_name",
                               self.phoneView.contentTF.text,@"grade",
                               self.xinCodeView.contentTF.text,@"credit_code",
                               self.companyAddressView.contentTF.text,@"address",
                               self.emailView.contentTF.text,@"e_mail",
                               self.businessDescriptionTextView.text,@"describe",
                               imgArrsString,@"img_ids",
                               nil];
    [AFNetWorkTool post:@"owner/applyTender" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 申请资料已经提交 */
            [weakSelf.view makeToast:@"申请资料已经提交"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)nameView {
    if (!_nameView) {
        _nameView = [[FHAccountApplicationTFView alloc] init];
        _nameView.titleLabel.text = @"申请人姓名:";
        _nameView.contentTF.placeholder = @"请输入申请人姓名";
    }
    return _nameView;
}

- (FHAccountApplicationTFView *)typeView {
    if (!_typeView) {
        _typeView = [[FHAccountApplicationTFView alloc] init];
        _typeView.titleLabel.text = @"申请人职位:";
        _typeView.contentTF.placeholder = @"请输入申请人职位";
    }
    return _typeView;
}

- (FHAccountApplicationTFView *)levealView {
    if (!_levealView) {
        _levealView = [[FHAccountApplicationTFView alloc] init];
        _levealView.titleLabel.text = @"申请人电话:";
        _levealView.contentTF.placeholder = @"请输入申请人电话";
    }
    return _levealView;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"公司资质等级";
        _phoneView.contentTF.placeholder = @"请输入公司资质等级";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)companyNameView {
    if (!_companyNameView) {
        _companyNameView = [[FHAccountApplicationTFView alloc] init];
        _companyNameView.titleLabel.text = @"公司名称:";
        _companyNameView.contentTF.placeholder = @"请输入公司名称";
    }
    return _companyNameView;
}

- (FHAccountApplicationTFView *)xinCodeView {
    if (!_xinCodeView) {
        _xinCodeView = [[FHAccountApplicationTFView alloc] init];
        _xinCodeView.titleLabel.text = @"信用代码:";
        _xinCodeView.contentTF.placeholder = @"请输入信用代码";
    }
    return _xinCodeView;
}

- (FHAccountApplicationTFView *)companyAddressView {
    if (!_companyAddressView) {
        _companyAddressView = [[FHAccountApplicationTFView alloc] init];
        _companyAddressView.titleLabel.text = @"公司地址:";
        _companyAddressView.contentTF.placeholder = @"请输入公司地址";
    }
    return _companyAddressView;
}

- (FHAccountApplicationTFView *)emailView {
    if (!_emailView) {
        _emailView = [[FHAccountApplicationTFView alloc] init];
        _emailView.titleLabel.text = @"邮箱:";
        _emailView.contentTF.placeholder = @"请输入邮箱";
    }
    return _emailView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.text = @"请上传营业执照等相关证照";
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:13];
    }
    return _logoLabel;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] init];
        _businessDescriptionTextView.layer.borderWidth = 1;
        _businessDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"公司基本情况";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
