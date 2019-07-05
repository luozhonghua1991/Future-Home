//
//  FHHomeServicesController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  物业服务

#import "FHHomeServicesController.h"

@interface FHHomeServicesController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 上面的轮播图 */
@property (nonatomic, strong) BHInfiniteScrollView *topScrollView;
/** 下面的轮播图 */
@property (nonatomic, strong) BHInfiniteScrollView *bottomScrollView;
/** 物业名字label */
@property (nonatomic, strong) UILabel *realSstateSNameLabel;
/** 二维码图 */
@property (nonatomic, strong) UIImageView *codeImgView;
/** 下面的logoName */
@property (nonatomic, copy) NSArray *bottomLogoNameArrs;

@end

@implementation FHHomeServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNav = YES;
    self.bottomLogoNameArrs = @[@"物业公告",
                                @"清洁绿化",
                                @"安保消防",
                                @"水电气",
                                @"车库管理",
                                @"装修维修",
                                @"物业缴费",
                                @"物业租赁",
                                @"投诉建议",
                                @"我的物业"];
     [self.view addSubview:self.homeTable];
    
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SCREEN_WIDTH * 0.116;
    } else if (indexPath.row == 2) {
        return SCREEN_WIDTH * 0.43;
    }
    return SCREEN_WIDTH * 0.618;
}


/** 创建轮播图的实例方法 */
- (BHInfiniteScrollView *)fh_creatBHInfiniterScrollerViewWithImageArrays:(NSArray *)imageArrs
                                                         scrollViewFrame:(CGRect )scrollViewFrame
                                                           scrollViewTag:(NSInteger)scrollViewTag {
    BHInfiniteScrollView *mallScrollView = [BHInfiniteScrollView
                                            infiniteScrollViewWithFrame:scrollViewFrame Delegate:self ImagesArray:imageArrs];
    
    mallScrollView.titleView.hidden = YES;
    mallScrollView.backgroundColor = [UIColor redColor];
    mallScrollView.scrollTimeInterval = 3;
    mallScrollView.autoScrollToNextPage = YES;
    mallScrollView.delegate = self;
    mallScrollView.pageControlHidden = YES;
    mallScrollView.contentMode = UIViewContentModeScaleAspectFill;
    mallScrollView.tag = scrollViewTag;
    return mallScrollView;
}

#pragma mark — event
/** 搜索事件 */
- (void)searchClick {
    
}
/** 收藏事件 */
- (void)collectClick {
    
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH) style:UITableViewStylePlain];
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

@end
