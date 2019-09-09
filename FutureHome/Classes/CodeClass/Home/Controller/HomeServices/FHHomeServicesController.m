//
//  FHHomeServicesController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  物业服务

#import "FHHomeServicesController.h"
#import "FHCommonCollectionViewCell.h"
#import "FHBaseAnnouncementListController.h"
#import "FHWebViewController.h"
#import "FHAboutMyPropertyController.h"
#import "FHDecorationAndMaintenanceController.h"
#import "FHSuggestionController.h"
#import "FHRentalAndSaleController.h"

@interface FHHomeServicesController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,FHCommonCollectionViewDelegate>
{
    NSMutableArray *topBannerArrays;
    NSMutableArray *bottomBannerArrays;
}
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
/** 下面的image */
@property (nonatomic, copy) NSArray *bottomImageArrs;

@end

@implementation FHHomeServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    self.bottomLogoNameArrs = @[@"物业公告",
                                @"清洁绿化",
                                @"安保消防",
                                @"水电气",
                                @"装修维修",
                                @"物业费用",
                                @"车库管理",
                                @"房屋出售",
                                @"投诉建议",
                                @"我的物业"];
    self.bottomImageArrs = @[@"2-1社区公告",
                             @"2-2 清洁绿化",
                             @"2-3 治安消防",
                             @"2-4水电管理系统",
                             @"2-8装修维修",
                             @"2-6物业费用",
                             @"2-5车库管理",
                             @"2-7房屋租售",
                             @"2-9投诉建议",
                             @"2-10我的物业"];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHCommonCollectionViewCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonCollectionViewCell class])];
    /** 获取banner数据 */
    [self fh_refreshBannerData];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"物业服务";
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


#pragma mark — request
- (void)fh_refreshBannerData {
    [self fh_getTopBanner];
    [self fh_bottomTopBanner];
}

- (void)fh_getTopBanner {
    WS(weakSelf);
    topBannerArrays = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(1),@"user_id",
                               @(1),@"type", nil];
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        NSDictionary *upDic = Dic[@"uplist"];
        [self->topBannerArrays addObject:upDic[@"path1"]];
        [self->topBannerArrays addObject:upDic[@"path2"]];
        [self->topBannerArrays addObject:upDic[@"path3"]];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

- (void)fh_bottomTopBanner {
    WS(weakSelf);
    bottomBannerArrays = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(1),@"user_id",
                               @(1),@"type", nil];
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        NSDictionary *upDic = Dic[@"downlist"];
        [self->bottomBannerArrays addObject:upDic[@"path1"]];
        [self->bottomBannerArrays addObject:upDic[@"path2"]];
        [self->bottomBannerArrays addObject:upDic[@"path3"]];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
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
        
        self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 5 - SCREEN_WIDTH * 0.116, 5, SCREEN_WIDTH * 0.116 - 10, SCREEN_WIDTH * 0.116 - 10)];
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
//        NSArray *urlsArray = [topBannerArrays copy];
        NSArray *urlsArray = @[@"房产1",@"房产2",@"房产3"];
        self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2018];
        
        [cell addSubview:self.topScrollView];
        return cell;
    } else if (indexPath.row == 2) {
        /** 菜单列表数据 */
        FHCommonCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonCollectionViewCell class])];
        cell.delegate = self;
        cell.bottomLogoNameArrs = self.bottomLogoNameArrs;
        cell.bottomImageArrs = self.bottomImageArrs;
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
//        NSArray *urlsArray = [bottomBannerArrays copy];
        NSArray *urlsArray = @[@"海飞丝 1",@"海飞丝 2",@"海飞丝 4"];
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
        /** 物业公告 */
        [self pushAnnouncementControllerWithTitle:@"物业公告"];
    } else if (selectIndex.row == 1) {
        /** 清洁绿化 */
//        [self pushAnnouncementControllerWithTitle:@"清洁绿化"];
        [self viewControllerPushOther:@"FHGreenController"];
    } else if (selectIndex.row == 2) {
        /** 安保消防 */
//        [self pushAnnouncementControllerWithTitle:@"安保消防"];
        [self viewControllerPushOther:@"FHSafeController"];
    } else if (selectIndex.row == 3) {
        /** 水电气 */
//        [self pushAnnouncementControllerWithTitle:@"水电气"];
        [self viewControllerPushOther:@"FHMenagerController"];
    } else if (selectIndex.row == 4) {
        /** 装修维修 */
        FHDecorationAndMaintenanceController *vc = [[FHDecorationAndMaintenanceController alloc] init];
        vc.titleString = @"装修维修";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (selectIndex.row == 5) {
        /** 物业费用 */
//        [self pushAnnouncementControllerWithTitle:@"物业费用"];
        [self viewControllerPushOther:@"FHPropertyCostsController"];
    } else if (selectIndex.row == 6) {
        /** 车库管理 */
//        [self pushAnnouncementControllerWithTitle:@"车库管理"];
        [self viewControllerPushOther:@"FHGarageManagementController"];
    } else if (selectIndex.row == 7) {
        /** 房屋租售 */
//        [self pushAnnouncementControllerWithTitle:@"房屋租售"];
        FHRentalAndSaleController *vc = [[FHRentalAndSaleController alloc] init];
        vc.titleString = @"房屋租售";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (selectIndex.row == 8) {
        /** 投诉建议 */
        FHSuggestionController *vc = [[FHSuggestionController alloc] init];
        vc.titleString = @"投诉建议";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (selectIndex.row == 9) {
        /** 我的物业 */
        FHAboutMyPropertyController *about = [[FHAboutMyPropertyController alloc] init];
        about.titleString = @"我的物业";
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (void)pushAnnouncementControllerWithTitle:(NSString *)title {
    FHBaseAnnouncementListController *an = [[FHBaseAnnouncementListController alloc] init];
    an.titleString = title;
    an.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:an animated:YES];
}


#pragma mark  -- 点击banner的代理方法
/** 点击图片*/
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    if (infiniteScrollView.tag == 2018) {
        /** 上面的轮播图 */
        [self pushToWebControllerWithUrl:@"http://192.168.3.57:8080/advent/index/mobileAdvent/pid/1/id/1"];
    } else {
        /** 下面的轮播图 */
        [self pushToWebControllerWithUrl:@"https://www.kancloud.cn/gogery/tp5/358921"];
    }
}

- (void)pushToWebControllerWithUrl:(NSString *)url {
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
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
