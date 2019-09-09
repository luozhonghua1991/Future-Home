//
//  FHCarRentOrSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  车位出售或者出租

#import "FHCarRentOrSaleController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"

@interface FHCarRentOrSaleController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 标题View */
@property (nonatomic, strong) FHAccountApplicationTFView *titleView;
/** 车库楼层View */
@property (nonatomic, strong) FHAccountApplicationTFView *carHouseNumberView;
/** 出售价格 */
@property (nonatomic, strong) FHAccountApplicationTFView *salePriceView;
/** 车位号 */
@property (nonatomic, strong) FHAccountApplicationTFView *carNumberView;
/** 产权年限 */
@property (nonatomic, strong) FHAccountApplicationTFView *yearView;
/** 建筑时间 */
@property (nonatomic, strong) FHAccountApplicationTFView *buildTimeView;
/** 付款要求 */
@property (nonatomic, strong) FHAccountApplicationTFView *priceSugmentView;
/** 手机号 */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 接听时段 */
@property (nonatomic, strong) FHAccountApplicationTFView *callPhoneNumberView;
/** 其它补充信息 */
@property (nonatomic, strong) FHAccountApplicationTFView *otherInfoView;
/** 投诉建议textView */
@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;

@end

@implementation FHCarRentOrSaleController

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
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
    
    [self.scrollView addSubview:self.titleView];
    [self.scrollView addSubview:self.carHouseNumberView];
    [self.scrollView addSubview:self.salePriceView];
    [self.scrollView addSubview:self.carNumberView];
    [self.scrollView addSubview:self.yearView];
    [self.scrollView addSubview:self.buildTimeView];
    [self.scrollView addSubview:self.priceSugmentView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.callPhoneNumberView];
    [self.scrollView addSubview:self.otherInfoView];
    [self.scrollView addSubview:self.suggestionsTextView];
    
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.carHouseNumberView.frame = CGRectMake(0, MaxY(self.titleView), SCREEN_WIDTH, commonCellHeight);
    self.salePriceView.frame = CGRectMake(0, MaxY(self.carHouseNumberView), SCREEN_WIDTH, commonCellHeight);
    self.carNumberView.frame = CGRectMake(0, MaxY(self.salePriceView), SCREEN_WIDTH, commonCellHeight);
    self.yearView.frame = CGRectMake(0, MaxY(self.carNumberView), SCREEN_WIDTH, commonCellHeight);
    self.buildTimeView.frame = CGRectMake(0, MaxY(self.yearView), SCREEN_WIDTH, commonCellHeight);
    self.priceSugmentView.frame = CGRectMake(0, MaxY(self.buildTimeView), SCREEN_WIDTH, commonCellHeight);
    self.phoneNumberView.frame = CGRectMake(0, MaxY(self.priceSugmentView), SCREEN_WIDTH, commonCellHeight);
    self.callPhoneNumberView.frame = CGRectMake(0, MaxY(self.phoneNumberView), SCREEN_WIDTH, commonCellHeight);
    self.otherInfoView.frame = CGRectMake(0, MaxY(self.callPhoneNumberView), SCREEN_WIDTH, commonCellHeight);
    self.suggestionsTextView.frame = CGRectMake(0, MaxY(self.otherInfoView), SCREEN_WIDTH, 150);
    [self updateViewsFrame];
}

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    [self updatePickerViewFrameY:MaxY(self.suggestionsTextView)];
    self.scrollView.contentSize = CGSizeMake(0, MaxY(self.suggestionsTextView) + [self getPickerViewFrame].size.height + MainSizeHeight + 20);
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

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"提交发布" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

#pragma mark — event
- (void)sureBtnClick {
    /** 确定 */
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)titleView {
    if (!_titleView) {
        _titleView = [[FHAccountApplicationTFView alloc] init];
        _titleView.titleLabel.text = @"标题信息";
        _titleView.contentTF.placeholder = @"请输入标题信息";
    }
    return _titleView;
}

- (FHAccountApplicationTFView *)carHouseNumberView {
    if (!_carHouseNumberView) {
        _carHouseNumberView = [[FHAccountApplicationTFView alloc] init];
        _carHouseNumberView.titleLabel.text = @"车库楼层";
        _carHouseNumberView.contentTF.placeholder = @"请输入车库楼层";
    }
    return _carHouseNumberView;
}

- (FHAccountApplicationTFView *)salePriceView {
    if (!_salePriceView) {
        _salePriceView = [[FHAccountApplicationTFView alloc] init];
        _salePriceView.titleLabel.text = @"出售价格";
        _salePriceView.contentTF.placeholder = @"请输入出售价格(元)";
    }
    return _salePriceView;
}

- (FHAccountApplicationTFView *)carNumberView {
    if (!_carNumberView) {
        _carNumberView = [[FHAccountApplicationTFView alloc] init];
        _carNumberView.titleLabel.text = @"车位号";
        _carNumberView.contentTF.placeholder = @"请输入车位号";
    }
    return _carNumberView;
}

- (FHAccountApplicationTFView *)yearView {
    if (!_yearView) {
        _yearView = [[FHAccountApplicationTFView alloc] init];
        _yearView.titleLabel.text = @"产权年限";
        _yearView.contentTF.placeholder = @"请输入产权年限";
    }
    return _yearView;
}

- (FHAccountApplicationTFView *)buildTimeView {
    if (!_buildTimeView) {
        _buildTimeView = [[FHAccountApplicationTFView alloc] init];
        _buildTimeView.titleLabel.text = @"建筑时间";
        _buildTimeView.contentTF.placeholder = @"请输入建筑时间(xxxx年xx月)";
    }
    return _buildTimeView;
}

- (FHAccountApplicationTFView *)priceSugmentView {
    if (!_priceSugmentView) {
        _priceSugmentView = [[FHAccountApplicationTFView alloc] init];
        _priceSugmentView.titleLabel.text = @"付款要求";
        _priceSugmentView.contentTF.placeholder = @"请输入付款要求";
    }
    return _priceSugmentView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"联系电话";
        _phoneNumberView.contentTF.placeholder = @"请输入联系电话";
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)callPhoneNumberView {
    if (!_callPhoneNumberView) {
        _callPhoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _callPhoneNumberView.titleLabel.text = @"接听时段";
        _callPhoneNumberView.contentTF.placeholder = @"请输入接听时段(09:00-22:00)";
    }
    return _callPhoneNumberView;
}

- (FHAccountApplicationTFView *)otherInfoView {
    if (!_otherInfoView) {
        _otherInfoView = [[FHAccountApplicationTFView alloc] init];
        _otherInfoView.titleLabel.text = @"其它补充信息";
        _otherInfoView.contentTF.enabled = NO;
        _otherInfoView.bottomLineView.hidden = YES;
    }
    return _otherInfoView;
}

- (BRPlaceholderTextView *)suggestionsTextView {
    if (!_suggestionsTextView) {
        _suggestionsTextView = [[BRPlaceholderTextView alloc] init];
        _suggestionsTextView.layer.borderWidth = 1;
        _suggestionsTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _suggestionsTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _suggestionsTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"请输入其它需要补充的信息......";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _suggestionsTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _suggestionsTextView;
}



//
//@interface FHHousingRentOrSaleController () <UITextFieldDelegate,UIScrollViewDelegate>
//
///** 产权年限 */
//@property (nonatomic, strong) FHAccountApplicationTFView *yearView;
///** 建筑时间 */
//@property (nonatomic, strong) FHAccountApplicationTFView *buildTimeView;
///** 手机号 */
//@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
///** 接听时段 */
//@property (nonatomic, strong) FHAccountApplicationTFView *callPhoneNumberView;
///** 其它补充信息 */
//@property (nonatomic, strong) FHAccountApplicationTFView *otherInfoView;
///** 投诉建议textView */
//@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;
//
//@end
//
//@implementation FHHousingRentOrSaleController




@end