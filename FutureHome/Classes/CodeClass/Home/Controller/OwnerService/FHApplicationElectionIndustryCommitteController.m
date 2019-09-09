//
//  FHApplicationElectionIndustryCommitteController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  业委选举申请界面

#import "FHApplicationElectionIndustryCommitteController.h"
#import "FHElectRepeatTFView.h"
#import "BRPlaceholderTextView.h"

@interface FHApplicationElectionIndustryCommitteController () <UITextFieldDelegate,UIScrollViewDelegate>
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

@end

@implementation FHApplicationElectionIndustryCommitteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    titleLabel.text = @"业委选举申请";
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
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.ageView];
    [self.scrollView addSubview:self.sexView];
    [self.scrollView addSubview:self.xueliView];
    [self.scrollView addSubview:self.phoneView];
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
    CGFloat commonCellHeight = 30.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50));
    self.nameView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, commonCellHeight);
    self.ageView.frame = CGRectMake(10, MaxY(self.nameView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.sexView.frame = CGRectMake(10, MaxY(self.ageView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.xueliView.frame = CGRectMake(10, MaxY(self.sexView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.phoneView.frame = CGRectMake(10, MaxY(self.xueliView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.faceView.frame = CGRectMake(10, MaxY(self.phoneView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.addressView.frame = CGRectMake(10, MaxY(self.faceView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.typeView.frame = CGRectMake(10, MaxY(self.addressView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.contentTF.frame = CGRectMake(10, MaxY(self.typeView) - 1, SCREEN_WIDTH - 20, commonCellHeight);
    self.bigBottomView.frame = CGRectMake(10, MaxY(self.contentTF) - 1, SCREEN_WIDTH - 20, 400);
    self.scrollView.contentSize = CGSizeMake(0, MaxY(self.bigBottomView) + MainSizeHeight + 20);
}

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
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
        _typeView.contentTF.placeholder = @"请选择职位";
    }
    return _typeView;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 118 - 10, 10, 118, 118)];
        _headerImageView.image = [UIImage imageNamed:@"头像"];
    }
    return _headerImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 117, MaxY(self.headerImageView),0.5, 30)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 117, MaxY(self.headerImageView),118, 30)];
        _numberLabel.textColor = [UIColor redColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:13];
        _numberLabel.text = @"参选号: 12号";
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
        _normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,97.5, 400)];
        _normalLabel.textColor = [UIColor blackColor];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        _normalLabel.font = [UIFont systemFontOfSize:13];
        _normalLabel.text = @"基本情况:";
    }
    return _normalLabel;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(97.5, 0, SCREEN_WIDTH - 20 - 97.5, 400)];
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:13];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @" \n\n\n\n 请输入个人基本情况";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
}

@end
