//
//  FHGoodsCommitController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商品评论

#import "FHGoodsCommitController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"
#import "FHPrivacySettingsCell.h"

@interface FHGoodsCommitController () <UITableViewDelegate,UITableViewDataSource>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 就诊时间View */
@property (nonatomic, strong) FHAccountApplicationTFView *dateView;
/** 医院View */
@property (nonatomic, strong) FHAccountApplicationTFView *hospitalView;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 上面的logoName */
@property (nonatomic, copy) NSArray *topLogoNameArrs;
/** 上面最后选择的indexPath */
@property (nonatomic, assign) NSIndexPath *topLastIndexPath;
/** 营业说明textView */
@property (nonatomic, strong) BRPlaceholderTextView *businessDescriptionTextView;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

//@property (nonatomic, assign)BOOL ifSelected;//是否选中
//
//@property (nonatomic, strong)NSIndexPath * lastSelected;//上一次选中的索引

@property (nonatomic, strong) UIButton * oldSelectBtn;

@end

@implementation FHGoodsCommitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLogoNameArrs = @[@"喜欢满意",
                             @"感觉一般",
                             @"不满意"];
    [self.homeTable registerClass:[FHPrivacySettingsCell class] forCellReuseIdentifier:NSStringFromClass([FHPrivacySettingsCell class])];
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
    titleLabel.text = @"商品评论";
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

- (void)creatBottomBtn{
    UILabel *logLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(75), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(25))];
    logLabel.text = @"亲,感谢您,美丽客观的体验评价;\n这有益于市场,有益于商家,有益于生活,有益于社会。";
    logLabel.font = [UIFont systemFontOfSize:10];
    logLabel.textAlignment = NSTextAlignmentLeft;
    logLabel.textColor = [UIColor blackColor];
    logLabel.numberOfLines = 2;
    [self.view addSubview:logLabel];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)fh_creatUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.dateView];
    [self.scrollView addSubview:self.homeTable];
    [self.scrollView addSubview:self.hospitalView];
    [self.scrollView addSubview:self.businessDescriptionTextView];
    self.scrollView.delegate = self;
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.homeTable.frame = CGRectMake(0, MaxY(self.dateView), SCREEN_WIDTH, 110);
    self.hospitalView.frame = CGRectMake(0, MaxY(self.homeTable), SCREEN_WIDTH, commonCellHeight);
    self.businessDescriptionTextView.frame = CGRectMake(10, MaxY(self.hospitalView), SCREEN_WIDTH - 20, 150);
    [self updatePickerViewFrameY:MaxY(self.businessDescriptionTextView)];
    self.scrollView.contentSize = CGSizeMake(0, [self getPickerViewFrame].size.height + MainSizeHeight + 20);
}


- (void)sureBtnClick {
    /** 添加商品评论 */
    //显示加载视图
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
    [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.orderID,@"order_id",
                               @(self.type),@"experience",
                               self.imgSelectArrs,@"file[]",
                               self.businessDescriptionTextView.text,@"content",
                               nil];
    
    [AFNetWorkTool uploadImagesWithUrl:@"shop/orderComment" parameters:paramsDic image:self.imgSelectArrs success:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1) {
            [self.lodingHud hideAnimated:YES];
            self.lodingHud = nil;
            [weakSelf.view makeToast:@"添加商品评论成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self.lodingHud hideAnimated:YES];
            self.lodingHud = nil;
            [weakSelf.view makeToast:responseObj[@"提交评论失败"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topLogoNameArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHPrivacySettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHPrivacySettingsCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.logoLabel.text = [NSString stringWithFormat:@"%@",self.topLogoNameArrs[indexPath.row]];
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectBtn.tag = indexPath.row + 1;
    return cell;
}

#pragma mark -tableView代理方法
- (void)selectBtnClick:(UIButton *)btn {
    if (self.oldSelectBtn == btn) {
    } else {
        btn.backgroundColor = HEX_COLOR(0x1296db);
        self.oldSelectBtn.backgroundColor = [UIColor whiteColor];
    }
    self.oldSelectBtn = btn;
    self.type = btn.tag;
}


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 110) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.scrollEnabled = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (FHAccountApplicationTFView *)dateView {
    if (!_dateView) {
        _dateView = [[FHAccountApplicationTFView alloc] init];
        _dateView.titleLabel.text = @"亲,您本次的消费体验整体是否满意";
        _dateView.contentTF.placeholder = @"";
        
        _dateView.contentTF.enabled = NO;
    }
    return _dateView;
}

- (FHAccountApplicationTFView *)hospitalView {
    if (!_hospitalView) {
        _hospitalView = [[FHAccountApplicationTFView alloc] init];
        _hospitalView.titleLabel.text = @"亲,对于本次的消费体验,您有什么评价看法";
        _hospitalView.contentTF.placeholder = @"";
        _hospitalView.contentTF.enabled = NO;
    }
    return _hospitalView;
}

- (BRPlaceholderTextView *)businessDescriptionTextView {
    if (!_businessDescriptionTextView) {
        _businessDescriptionTextView = [[BRPlaceholderTextView alloc] init];
        _businessDescriptionTextView.layer.borderWidth = 1;
        _businessDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _businessDescriptionTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _businessDescriptionTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"请输入评价内容...";
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
        _lodingHud.label.text = @"评论提交中...请稍后";
        [_lodingHud showAnimated:YES];
    }
    return _lodingHud;
}

@end
