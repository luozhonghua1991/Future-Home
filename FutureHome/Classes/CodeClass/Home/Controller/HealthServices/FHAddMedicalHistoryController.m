//
//  FHAddMedicalHistoryController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHAddMedicalHistoryController.h"
#import "FHAccountApplicationTFView.h"

@interface FHAddMedicalHistoryController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 就诊时间View */
@property (nonatomic, strong) FHAccountApplicationTFView *dateView;
/** 医院View */
@property (nonatomic, strong) FHAccountApplicationTFView *hospitalView;
/** 总消费 */
@property (nonatomic, strong) FHAccountApplicationTFView *allPriceView;
/** 主治医师 */
@property (nonatomic, strong) FHAccountApplicationTFView *mainDoctorView;
/** 治疗方案 */
@property (nonatomic, strong) FHAccountApplicationTFView *therapeuticRegimenView;

@end

@implementation FHAddMedicalHistoryController

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
//    titleLabel.text = @"添加医疗记录";
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
    [self.scrollView addSubview:self.dateView];
    [self.scrollView addSubview:self.hospitalView];
    [self.scrollView addSubview:self.allPriceView];
    [self.scrollView addSubview:self.mainDoctorView];
    [self.scrollView addSubview:self.therapeuticRegimenView];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.hospitalView.frame = CGRectMake(0, MaxY(self.dateView), SCREEN_WIDTH, commonCellHeight);
    self.allPriceView.frame = CGRectMake(0, MaxY(self.hospitalView), SCREEN_WIDTH, commonCellHeight);
    self.mainDoctorView.frame = CGRectMake(0, MaxY(self.allPriceView), SCREEN_WIDTH, commonCellHeight);
    self.therapeuticRegimenView.frame = CGRectMake(0, MaxY(self.mainDoctorView), SCREEN_WIDTH, commonCellHeight);
    [self updatePickerViewFrameY:MaxY(self.therapeuticRegimenView)];
    self.scrollView.contentSize = CGSizeMake(0, [self getPickerViewFrame].size.height + MainSizeHeight + 20);
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
        _dateView.titleLabel.text = @"就诊时间";
        _dateView.contentTF.placeholder = @"请输入就诊时间";
    }
    return _dateView;
}

- (FHAccountApplicationTFView *)hospitalView {
    if (!_hospitalView) {
        _hospitalView = [[FHAccountApplicationTFView alloc] init];
        _hospitalView.titleLabel.text = @"就诊医院";
        _hospitalView.contentTF.placeholder = @"请输入医院名称";
    }
    return _hospitalView;
}

- (FHAccountApplicationTFView *)allPriceView {
    if (!_allPriceView) {
        _allPriceView = [[FHAccountApplicationTFView alloc] init];
        _allPriceView.titleLabel.text = @"总消费";
        _allPriceView.contentTF.placeholder = @"请输入消费金额";
    }
    return _allPriceView;
}

- (FHAccountApplicationTFView *)mainDoctorView {
    if (!_mainDoctorView) {
        _mainDoctorView = [[FHAccountApplicationTFView alloc] init];
        _mainDoctorView.titleLabel.text = @"主治医师";
        _mainDoctorView.contentTF.placeholder = @"请输入主治医师";
    }
    return _mainDoctorView;
}

- (FHAccountApplicationTFView *)therapeuticRegimenView {
    if (!_therapeuticRegimenView) {
        _therapeuticRegimenView = [[FHAccountApplicationTFView alloc] init];
        _therapeuticRegimenView.titleLabel.text = @"治疗方案";
        _therapeuticRegimenView.contentTF.placeholder = @"请输入治疗方案";
    }
    return _therapeuticRegimenView;
}

@end
