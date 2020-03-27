//
//  FHAddMedicalHistoryController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHAddMedicalHistoryController.h"
#import "FHAccountApplicationTFView.h"
#import "DPPhotoLibrary.h"

@interface FHAddMedicalHistoryController () <UITextFieldDelegate,UIScrollViewDelegate,DPPhotoListViewDelegate>
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
/** 症状描述 */
@property (nonatomic, strong) FHAccountApplicationTFView *symptomView;
/** 治疗方案 */
@property (nonatomic, strong) FHAccountApplicationTFView *therapeuticRegimenView;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** 服务器返回的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrays;
/** <#strong属性注释#> */
@property (nonatomic, strong) DPPhotoListView *photoListView;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSArray *imgArrs;
/** 症状描述 */
@property (nonatomic, assign) CGFloat symptomViewHeight;
/** 治疗方案 */
@property (nonatomic, assign) CGFloat therapeuticRegimenViewHeight;

@end

@implementation FHAddMedicalHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    if ([self.titleString isEqualToString:@"添加医疗记录"]) {
        [self fh_creatUI];
        [self fh_layoutSubViews];
        [self creatBottomBtn];
    }
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
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.dateView];
    [self.scrollView addSubview:self.hospitalView];
    [self.scrollView addSubview:self.allPriceView];
    [self.scrollView addSubview:self.mainDoctorView];
    [self.scrollView addSubview:self.symptomView];
    [self.scrollView addSubview:self.therapeuticRegimenView];
    if ([self.titleString isEqualToString:@"添加医疗记录"]) {
        self.scrollView.delegate = self;
        self.showInView = self.scrollView;
        /** 初始化collectionView */
        [self initPickerView];
    } else {
        self.photoListView = [[DPPhotoListView alloc] initWithFrame:CGRectMake(0, MaxY(self.therapeuticRegimenView) + 10, self.view.bounds.size.width, SCREEN_HEIGHT) numberOfCellInRow:3 lineSpacing:15 dataSource:[self.imgArrs mutableCopy]];
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
}

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}


#pragma mark — event
- (void)sureBtnClick {
    /** 添加医疗记录接口  先上传图片*/
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
    self.selectImgArrays = [[NSMutableArray alloc] init];
    /** 先上传多张图片*/
    Account *account = [AccountStorage readAccount];
    NSString *string = [self getCurrentTimes];
    NSArray *arr = @[string];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @"health",@"path",
                               arr,@"file[]",
                               nil];
    for (int i = 0; i < self.imgSelectArrs.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(self.imgSelectArrs[i],1);
        WS(weakSelf);
        [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
            NSArray *arr = responseObj[@"data"];
            if (!IS_NULL_ARRAY(arr)) {
                NSString *imgID = [arr objectAtIndex:0];
                [weakSelf.selectImgArrays addObject:imgID];
                if (weakSelf.selectImgArrays.count == weakSelf.imgSelectArrs.count) {
                    /** 图片获取完毕 */
                    [weakSelf commitInfo];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)setModel:(FHHealthHistoryModel *)model {
    _model = model;
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               _model.id,@"id", nil];
    
    [AFNetWorkTool get:@"health/recordDetail" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            weakSelf.dateView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
            weakSelf.hospitalView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"hospital"]];
            weakSelf.allPriceView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"total_consum"]];
            weakSelf.mainDoctorView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"doctor"]];
            weakSelf.symptomView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"symptom"]];
            weakSelf.therapeuticRegimenView.contentTF.text = [NSString stringWithFormat:@"%@",dic[@"programme"]];
            weakSelf.imgArrs = dic[@"img_ids"];
            CGSize size1 = [UIlabelTool sizeWithString:weakSelf.symptomView.contentTF.text font:weakSelf.symptomView.contentTF.font width:weakSelf.symptomView.contentTF.width];
            self.symptomViewHeight = size1.height;
            CGSize size2 = [UIlabelTool sizeWithString:weakSelf.therapeuticRegimenView.contentTF.text font:weakSelf.therapeuticRegimenView.contentTF.font width:weakSelf.therapeuticRegimenView.contentTF.width];
            self.therapeuticRegimenViewHeight = size2.height;
            [weakSelf fh_creatUI];
            [weakSelf fh_layoutSubViews];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)commitInfo {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *imgArrsString = [self.selectImgArrays componentsJoinedByString:@","];
    NSDictionary *paramsDictory = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.pid,@"pid",
                               self.dateView.contentTF.text,@"treat_time",
                               self.hospitalView.contentTF.text,@"hospital",
                               self.symptomView.contentTF.text,@"symptom",
                               self.allPriceView.contentTF.text,@"total_consum",
                               self.mainDoctorView.contentTF.text,@"doctor",
                               self.therapeuticRegimenView.contentTF.text,@"programme",
                               imgArrsString,@"img_ids",
                               nil];
    
    [AFNetWorkTool post:@"health/addRecord" params:paramsDictory success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"添加医疗记录成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
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

- (void)fh_selectCellWithIndex:(NSIndexPath *)selectIndex {
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = (int)selectIndex.row;
    browser.imageArray = self.imgArrs;
    [browser show];
}

#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    if ([self.titleString isEqualToString:@"添加医疗记录"]) {
        self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    } else {
        self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH,SCREEN_HEIGHT);
    }
    self.dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.hospitalView.frame = CGRectMake(0, MaxY(self.dateView), SCREEN_WIDTH, commonCellHeight);
    self.allPriceView.frame = CGRectMake(0, MaxY(self.hospitalView), SCREEN_WIDTH, commonCellHeight);
    self.mainDoctorView.frame = CGRectMake(0, MaxY(self.allPriceView), SCREEN_WIDTH, commonCellHeight);
    if ([self.titleString isEqualToString:@"添加医疗记录"]) {
        [self updatePickerViewFrameY:MaxY(self.therapeuticRegimenView)];
        self.scrollView.contentSize = CGSizeMake(0, [self getPickerViewFrame].size.height + MainSizeHeight + 20);
        self.symptomView.frame = CGRectMake(0, MaxY(self.mainDoctorView), SCREEN_WIDTH, commonCellHeight);
        self.therapeuticRegimenView.frame = CGRectMake(0, MaxY(self.symptomView), SCREEN_WIDTH, commonCellHeight);
    } else {
        self.symptomView.frame = CGRectMake(0, MaxY(self.mainDoctorView), SCREEN_WIDTH, self.symptomViewHeight);
        self.therapeuticRegimenView.frame = CGRectMake(0, MaxY(self.symptomView), SCREEN_WIDTH, self.therapeuticRegimenViewHeight);
       self.photoListView.frame = CGRectMake(0, MaxY(self.therapeuticRegimenView) + 10, SCREEN_WIDTH, self.photoListView.height);
       self.scrollView.contentSize = CGSizeMake(0, MaxY(self.photoListView) + MainSizeHeight + 20);
    }
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


- (void)birthClick {
    [ZJDatePickerView zj_showDatePickerWithTitle:@"就诊时间" dateType:ZJDatePickerModeYMD defaultSelValue:@"" resultBlock:^(NSString *selectValue) {
        self.dateView.contentTF.text = selectValue;
    } ];
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

- (FHAccountApplicationTFView *)symptomView {
    if (!_symptomView) {
        _symptomView = [[FHAccountApplicationTFView alloc] init];
        _symptomView.titleLabel.text = @"症状描述";
        _symptomView.contentTF.placeholder = @"请输入症状描述";
    }
    return _symptomView;
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
