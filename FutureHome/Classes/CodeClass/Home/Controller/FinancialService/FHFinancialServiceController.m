//
//  FHFinancialServiceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  理财服务

#import "FHFinancialServiceController.h"
#import "FHCommonCollectionViewCell.h"
#import "FHLittleMenuListCell.h"
#import "FHBaseAnnouncementListController.h"
#import "FHWebViewController.h"
#import <JhtMarquee/JhtHorizontalMarquee.h>
#import <JhtMarquee/JhtVerticalMarquee.h>
#import "FHScrollNewsController.h"

@interface FHFinancialServiceController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,FHCommonCollectionViewDelegate>
{
    NSMutableArray *topBannerArrays;
    NSMutableArray *bottomBannerArrays;
    NSMutableArray *topUrlArrays;
    NSMutableArray *bottomUrlArrays;
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
/** 上面的logoName */
@property (nonatomic, copy) NSArray *topLogoNameArrs;
/** 下面的image */
@property (nonatomic, copy) NSArray *bottomImageArrs;
// 纵向 跑马灯
@property (nonatomic,strong) JhtVerticalMarquee      *verticalMarquee;
/**消息图标*/
@property (nonatomic,strong) UIImageView             *messageImgView;
/** 滚动消息数组 */
@property (nonatomic, strong) NSMutableArray *soureArray;

@end

@implementation FHFinancialServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    self.bottomLogoNameArrs = @[@"生鲜行情",
                                @"房产大观",
                                @"经济头条",
                                @"民生资讯",
                                @"国际资讯",
                                @"投资观察",
                                @"基金保险",
                                @"股票期货",
                                @"黄金白银",
                                @"全球外汇"];
    self.bottomImageArrs = @[@"5-1生鲜行情",
                             @"5-2房产资讯",
                             @"5-3经济头条",
                             @"5-4民生资讯",
                             @"5-5国际资讯",
                             @"5-6投资观察",
                             @"5-7基金保险",
                             @"5-8股票期货",
                             @"5-9黄金白银",
                             @"5-10全球外汇"];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHLittleMenuListCell class] forCellReuseIdentifier:NSStringFromClass([FHLittleMenuListCell class])];
    [self.homeTable registerClass:[FHCommonCollectionViewCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonCollectionViewCell class])];
    /** 获取banner数据 */
    [self fh_refreshBannerData];
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


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"理财服务";
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
    [self getListInfo];
}

- (void)fh_getTopBanner {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    topBannerArrays = [[NSMutableArray alloc] init];
    topUrlArrays = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(5),@"type", nil];
    
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        NSArray *upDicArr = Dic[@"uplist"];
        for (NSDictionary *dic in upDicArr) {
            [self->topBannerArrays addObject:dic[@"path"]];
            [self->topUrlArrays addObject:dic[@"url"]];
        }
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

- (void)fh_bottomTopBanner {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    bottomBannerArrays = [[NSMutableArray alloc] init];
    bottomUrlArrays = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(5),@"type", nil];
    [AFNetWorkTool get:@"future/advent" params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        NSArray *upDicArr = Dic[@"downlist"];
        for (NSDictionary *dic in upDicArr) {
            [self->bottomBannerArrays addObject:dic[@"path"]];
            [self->bottomUrlArrays addObject:dic[@"url"]];
        }
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

- (void)getListInfo {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @"5",@"limit",
                               @"3",@"type", nil];
    [AFNetWorkTool get:@"ScrollNew/getListInfo" params:paramsDic success:^(id responseObj) {
        self.soureArray = [[NSMutableArray alloc] init];
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *arr = responseObj[@"data"][@"list"];
            for (NSDictionary * dic in arr) {
                [self.soureArray addObject:dic[@"title"]];
            }
            [weakSelf.homeTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
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
//        NSArray *urlsArray = @[@"七匹狼 5",@"七匹狼 6",@"七匹狼 8"];
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
        NSArray *urlsArray = [bottomBannerArrays copy];
//        NSArray *urlsArray = @[@"P30 3",@"P30 4",@"P30 5",@"P30 6"];
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

#pragma mark Get Method
/** 点击 滚动跑马灯 触发方法 */
- (void)marqueeTapGes:(UITapGestureRecognizer *)ges {
    [self.verticalMarquee marqueeOfSettingWithState:MarqueePause_V];
    //    [self.navigationController pushViewController:[[testVC alloc] init] animated:YES];
    /** 点击进入滚动消息 */
    FHScrollNewsController *news = [[FHScrollNewsController alloc] init];
    news.type = @"3";
    news.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:news animated:YES];
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
        /** 生鲜行情 */
        [self pushAnnouncementControllerWithTitle:@"生鲜行情" ID:1];
    } else if (selectIndex.row == 1) {
        /** 房产大观 */
        [self pushAnnouncementControllerWithTitle:@"房产大观" ID:2];
    } else if (selectIndex.row == 2) {
        /** 经济头条 */
        [self pushAnnouncementControllerWithTitle:@"经济头条" ID:3];
    } else if (selectIndex.row == 3) {
        /** 民生资讯 */
        [self pushAnnouncementControllerWithTitle:@"民生资讯" ID:4];
    } else if (selectIndex.row == 4) {
        /** 国际资讯 */
        [self pushAnnouncementControllerWithTitle:@"国际资讯" ID:5];
    } else if (selectIndex.row == 5) {
        /** 投资观察 */
        [self pushAnnouncementControllerWithTitle:@"投资观察" ID:6];
    } else if (selectIndex.row == 6) {
        /** 基金保险 */
        [self pushAnnouncementControllerWithTitle:@"基金保险" ID:7];
    } else if (selectIndex.row == 7) {
        /** 股票期货 */
         [self pushAnnouncementControllerWithTitle:@"股票期货" ID:8];
    } else if (selectIndex.row == 8) {
        /** 黄金白银 */
        [self pushAnnouncementControllerWithTitle:@"黄金白银" ID:9];
    } else if (selectIndex.row == 9) {
        /** 全球外汇 */
        [self pushAnnouncementControllerWithTitle:@"全球外汇" ID:10];
    }
}

- (void)pushAnnouncementControllerWithTitle:(NSString *)title
                                         ID:(NSInteger )ID {
    FHBaseAnnouncementListController *an = [[FHBaseAnnouncementListController alloc] init];
    an.titleString = title;
    an.hidesBottomBarWhenPushed = YES;
    an.type = 3;
    an.ID = ID;
    [self.navigationController pushViewController:an animated:YES];
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

- (UIImageView *)messageImgView {
    if (!_messageImgView) {
        _messageImgView = [[UIImageView alloc]init];
        _messageImgView.image =[UIImage imageNamed:@"message_laba_icon"];
        _messageImgView.frame = CGRectMake(10, 14, 22, 22);
    }
    return _messageImgView;
}

@end
