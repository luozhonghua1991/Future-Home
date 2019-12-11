//
//  FHReturnRefundController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  退货退款

#import "FHReturnRefundController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"

@interface FHReturnRefundController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 就诊时间View */
@property (nonatomic, strong) FHAccountApplicationTFView *dateView;
/** 医院View */
@property (nonatomic, strong) FHAccountApplicationTFView *hospitalView;
/** 总消费 */
@property (nonatomic, strong) FHAccountApplicationTFView *allPriceView;
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

@end

@implementation FHReturnRefundController

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
    titleLabel.text = @"退货退款";
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
    [self.scrollView addSubview:self.dateView];
    [self.scrollView addSubview:self.hospitalView];
    [self.scrollView addSubview:self.allPriceView];
    [self.scrollView addSubview:self.businessDescriptionTextView];
    self.scrollView.delegate = self;
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
}

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.hospitalView.frame = CGRectMake(0, MaxY(self.dateView), SCREEN_WIDTH, commonCellHeight);
    self.allPriceView.frame = CGRectMake(0, MaxY(self.hospitalView), SCREEN_WIDTH, commonCellHeight);
    self.businessDescriptionTextView.frame = CGRectMake(10, MaxY(self.allPriceView), SCREEN_WIDTH - 20, 150);
    [self updatePickerViewFrameY:MaxY(self.businessDescriptionTextView)];
    self.scrollView.contentSize = CGSizeMake(0, [self getPickerViewFrame].size.height + MainSizeHeight + 20);
}

- (void)sureBtnClick {
    //显示加载视图
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
    [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.orderID,@"order_id",
                               @(self.type),@"type",
                               self.imgSelectArrs,@"file[]",
                               self.businessDescriptionTextView.text,@"reason",
                               nil];
    
    [AFNetWorkTool uploadImagesWithUrl:@"shop/returnsales" parameters:paramsDic image:self.imgSelectArrs success:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1) {
            [self.lodingHud hideAnimated:YES];
            self.lodingHud = nil;
            [weakSelf.view makeToast:@"申请退货退款成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self.lodingHud hideAnimated:YES];
            self.lodingHud = nil;
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.lodingHud hideAnimated:YES];
        self.lodingHud = nil;
    }];
}

- (void)birthClick {
    [ZJNormalPickerView zj_showStringPickerWithTitle:@"申请类型" dataSource:@[
                                                                          @"无需退货,只退款",
                                                                          @"需要退货,并退款",
                                                                          @"需要退货,并换货",
                                                                          @"无需退款,需售后"] defaultSelValue:@"" isAutoSelect: NO resultBlock:^(id selectValue, NSInteger index) {
                                                                              self.dateView.contentTF.text = [NSString stringWithFormat:@"%@ >",selectValue];
                                                                              self.type = index + 1;
        NSLog(@"index---%ld",index);
        
    } cancelBlock:^{
        
    }];
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)dateView {
    if (!_dateView) {
        _dateView = [[FHAccountApplicationTFView alloc] init];
        _dateView.titleLabel.text = @"申请类型";
        _dateView.contentTF.placeholder = @"请选择退货类型 >";
        
        _dateView.contentTF.enabled = NO;
        _dateView.contentTF.userInteractionEnabled = YES;
        _dateView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthClick)];
        [_dateView addGestureRecognizer:tap];
    }
    return _dateView;
}

- (FHAccountApplicationTFView *)hospitalView {
    if (!_hospitalView) {
        _hospitalView = [[FHAccountApplicationTFView alloc] init];
        _hospitalView.titleLabel.text = @"退款金额";
        _hospitalView.contentTF.placeholder = self.totolePrice;
        _hospitalView.contentTF.enabled = NO;
    }
    return _hospitalView;
}

- (FHAccountApplicationTFView *)allPriceView {
    if (!_allPriceView) {
        _allPriceView = [[FHAccountApplicationTFView alloc] init];
        _allPriceView.titleLabel.text = @"退还原因";
        _allPriceView.contentTF.placeholder = @"";
        _allPriceView.contentTF.enabled = NO;
        
    }
    return _allPriceView;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] init];
        _businessDescriptionTextView.layer.borderWidth = 1;
        _businessDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"请输入退还原因...";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:0 legth:titleString.length]];
        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
}

- (MBProgressHUD *)lodingHud{
    if (_lodingHud == nil) {
        _lodingHud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _lodingHud.mode = MBProgressHUDModeIndeterminate;
        _lodingHud.removeFromSuperViewOnHide = YES;
        _lodingHud.label.text = @"申请提交中...请稍后";
        [_lodingHud showAnimated:YES];
    }
    return _lodingHud;
}

@end
