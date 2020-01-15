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
#import "FHCommonNavView.h"
#import "FHLittleMenuListCell.h"
#import "FHCommonCollectionViewCell.h"
#import "FHHomeServicesController.h"
#import "FHOwnerServiceController.h"
#import "FHHealthServicesController.h"
#import "FHFinancialServiceController.h"
#import "FHCustomerServiceController.h"
#import "FHGoodsListController.h"
#import "FHFreshMallController.h"
#import <JhtMarquee/JhtHorizontalMarquee.h>
#import <JhtMarquee/JhtVerticalMarquee.h>
#import "FHWebViewController.h"
#import "FHScanTool.h"
#import "PYSearchViewController.h"
#import "FHVideoPlayerController.h"
#import "FHScrollNewsController.h"
#import "FHMainSearchController.h"

@interface FHHomePageController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,FHMenuListCellDelegate,FHLittleMenuListCellDelegate,PYSearchViewControllerDelegate>
{
    NSMutableArray *topBannerArrays;
    NSMutableArray *bottomBannerArrays;
    NSMutableArray *topUrlArrays;
    NSMutableArray *bottomUrlArrays;
    NSMutableArray *hotSeaches;
}
/** 导航View视图 */
@property (nonatomic, strong) FHCommonNavView *navView;
/** 城市定位 */
@property (nonatomic, strong) UIButton *locationBtn;
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
/** 上面的logoName */
@property (nonatomic, copy) NSArray *topLogoNameArrs;
/** 下面的logoName */
@property (nonatomic, copy) NSArray *bottomLogoNameArrs;
/** 下面的image */
@property (nonatomic, copy) NSArray *bottomImgArrs;
// 纵向 跑马灯
@property (nonatomic,strong) JhtVerticalMarquee      *verticalMarquee;
/**消息图标*/
@property (nonatomic,strong) UIImageView             *messageImgView;
/** 商店id */
@property (nonatomic, copy) NSString *shopID;
/** 滚动消息数组 */
@property (nonatomic, strong) NSMutableArray *soureArray;

@end

@implementation FHHomePageController


#pragma mark — privite
- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLogoNameArrs = @[@"扫一扫",
                             @"付款",
                             @"收款",
                             @"生活缴费",
                             @"财富园"];
    self.bottomLogoNameArrs = @[@"物业服务",
                                @"业主服务",
                                @"健康服务",
                                @"生鲜服务",
                                @"理财服务",
                                @"客服服务"];
    self.bottomImgArrs = @[@"1-2物业服务",
                           @"1-3业主服务",
                           @"1-4健康服务",
                           @"1-5生鲜服务",
                           @"1-6理财",
                           @"1-7客服服务"];
    [self fh_creatNavUI];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHMenuListCell class] forCellReuseIdentifier:NSStringFromClass([FHMenuListCell class])];
    [self.homeTable registerClass:[FHLittleMenuListCell class] forCellReuseIdentifier:NSStringFromClass([FHLittleMenuListCell class])];
    /** 获取banner数据 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fefreshBanner) name:@"fefreshBanner" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCity) name:@"UPDATECITY" object:nil];
    [self fefreshBanner];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 开启跑马灯
    [self.verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭跑马灯
    [self.verticalMarquee marqueeOfSettingWithState:MarqueeShutDown_V];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取banner数据 */
    [self fh_getShopFollowList];
}

- (void)fefreshBanner {
    [self fh_refreshBannerData];
}

- (void)fh_getShopFollowList {
    /** 获取用户收藏的商店列表 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool get:@"shop/getUserCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *arr = responseObj[@"data"];
            NSDictionary *dic = arr[0];
            /** 商铺ID */
            weakSelf.shopID = dic[@"property_id"];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)fh_creatNavUI {
    self.isHaveNavgationView = YES;
    //定位 重庆
    [self fh_creatLocationView];
    //搜索栏
    [self fh_creatSerchView];
    //扫描二维码
    [self fh_creatCodeView];
}

- (void)fh_creatLocationView {
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.frame = CGRectMake(0, MainStatusBarHeight + 5, 100, 25);
    [self.locationBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.locationBtn setImage:[UIImage imageNamed:@"chengshidingweiicon"] forState:UIControlStateNormal];
    [self.navgationView addSubview:self.locationBtn];
}

- (void)updateCity {
    [self.locationBtn setTitle:[SingleManager shareManager].currentCity forState:UIControlStateNormal];
}

- (void)fh_creatSerchView {
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.locationBtn) + 10, MainStatusBarHeight, SCREEN_WIDTH - 130, 35)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 15;
    searchView.clipsToBounds = YES;
    searchView.layer.masksToBounds = YES;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = searchView.bounds;
    [searchBtn setTitle:@" 搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setImage:[UIImage imageNamed:@"xingtaiduICON_sousuo--"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    [self.navgationView addSubview:searchView];
}

- (void)fh_creatCodeView {
    self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, MainStatusBarHeight + 5, 25, 25)];
    self.codeImgView.image = [UIImage imageNamed:@"saoyisao-2"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.codeImgView.userInteractionEnabled = YES;
    [self.codeImgView addGestureRecognizer:tap];
    [self.navgationView addSubview:self.codeImgView];
}

/** 二维码扫描事件 */
- (void)tapClick {
    [FHScanTool fh_makeScanClick];
}

/** 搜索事件 */
- (void)searchBtnClick {
    FHMainSearchController *search = [[FHMainSearchController alloc] init];
    search.titleString = @"搜索";
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    
}

/** 点击取消时调用 */
- (void)didClickCancel:(PYSearchViewController *)searchViewController{
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark Get Method
/** 点击 滚动跑马灯 触发方法 */
- (void)marqueeTapGes:(UITapGestureRecognizer *)ges {
    [self.verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
//    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
    /** 点击进入滚动消息 */
    FHScrollNewsController *news = [[FHScrollNewsController alloc] init];
    news.type = @"1";
    news.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:news animated:YES];
}


#pragma mark — request
- (void)fh_refreshBannerData {
    [self fh_getTopBanner];
    [self fh_bottomTopBanner];
    [self getListInfo];
}

- (void)fh_getTopBanner {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    if (topBannerArrays.count > 0) {
        [topBannerArrays removeAllObjects];
    } else {
         topBannerArrays = [[NSMutableArray alloc] init];
    }
    if (topUrlArrays.count > 0) {
        [topUrlArrays removeAllObjects];
    } else {
        topUrlArrays = [[NSMutableArray alloc] init];
    }
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(1),@"type", nil];
    
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        NSArray *upDicArr = Dic[@"uplist"];
        [self endRefreshAction];
        for (NSDictionary *dic in upDicArr) {
            [self->topBannerArrays addObject:dic[@"path"]];
            [self->topUrlArrays addObject:dic[@"url"]];
        }
        
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [self endRefreshAction];
        [weakSelf.homeTable reloadData];
    }];
}

- (void)fh_bottomTopBanner {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    if (bottomBannerArrays.count >0) {
        [bottomBannerArrays removeAllObjects];
    } else {
        bottomBannerArrays = [[NSMutableArray alloc] init];
    }
    if (bottomUrlArrays.count > 0) {
        [bottomUrlArrays removeAllObjects];
    } else {
      bottomUrlArrays = [[NSMutableArray alloc] init];
    }
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(1),@"type", nil];
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        NSArray *upDicArr = Dic[@"downlist"];
        [self endRefreshAction];
        for (NSDictionary *dic in upDicArr) {
            [self->bottomBannerArrays addObject:dic[@"path"]];
            [self->bottomUrlArrays addObject:dic[@"url"]];
        }
        
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [self endRefreshAction];
        [weakSelf.homeTable reloadData];
    }];
}

- (void)getListInfo {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @"5",@"limit",
                               @"1",@"type", nil];
    [AFNetWorkTool get:@"ScrollNew/getListInfo" params:paramsDic success:^(id responseObj) {
        self.soureArray = [[NSMutableArray alloc] init];
        if ([responseObj[@"code"] integerValue] == 1) {
            [self endRefreshAction];
            NSArray *arr = responseObj[@"data"][@"list"];
            for (NSDictionary * dic in arr) {
                [self.soureArray addObject:dic[@"title"]];
            }
            [weakSelf.homeTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self endRefreshAction];
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
        
        [locationView addSubview:self.messageImgView];
        
        self.verticalMarquee = [[JhtVerticalMarquee alloc] initWithFrame:CGRectMake(40,( SCREEN_WIDTH * 0.116 - 25 ) / 2, SCREEN_WIDTH - 55 - SCREEN_WIDTH * 0.116, 25)];
        self.verticalMarquee.verticalTextColor = [UIColor blackColor];
        self.verticalMarquee.verticalTextFont = [UIFont systemFontOfSize:15];
        self.verticalMarquee.verticalTextAlignment = NSTextAlignmentLeft;
        // 添加点击手势
        UITapGestureRecognizer *vtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marqueeTapGes:)];
        [self.verticalMarquee addGestureRecognizer:vtap];
        [locationView addSubview:self.verticalMarquee];
//        NSArray *soureArray = @[@"1. 谁曾从谁的青春里走过，留下了笑靥",
//                                @"2. 谁曾在谁的花季里停留，温暖了想念",
//                                @"3. 谁又从谁的雨季里消失，泛滥了眼泪"
//                                ];
        
        self.verticalMarquee.sourceArray = self.soureArray;
        // 开始滚动
        [self.verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
        
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
        NSArray *urlsArray = [topBannerArrays copy];
//        NSArray *urlsArray = @[@"奔驰1",@"奔驰2",@"奔驰3"];
        self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2018];
        
        [cell addSubview:self.topScrollView];
        return cell;
    } else if (indexPath.row == 2) {
        /** 菜单列表数据 */
        FHMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMenuListCell class])];
        cell.delegate = self;
        cell.bottomLogoNameArrs = self.bottomLogoNameArrs;
        cell.bottomImgArrs = self.bottomImgArrs;
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
        NSArray *urlsArray = [bottomBannerArrays copy];
//        NSArray *urlsArray = @[@"长安汽车 2",@"长安汽车 3",@"长安汽车 4"];
        self.bottomScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2019];
        
        [cell addSubview:self.bottomScrollView];
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


#pragma mark  -- 点击banner的代理方法
/** 点击图片*/
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    if (infiniteScrollView.tag == 2018) {
        NSString *urlString = topUrlArrays[index];
        /** 上面的轮播图 */
        [self pushToWebControllerWithUrl:urlString];
    } else {
       /** 下面的轮播图 */
        NSString *urlString = bottomUrlArrays[index];
        [self pushToWebControllerWithUrl:urlString];
    }
}

- (void)pushToWebControllerWithUrl:(NSString *)url {
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark — FHMenuListCellDelegate
- (void)FHMenuListCellSelectIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        /** 物业服务 */
        FHHomeServicesController *home = [[FHHomeServicesController alloc] init];
        [self pushVCWithName:home];
    } else if (indexPath.row == 1) {
        /** 业主服务 */
        FHOwnerServiceController *owner = [[FHOwnerServiceController alloc] init];
        [self pushVCWithName:owner];
    } else if (indexPath.row == 2) {
        /** 健康服务 */
        FHHealthServicesController *health = [[FHHealthServicesController alloc] init];
        [self pushVCWithName:health];
    } else if (indexPath.row == 3) {
        [SingleManager shareManager].selectType = @"HomePage";
        /** 生鲜服务 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.shopID = self.shopID;
        goodList.titleString = @"生鲜商城";
        [self pushVCWithName:goodList];
    } else if (indexPath.row == 4) {
        /** 理财服务 */
        FHFinancialServiceController *finacial = [[FHFinancialServiceController alloc] init];
        [self pushVCWithName:finacial];
    } else if (indexPath.row == 5) {
        /** 客服服务 */
        FHCustomerServiceController *custom = [[FHCustomerServiceController alloc] init];
        [self pushVCWithName:custom];
    }
}

- (void)pushVCWithName:(BaseViewController *)vcName {
    [self.navigationController pushViewController:vcName animated:YES];
}

- (void)FHLittleMenuListCellSelectIndex:(NSIndexPath *)selectIndex {
    if (selectIndex.row == 0) {
        /** 扫一扫 */
        
    } else if (selectIndex.row == 1) {
        /** 付款 */
        
    } else if (selectIndex.row == 2) {
        /** 收款 */
        
    } else if (selectIndex.row == 3) {
        /** 生活缴费 */
        
    } else if (selectIndex.row == 4) {
        /** 财富园 */
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.homeTable.mj_header;
    MJRefreshFooter *footer = self.homeTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
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
        _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fefreshBanner)];
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (UIImageView *)messageImgView {
    if (!_messageImgView) {
        _messageImgView = [[UIImageView alloc]init];
        _messageImgView.image =[UIImage imageNamed:@"message_laba_icon"];
        _messageImgView.frame = CGRectMake(10, 14, 22, 22);
    }
    return _messageImgView;
}

@end
