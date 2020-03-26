//
//  FHTendringInfoDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/26.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  投标信息详情页

#import "FHTendringInfoDetailController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"
#import "DPPhotoLibrary.h"

@interface FHTendringInfoDetailController () <UITextFieldDelegate,UIScrollViewDelegate,DPPhotoListViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 项目名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *tendrNameView;
/** 项目时间View */
@property (nonatomic, strong) FHAccountApplicationTFView *tendrTimeView;
/** 项目手机View */
@property (nonatomic, strong) FHAccountApplicationTFView *tendrPhoneView;

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
/** <#strong属性注释#> */
@property (nonatomic, strong) DPPhotoListView *photoListView;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSArray *imgArrs;

@end

@implementation FHTendringInfoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self getRequest];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"投标信息详情";
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

- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.owner_id),@"owner_id",
                               self.id,@"id",
                               nil];
    [AFNetWorkTool get:@"owner/tenderDetail" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            weakSelf.imgArrs = dic[@"img_ids"];
            weakSelf.tendrNameView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
            weakSelf.tendrTimeView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"candidate_time"]];
            weakSelf.tendrPhoneView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"tender_mobile"]];
            
            weakSelf.nameView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            weakSelf.typeView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"position"]];
            weakSelf.levealView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
            weakSelf.phoneView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"id_number"]];
            weakSelf.companyNameView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"com_name"]];
            weakSelf.xinCodeView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"credit_code"]];
            weakSelf.companyAddressView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"address"]];
            weakSelf.emailView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"email"]];
            weakSelf.businessDescriptionTextView.text = [NSString stringWithFormat:@"投标信息情况\n%@",dic[@"describe"]];
            [self fh_creatUI];
            [self fh_layoutSubViews];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)fh_creatUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tendrNameView];
    [self.scrollView addSubview:self.tendrTimeView];
    [self.scrollView addSubview:self.tendrPhoneView];
    [self.scrollView addSubview:self.nameView];
    [self.scrollView addSubview:self.typeView];
    [self.scrollView addSubview:self.levealView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.companyNameView];
    [self.scrollView addSubview:self.xinCodeView];
    [self.scrollView addSubview:self.companyAddressView];
    [self.scrollView addSubview:self.emailView];
    [self.scrollView addSubview:self.businessDescriptionTextView];
    self.photoListView = [[DPPhotoListView alloc] initWithFrame:CGRectMake(0, MaxY(self.businessDescriptionTextView) + 10, self.view.bounds.size.width, SCREEN_HEIGHT) numberOfCellInRow:3 lineSpacing:15 dataSource:[self.imgArrs mutableCopy]];
    CGFloat height = [self.photoListView getItemSizeHeight];
    CGFloat photoListHeight = 0.0;
    if (self.imgArrs.count == 0) {
        photoListHeight = 0;
    } else if (self.imgArrs.count <= 3) {
        photoListHeight = height + 15;
    } else if (self.imgArrs.count <=6 && self.imgArrs.count > 3) {
        photoListHeight = 2 * height + 15 * 2;
    } else if (self.imgArrs.count <=9 && self.imgArrs.count > 6) {
        photoListHeight = 3 * height + 15 * 3;
    }
    self.photoListView.height = photoListHeight;
    self.photoListView.showAddImagesButton = NO;
    self.photoListView.allowLongPressEditPhoto = NO;
    self.photoListView.delegate = self;
    [self.scrollView addSubview:self.photoListView];
}

#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tendrNameView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.tendrTimeView.frame = CGRectMake(0, MaxY(self.tendrNameView), SCREEN_WIDTH, commonCellHeight);
    self.tendrPhoneView.frame = CGRectMake(0, MaxY(self.tendrTimeView), SCREEN_WIDTH, commonCellHeight);
    self.nameView.frame = CGRectMake(0, MaxY(self.tendrPhoneView), SCREEN_WIDTH, commonCellHeight);
    self.typeView.frame = CGRectMake(0, MaxY(self.nameView), SCREEN_WIDTH, commonCellHeight);
    self.levealView.frame = CGRectMake(0, MaxY(self.typeView), SCREEN_WIDTH, commonCellHeight);
    self.phoneView.frame = CGRectMake(0, MaxY(self.levealView), SCREEN_WIDTH, commonCellHeight);
    self.companyNameView.frame = CGRectMake(0, MaxY(self.phoneView), SCREEN_WIDTH, commonCellHeight);
    self.xinCodeView.frame = CGRectMake(0, MaxY(self.companyNameView), SCREEN_WIDTH, commonCellHeight);
    self.companyAddressView.frame = CGRectMake(0, MaxY(self.xinCodeView), SCREEN_WIDTH, commonCellHeight);
    self.emailView.frame = CGRectMake(0, MaxY(self.companyAddressView), SCREEN_WIDTH, commonCellHeight);
    CGSize size = [UIlabelTool sizeWithString:self.businessDescriptionTextView.text font:self.businessDescriptionTextView.font width:SCREEN_WIDTH - 10];
    self.businessDescriptionTextView.frame = CGRectMake(5, MaxY(self.emailView), SCREEN_WIDTH - 10, size.height + 15);
    self.photoListView.frame = CGRectMake(0, MaxY(self.businessDescriptionTextView) + 10, SCREEN_WIDTH, self.photoListView.height);
    self.scrollView.contentSize = CGSizeMake(0, MaxY(self.photoListView) + MainSizeHeight + 20);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    scrollView.contentOffset = point;
}

- (void)fh_selectCellWithIndex:(NSIndexPath *)selectIndex {
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = (int)selectIndex.row;
    browser.imageArray = self.imgArrs;
    [browser show];
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)tendrNameView {
    if (!_tendrNameView) {
        _tendrNameView = [[FHAccountApplicationTFView alloc] init];
        _tendrNameView.titleLabel.text = @"投标项目名称:";
        _tendrNameView.titleLabel.textColor = [UIColor blueColor];
        _tendrNameView.contentTF.textColor = [UIColor blueColor];
        _tendrNameView.contentTF.userInteractionEnabled = NO;
    }
    return _tendrNameView;
}

- (FHAccountApplicationTFView *)tendrTimeView {
    if (!_tendrTimeView) {
        _tendrTimeView = [[FHAccountApplicationTFView alloc] init];
        _tendrTimeView.titleLabel.text = @"投标有效时间:";
        _tendrTimeView.titleLabel.textColor = [UIColor blueColor];
        _tendrTimeView.contentTF.textColor = [UIColor blueColor];
        _tendrTimeView.contentTF.userInteractionEnabled = NO;
    }
    return _tendrTimeView;
}

- (FHAccountApplicationTFView *)tendrPhoneView {
    if (!_tendrPhoneView) {
        _tendrPhoneView = [[FHAccountApplicationTFView alloc] init];
        _tendrPhoneView.titleLabel.text = @"发标方联系电话:";
        _tendrPhoneView.titleLabel.textColor = [UIColor blueColor];
        _tendrPhoneView.contentTF.textColor = [UIColor blueColor];
        _tendrPhoneView.contentTF.userInteractionEnabled = NO;
    }
    return _tendrPhoneView;
}

- (FHAccountApplicationTFView *)nameView {
    if (!_nameView) {
        _nameView = [[FHAccountApplicationTFView alloc] init];
        _nameView.titleLabel.text = @"申请人姓名:";
        _nameView.contentTF.userInteractionEnabled = NO;
    }
    return _nameView;
}

- (FHAccountApplicationTFView *)typeView {
    if (!_typeView) {
        _typeView = [[FHAccountApplicationTFView alloc] init];
        _typeView.titleLabel.text = @"申请人职位:";
        _typeView.contentTF.userInteractionEnabled = NO;
//        _typeView.contentTF.placeholder = @"请输入申请人的职位";
    }
    return _typeView;
}

- (FHAccountApplicationTFView *)levealView {
    if (!_levealView) {
        _levealView = [[FHAccountApplicationTFView alloc] init];
        _levealView.titleLabel.text = @"申请人电话:";
        _levealView.contentTF.userInteractionEnabled = NO;
//        _levealView.contentTF.placeholder = @"请输入申请人手机电话";
    }
    return _levealView;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"申请人身份证";
        _phoneView.contentTF.userInteractionEnabled = NO;
//        _phoneView.contentTF.placeholder = @"请输入申请人身份证号";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)companyNameView {
    if (!_companyNameView) {
        _companyNameView = [[FHAccountApplicationTFView alloc] init];
        _companyNameView.titleLabel.text = @"投标公司名称:";
        _companyNameView.contentTF.userInteractionEnabled = NO;
//        _companyNameView.contentTF.placeholder = @"请输入投标公司名称";
    }
    return _companyNameView;
}

- (FHAccountApplicationTFView *)xinCodeView {
    if (!_xinCodeView) {
        _xinCodeView = [[FHAccountApplicationTFView alloc] init];
        _xinCodeView.titleLabel.text = @"公司信用代码:";
        _xinCodeView.contentTF.userInteractionEnabled = NO;
//        _xinCodeView.contentTF.placeholder = @"请输入投标公司信用代码";
    }
    return _xinCodeView;
}

- (FHAccountApplicationTFView *)companyAddressView {
    if (!_companyAddressView) {
        _companyAddressView = [[FHAccountApplicationTFView alloc] init];
        _companyAddressView.titleLabel.text = @"投标公司地址:";
        _companyAddressView.contentTF.userInteractionEnabled = NO;
//        _companyAddressView.contentTF.placeholder = @"请输入投标公司地址";
    }
    return _companyAddressView;
}

- (FHAccountApplicationTFView *)emailView {
    if (!_emailView) {
        _emailView = [[FHAccountApplicationTFView alloc] init];
        _emailView.titleLabel.text = @"投标联系邮箱:";
        _emailView.contentTF.userInteractionEnabled = NO;
//        _emailView.contentTF.placeholder = @"请输入投标公司联系邮箱";
    }
    return _emailView;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] init];
        _businessDescriptionTextView.layer.borderWidth = 1;
        _businessDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        _businessDescriptionTextView.userInteractionEnabled = NO;
//        NSString *titleString = @"投标信息情况";
//        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
//        _businessDescriptionTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _businessDescriptionTextView;
}

@end
