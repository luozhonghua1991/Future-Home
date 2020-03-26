//
//  FHCarSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  车位出售界面

#import "FHCarSaleController.h"
#import "FHCarSaleCell.h"
#import "BHInfiniteScrollView.h"
#import "SDPhotoBrowser.h"
#import "FHListDetailModel.h"

@interface FHCarSaleController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,SDPhotoBrowserDelegate>
/** 上面的轮播图 */
@property (nonatomic, strong) BHInfiniteScrollView *topScrollView;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 头视图 */
@property (nonatomic, strong) UIView *headerView;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHListDetailModel *detailModel;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *imgArrs;


@end

@implementation FHCarSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];;
    [self fh_getRqquest];
   
}

- (void)fh_getRqquest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"property_id",
                               @(self.id),@"id", nil];
    NSString *urlString;
    if (self.type == 0 || self.type == 1) {
        urlString = @"property/houseDetail";
    } else {
        urlString = @"property/parkDetail";
    }
    /** 租房详情  车位详情*/
    self.imgArrs = [[NSMutableArray alloc] init];
    [AFNetWorkTool get:urlString params:paramsDic success:^(id responseObj) {
        NSDictionary *dic = responseObj[@"data"];
        weakSelf.detailModel = [FHListDetailModel mj_objectWithKeyValues:dic];
        for (NSString *imgString in dic[@"img_ids"]) {
            [weakSelf.imgArrs addObject:imgString];
        }
        [self.view addSubview:self.homeTable];
        self.homeTable.tableHeaderView = self.headerView;
        self.homeTable.tableHeaderView.height = SCREEN_WIDTH * 0.618;
        [self.homeTable registerClass:[FHCarSaleCell class] forCellReuseIdentifier:NSStringFromClass([FHCarSaleCell class])];
        
        weakSelf.topScrollView = [weakSelf fh_creatBHInfiniterScrollerViewWithImageArrays:weakSelf.imgArrs scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2018];
        [weakSelf.headerView addSubview:weakSelf.topScrollView];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    NSString *string;
    if (self.type == 0) {
        string = @"房屋出售信息";
    } else if (self.type == 1) {
        string = @"房屋出租信息";
    } else if (self.type == 2) {
        string = @"车位出售信息";
    } else {
        string = @"车位出租信息";
    }
    titleLabel.text = string;
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


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SingleManager shareManager].rentOrSaleDetailHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /** 0房屋出售 1房屋出租 2车位出售 3车位出租 */
    FHCarSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCarSaleCell class])];
    cell.type = self.type;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailModel = self.detailModel;
    return cell;
}

/** 创建轮播图的实例方法 */
- (BHInfiniteScrollView *)fh_creatBHInfiniterScrollerViewWithImageArrays:(NSArray *)imageArrs
                                                         scrollViewFrame:(CGRect )scrollViewFrame
                                                           scrollViewTag:(NSInteger)scrollViewTag {
    BHInfiniteScrollView *mallScrollView = [BHInfiniteScrollView
                                            infiniteScrollViewWithFrame:scrollViewFrame Delegate:self ImagesArray:imageArrs];
    
    mallScrollView.titleView.hidden = YES;
    mallScrollView.scrollTimeInterval = 3;
    mallScrollView.autoScrollToNextPage = YES;
    mallScrollView.delegate = self;
    mallScrollView.contentMode = UIViewContentModeScaleAspectFill;
    mallScrollView.tag = scrollViewTag;
    return mallScrollView;
}

#pragma mark  -- 点击banner的代理方法
/** 点击图片*/
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = (int)index;
    browser.imageArray = self.imgArrs;
    [browser show];
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

@end
