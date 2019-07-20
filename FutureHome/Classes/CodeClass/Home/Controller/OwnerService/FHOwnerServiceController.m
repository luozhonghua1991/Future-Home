//
//  FHOwnerServiceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  业主服务

#import "FHOwnerServiceController.h"
#import "FHCommonCollectionViewCell.h"

@interface FHOwnerServiceController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,FHCommonCollectionViewDelegate>
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

@implementation FHOwnerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNav = YES;
    self.bottomLogoNameArrs = @[@"公告通知",
                                @"业主大会",
                                @"业委选举",
                                @"业委管理",
                                @"财务公开",
                                @"物业管理",
                                @"物业招标",
                                @"活动关爱",
                                @"投诉建议",
                                @"我的业委"];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHCommonCollectionViewCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonCollectionViewCell class])];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        /** 服务平台 */
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.subviews) {
            if (view.tag == 2017) {
                [view removeFromSuperview];
            }
        }
        UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.116)];
        locationView.tag = 2017;
        
        self.realSstateSNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,( SCREEN_WIDTH * 0.116 - 16 ) / 2, SCREEN_WIDTH - 5 - SCREEN_WIDTH * 0.116, 15)];
        self.realSstateSNameLabel.text = @"恒大未来城一期-恒大物业服务平台";
        self.realSstateSNameLabel.textColor = [UIColor blackColor];
        self.realSstateSNameLabel.font = [UIFont systemFontOfSize:15];
        self.realSstateSNameLabel.textAlignment = NSTextAlignmentCenter;
        [locationView addSubview:self.realSstateSNameLabel];
        
        self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 5 - SCREEN_WIDTH * 0.116, 0, SCREEN_WIDTH * 0.116, SCREEN_WIDTH * 0.116)];
        self.codeImgView.backgroundColor = [UIColor yellowColor];
        [locationView addSubview:self.codeImgView];
        
        [cell addSubview:locationView];
        return cell;
    } else if (indexPath.row == 1) {
        /** 轮播图 */
        static NSString *ID = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.subviews) {
            if (view.tag == 2018) {
                [view removeFromSuperview];
            }
        }
//        NSArray *urlsArray = [[NSArray alloc] init];
        NSArray *urlsArray = @[@"http://192.168.3.57:8080/uploads/admin/img/20190609/1530a0df58fe1870bed63eaa275dead3.png",
                               @"http://192.168.3.57:8080/uploads/admin/img/20190609/61b5da068844877e75e114005b75bf2e.png"];
        self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2018];
        
        [cell addSubview:self.topScrollView];
        return cell;
    } else if (indexPath.row == 2) {
        /** 菜单列表数据 */
        FHCommonCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonCollectionViewCell class])];
        cell.delegate = self;
        cell.bottomLogoNameArrs = self.bottomLogoNameArrs;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        /** 广告轮播图 */
        /** 轮播图 */
        static NSString *ID = @"cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.subviews) {
            if (view.tag == 2019) {
                [view removeFromSuperview];
            }
        }
//        NSArray *urlsArray = [[NSArray alloc] init];
        NSArray *urlsArray = @[@"http://192.168.3.57:8080/uploads/admin/img/20190609/1530a0df58fe1870bed63eaa275dead3.png",
                               @"http://192.168.3.57:8080/uploads/admin/img/20190609/61b5da068844877e75e114005b75bf2e.png"];
        self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2019];
        
        [cell addSubview:self.topScrollView];
        return cell;
    }
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


#pragma mark — FHCommonCollectionViewDelegate
- (void)FHCommonCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex {
    if (selectIndex.row == 0) {
        /** 公告通知 */
    } else if (selectIndex.row == 1) {
        /** 业主大会 */
    } else if (selectIndex.row == 2) {
        /** 业委选举 */
    } else if (selectIndex.row == 3) {
        /** 业委管理 */
    } else if (selectIndex.row == 4) {
        /** 财务公开 */
    } else if (selectIndex.row == 5) {
        /** 物业管理 */
    } else if (selectIndex.row == 6) {
        /** 物业招标 */
    } else if (selectIndex.row == 7) {
        /** 活动关爱 */
    } else if (selectIndex.row == 8) {
        /** 投诉建议 */
    } else if (selectIndex.row == 9) {
        /** 我的业委 */
    }
}


#pragma mark  -- 点击banner的代理方法
/** 点击图片*/
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    if (infiniteScrollView.tag == 2018) {
        /** 上面的轮播图 */
        
    } else {
        /** 下面的轮播图 */
    }
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
