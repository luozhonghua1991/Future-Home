//
//  FHHousingRentOrSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  房屋出售/出租界面

#import "FHHousingRentOrSaleController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"

@interface FHHousingRentOrSaleController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 标题View */
@property (nonatomic, strong) FHAccountApplicationTFView *titleView;
/** 房屋户型View */
@property (nonatomic, strong) FHAccountApplicationTFView *houseTypeView;
/** 出售价格 */
@property (nonatomic, strong) FHAccountApplicationTFView *salePriceView;
/** 付款要求 */
@property (nonatomic, strong) FHAccountApplicationTFView *priceSugmentView;
/** 装修情况 */
@property (nonatomic, strong) FHAccountApplicationTFView *fixturesView;
/** 建筑面积 */
@property (nonatomic, strong) FHAccountApplicationTFView *areaView;
/** 房屋朝向View */
@property (nonatomic, strong) FHAccountApplicationTFView *houseDirectionView;
/** 房屋类型View */
@property (nonatomic, strong) FHAccountApplicationTFView *houseingTypeView;
/** 楼房房号 */
@property (nonatomic, strong) FHAccountApplicationTFView *houseNumberView;
/** 产权年限 */
@property (nonatomic, strong) FHAccountApplicationTFView *yearView;
/** 建筑时间 */
@property (nonatomic, strong) FHAccountApplicationTFView *buildTimeView;
/** 手机号 */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 接听时段 */
@property (nonatomic, strong) FHAccountApplicationTFView *callPhoneNumberView;
/** 其它补充信息 */
@property (nonatomic, strong) FHAccountApplicationTFView *otherInfoView;
/** 投诉建议textView */
@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;

@end

@implementation FHHousingRentOrSaleController

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
    [self.scrollView addSubview:self.houseTypeView];
    [self.scrollView addSubview:self.salePriceView];
    [self.scrollView addSubview:self.priceSugmentView];
    [self.scrollView addSubview:self.fixturesView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.houseDirectionView];
    [self.scrollView addSubview:self.houseingTypeView];
    [self.scrollView addSubview:self.houseNumberView];
    [self.scrollView addSubview:self.yearView];
    [self.scrollView addSubview:self.buildTimeView];
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
    self.houseTypeView.frame = CGRectMake(0, MaxY(self.titleView), SCREEN_WIDTH, commonCellHeight);
    self.salePriceView.frame = CGRectMake(0, MaxY(self.houseTypeView), SCREEN_WIDTH, commonCellHeight);
    self.priceSugmentView.frame = CGRectMake(0, MaxY(self.salePriceView), SCREEN_WIDTH, commonCellHeight);
    self.fixturesView.frame = CGRectMake(0, MaxY(self.priceSugmentView), SCREEN_WIDTH, commonCellHeight);
    self.areaView.frame = CGRectMake(0, MaxY(self.fixturesView), SCREEN_WIDTH, commonCellHeight);
    self.houseDirectionView.frame = CGRectMake(0, MaxY(self.areaView), SCREEN_WIDTH, commonCellHeight);
    self.houseingTypeView.frame = CGRectMake(0, MaxY(self.houseDirectionView), SCREEN_WIDTH, commonCellHeight);
    self.houseNumberView.frame = CGRectMake(0, MaxY(self.houseingTypeView), SCREEN_WIDTH, commonCellHeight);
    self.yearView.frame = CGRectMake(0, MaxY(self.houseNumberView), SCREEN_WIDTH, commonCellHeight);
    self.buildTimeView.frame = CGRectMake(0, MaxY(self.yearView), SCREEN_WIDTH, commonCellHeight);
    self.phoneNumberView.frame = CGRectMake(0, MaxY(self.buildTimeView), SCREEN_WIDTH, commonCellHeight);
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

- (FHAccountApplicationTFView *)houseTypeView {
    if (!_houseTypeView) {
        _houseTypeView = [[FHAccountApplicationTFView alloc] init];
        _houseTypeView.titleLabel.text = @"房屋户型";
        _houseTypeView.contentTF.placeholder = @"请输入房屋户型";
    }
    return _houseTypeView;
}

- (FHAccountApplicationTFView *)salePriceView {
    if (!_salePriceView) {
        _salePriceView = [[FHAccountApplicationTFView alloc] init];
        _salePriceView.titleLabel.text = @"出售价格";
        _salePriceView.contentTF.placeholder = @"请输入出售价格(元)";
    }
    return _salePriceView;
}

- (FHAccountApplicationTFView *)priceSugmentView {
    if (!_priceSugmentView) {
        _priceSugmentView = [[FHAccountApplicationTFView alloc] init];
        _priceSugmentView.titleLabel.text = @"付款要求";
        _priceSugmentView.contentTF.placeholder = @"请输入付款要求";
    }
    return _priceSugmentView;
}

- (FHAccountApplicationTFView *)fixturesView {
    if (!_fixturesView) {
        _fixturesView = [[FHAccountApplicationTFView alloc] init];
        _fixturesView.titleLabel.text = @"装修情况";
        _fixturesView.contentTF.placeholder = @"请输入装修情况";
    }
    return _fixturesView;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"建筑面积";
        _areaView.contentTF.placeholder = @"请输入建筑面积";
    }
    return _areaView;
}

- (FHAccountApplicationTFView *)houseDirectionView {
    if (!_houseDirectionView) {
        _houseDirectionView = [[FHAccountApplicationTFView alloc] init];
        _houseDirectionView.titleLabel.text = @"房屋朝向";
        _houseDirectionView.contentTF.placeholder = @"请输入房屋朝向";
    }
    return _houseDirectionView;
}

- (FHAccountApplicationTFView *)houseingTypeView {
    if (!_houseingTypeView) {
        _houseingTypeView = [[FHAccountApplicationTFView alloc] init];
        _houseingTypeView.titleLabel.text = @"房屋类型";
        _houseingTypeView.contentTF.placeholder = @"请输入房屋类型";
    }
    return _houseingTypeView;
}

- (FHAccountApplicationTFView *)houseNumberView {
    if (!_houseNumberView) {
        _houseNumberView = [[FHAccountApplicationTFView alloc] init];
        _houseNumberView.titleLabel.text = @"楼层房号";
        _houseNumberView.contentTF.placeholder = @"请输入楼层房号";
    }
    return _houseNumberView;
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

@end
