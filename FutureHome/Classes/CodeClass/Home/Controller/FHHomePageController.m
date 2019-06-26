//
//  FHHomePageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  主页

#import "FHHomePageController.h"
#import "BHInfiniteScrollView.h"
#import "FHMenuListCell.h"

@interface FHHomePageController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,FHMenuListCellDelegate>
/** 导航View视图 */
@property (nonatomic, strong) UIView *navView;
/** 坐标图片 */
@property (nonatomic, strong) UIImageView *locationImgView;
/** 地点名字label */
@property (nonatomic, strong) UILabel *locationLabel;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchBtn;
/** 收藏按钮 */
@property (nonatomic, strong) UIButton *collectBtn;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 上面的轮播图 */
@property (nonatomic, strong) BHInfiniteScrollView *topScrollView;
/** 下面的轮播图 */
@property (nonatomic, strong) BHInfiniteScrollView *bottomScrollView;
/** 物业名字label */
@property (nonatomic, strong) UILabel *realSstateSNameLabel;
/** w二维码图 */
@property (nonatomic, strong) UIImageView *codeImgView;

@end

@implementation FHHomePageController


#pragma mark — privite
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHMenuListCell class] forCellReuseIdentifier:NSStringFromClass([FHMenuListCell class])];
}

- (void)setNav {
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    self.navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.locationImgView];
    [self.navView addSubview:self.locationLabel];
    self.searchBtn.frame = CGRectMake(0, (MainNavgationBarHeight - 16) / 2, 100, 16);
    self.searchBtn.centerX = self.navView.width / 2;
    [self.navView addSubview:self.searchBtn];
    self.collectBtn.frame = CGRectMake(self.navView.width - 55, (MainNavgationBarHeight - 16) / 2, 50, 16);
    [self.navView addSubview:self.collectBtn];
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
        NSArray *urlsArray = [[NSArray alloc] init];
        self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2018];
        
        [cell addSubview:self.topScrollView];
        return cell;
    } else if (indexPath.row == 2) {
        /** 菜单列表数据 */
        FHMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMenuListCell class])];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
        NSArray *urlsArray = [[NSArray alloc] init];
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
    mallScrollView.pageControlHidden = YES;
    mallScrollView.contentMode = UIViewContentModeScaleAspectFill;
    mallScrollView.tag = scrollViewTag;
    return mallScrollView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


#pragma mark — FHMenuListCellDelegate
- (void)FHMenuListCellSelectIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        /** 物业服务 */

    } else if (indexPath.row == 1) {
        /** 业主服务 */
        
    } else if (indexPath.row == 2) {
        /** 健康服务 */
        
    } else if (indexPath.row == 3) {
        /** 生鲜服务 */
        
    } else if (indexPath.row == 4) {
        /** 理财服务 */
        
    } else if (indexPath.row == 5) {
        /** 客服服务 */
        
    }
}

#pragma mark — event
- (void)searchBtnClick {
    /** 搜索事件 */

}

- (void)collectBtnClick {
    /** 收藏事件 */
}


#pragma mark — setter & getter
#pragma mark - 懒加载
- (UIImageView *)locationImgView {
    if (!_locationImgView) {
        _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, MainNavgationBarHeight - 10)];
        _locationImgView.image = [UIImage imageNamed:@"tarbar_home_normal"];
    }
    return _locationImgView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locationImgView.frame) + 5, (MainNavgationBarHeight - 16) / 2, 100, 16)];
        _locationLabel.textColor = [UIColor blackColor];
        _locationLabel.text = @"重庆市";
        _locationLabel.font = [UIFont systemFontOfSize:16];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _locationLabel;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索🔍" forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setTitle:@"+收藏" forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

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
