//
//  FHOwnerServiceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  业主服务

#import "FHOwnerServiceController.h"
#import "FHCommonCollectionViewCell.h"
#import "FHBaseAnnouncementListController.h"
#import "FHWebViewController.h"
#import "FHFreshMallFollowListController.h"
#import "FHBaseAnnouncementListController.h"
#import "FHSuggestionController.h"
#import "FHElectionofIndustryCommitteeMainController.h"
#import "FHMyIndustryCommitteeController.h"
#import "FHAuthModel.h"
#import "FHOwnerCertificationController.h"
#import "FHHomePageController.h"
#import "FHScanDetailAlertView.h"

@interface FHOwnerServiceController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,FHCommonCollectionViewDelegate>
{
    NSMutableArray *topBannerArrays;
    NSMutableArray *bottomBannerArrays;
    NSMutableArray *topUrlArrays;
    NSMutableArray *bottomUrlArrays;
    NSInteger property_id;
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
/** <#strong属性注释#> */
@property (nonatomic, strong) FHAuthModel *authModel;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHScanDetailAlertView *codeDetailView;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *userName;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger is_collect;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIButton *followBtn;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *name;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat lat;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat lng;
/** 导航label */
@property (nonatomic, strong) UILabel *navigationLabel;

@end

@implementation FHOwnerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    self.bottomLogoNameArrs = @[@"公告通知",
                                @"业主大会",
                                @"业委管理",
                                @"财务管理",
                                @"选举服务",
                                @"物业管理",
                                @"招标服务",
                                @"活动关爱",
                                @"投诉建议",
                                @"业主认证"];
    self.bottomImageArrs = @[@"3-1业委公告",
                             @"3-2业主大会",
                             @"3-4业委管理",
                             @"3-7 财务管理",
                             @"3-3业委选举",
                             @"3-5物业管理",
                             @"3-6 物业招标",
                             @"3-8活动关爱",
                             @"3-9投诉建议",
                             @"3-10我的业委"];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHCommonCollectionViewCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonCollectionViewCell class])];
    
    
    if (self.model) {
        return;
    }
    
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(2),@"type", nil];
    [AFNetWorkTool get:@"userCenter/collection" params:paramsDic success:^(id responseObj) {
        NSArray *arr = responseObj[@"data"][@"list"];
        NSDictionary *dic = arr[0];
        self.is_collect = [dic[@"is_collect"] integerValue];
        self->property_id = [dic[@"id"] integerValue];
        self.userName = dic[@"username"];
        self.name = dic[@"name"];
        self.lat = [dic[@"lat"] floatValue];
        self.lng = [dic[@"lng"] floatValue];
        if (self.is_collect == 0) {
            [self.followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
        } else {
            [self.followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
        }
        /** 获取banner数据 */
        [self fh_refreshBannerData];
    } failure:^(NSError *error) {
        /** 获取banner数据 */
        [self fh_refreshBannerData];
    }];
}

- (void)setHomeSeverID:(NSInteger )HomeSeverID
        homeServerName:(NSString *)homeServerName {
//    property_id = HomeSeverID;
//    self.name = homeServerName;
//    self.userName = self.model.username;
    /** 获取banner数据 */
//    [self fh_refreshBannerData];
    
    property_id = HomeSeverID;
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(HomeSeverID),@"id",
                               @(2),@"type", nil];
    [AFNetWorkTool get:@"future/getEntityById" params:paramsDic success:^(id responseObj) {
        NSDictionary *dic = responseObj[@"data"];
        weakSelf.is_collect = [dic[@"iscollection"] integerValue];
        weakSelf.name = dic[@"name"];
        weakSelf.userName = dic[@"login"];
        weakSelf.lat = [dic[@"lat"] floatValue];
        weakSelf.lng = [dic[@"lng"] floatValue];
        if (self.is_collect == 0) {
            [self.followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
        } else {
            [self.followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
        }
        /** 获取banner数据 */
        [self fh_refreshBannerData];
    } failure:^(NSError *error) {
        /** 获取banner数据 */
        [self fh_refreshBannerData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"业主服务";
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
    
    [self fh_creatNavBtn];
}

- (void)fh_creatNavBtn {
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 35 * 3 - 15, MainStatusBarHeight, 35, 35);
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navgationView addSubview:shareBtn];
    
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.frame = CGRectMake(SCREEN_WIDTH - 28 * 2  - 20, MainStatusBarHeight +3, 28, 28);
    if (!self.isFollow) {
        [self.followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
    } else {
        [self.followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
    }
    [self.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:self.followBtn];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(SCREEN_WIDTH - 33, MainStatusBarHeight +5, 28, 28);
    [menuBtn setImage:[UIImage imageNamed:@"chazhaobiaodanliebiao"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:menuBtn];
}

- (void)backBtnClick {
    __block FHHomePageController *meVC ;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *  obj, NSUInteger idx, BOOL *  stop) {
        if([obj isKindOfClass:[FHHomePageController class]]) {
            meVC = (FHHomePageController *)obj;
            [self.navigationController popToViewController:meVC animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


#pragma mark — request
- (void)fh_refreshBannerData {
    [self fh_getTopBanner];
    [self fh_bottomTopBanner];
}

- (void)fh_getTopBanner {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    topBannerArrays = [[NSMutableArray alloc] init];
    topUrlArrays = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(property_id),@"pid",
                               @(3),@"type", nil];
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
                               @(property_id),@"pid",
                               @(3),@"type", nil];
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


#pragma mark — event
/** 收藏按钮 */
- (void)followBtnClick {
    if (self.is_collect == 1 || self.isFollow) {
        [self.view makeToast:@"您已经收藏,请勿重复操作"];
        return;
    }
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *urlString;
    NSDictionary *paramsDic;
    urlString = @"public/collect";
    paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 @(account.user_id),@"user_id",
                 @(property_id),@"id",
                 @"2",@"type",nil];
    [AFNetWorkTool post:urlString params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

/** 搜索事件 */
- (void)searchBtnClick {
    
}

/** 菜单按钮 */
- (void)menuBtnClick {
    /** 去到收藏列表 */
    FHFreshMallFollowListController *listVC = [[FHFreshMallFollowListController alloc] init];
//    listVC.hidesBottomBarWhenPushed = YES;
//    listVC.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = YES;
    listVC.titleString = @"业委收藏";
    listVC.type = @"2";
    [self.navigationController pushViewController:listVC animated:YES];
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
        self.realSstateSNameLabel.text = self.name;
        self.realSstateSNameLabel.textColor = [UIColor blueColor];
        self.realSstateSNameLabel.font = [UIFont systemFontOfSize:15];
        self.realSstateSNameLabel.textAlignment = NSTextAlignmentCenter;
        [locationView addSubview:self.realSstateSNameLabel];
        
        self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH * 0.116 - 20, SCREEN_WIDTH * 0.116 - 20)];
        self.codeImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.codeImgView.image = [UIImage imageNamed:@"black_erweima"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        self.codeImgView.userInteractionEnabled = YES;
        [self.codeImgView addGestureRecognizer:tap];
        [locationView addSubview:self.codeImgView];
        
        self.navigationLabel.frame = CGRectMake(SCREEN_WIDTH - 65, 12, 50, 12);
        self.navigationLabel.centerY = locationView.height / 2;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationLabelClick)];
        self.navigationLabel.userInteractionEnabled = YES;
        [self.navigationLabel addGestureRecognizer:tap1];
        [locationView addSubview:self.navigationLabel];
        
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
//        NSArray *urlsArray = @[@"农业公司 1",@"农业公司 2",@"农业公司 3"];
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
//        NSArray *urlsArray = [[NSArray alloc] init];
        NSArray *urlsArray = [bottomBannerArrays copy];
//        NSArray *urlsArray = @[@"金典牛奶 1",@"金典牛奶 2",@"金典牛奶 3"];
        self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:urlsArray scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2019];
        
        [cell addSubview:self.topScrollView];
        return cell;
    }
}

- (void)navigationLabelClick {
    /** y一键导航事件 */
    [CQRouteManager presentRouteNaviMenuOnController:self withCoordate:CLLocationCoordinate2DMake(self.lat, self.lng) destination:self.realSstateSNameLabel.text];
}

- (void)tapClick {
    self.codeDetailView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
    [UIView animateWithDuration:0.3 animations:^{
        self.codeDetailView.alpha = 1;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
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


#pragma mark — FHCommonCollectionViewDelegate
- (void)FHCommonCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex {
    if (selectIndex.row == 0) {
        /** 公告通知 */
        [self pushAnnouncementControllerWithTitle:@"公告通知" ID:1];
    } else if (selectIndex.row == 1) {
        /** 业主大会 */
        [self pushAnnouncementControllerWithTitle:@"业主大会" ID:2];
    } else if (selectIndex.row == 2) {
        /** 业委管理 */
        [self pushAnnouncementControllerWithTitle:@"业委管理" ID:3];
    } else if (selectIndex.row == 3) {
        /** 财务管理 */
        [self pushAnnouncementControllerWithTitle:@"财务管理" ID:4];
    } else if (selectIndex.row == 4) {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   @(property_id),@"owner_id",
                                   nil];
        
        [AFNetWorkTool get:@"owner/isAuth" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                if ([responseObj[@"data"][@"audit_status"] integerValue] == 0) {
                    [self.view makeToast:@"请提交业主认证"];
                    return ;
                } else if ([responseObj[@"data"][@"audit_status"] integerValue] == 1) {
                    [self.view makeToast:@"资料认证中"];
                    return ;
                } else if ([responseObj[@"data"][@"audit_status"] integerValue] == 2) {
                    /** 选举服务 */
                    FHElectionofIndustryCommitteeMainController *vc = [[FHElectionofIndustryCommitteeMainController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.titleString = @"选举服务";
                    vc.property_id = self->property_id;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([responseObj[@"data"][@"audit_status"] integerValue] == 3) {
                    [self.view makeToast:@"资料审核失败,请重新提交"];
                    return;
                }
            } else {
                
            }
        } failure:^(NSError *error) {
            [weakSelf.homeTable reloadData];
        }];
    } else if (selectIndex.row == 5) {
        /** 物业管理 */
        [self pushAnnouncementControllerWithTitle:@"物业管理" ID:9];
    } else if (selectIndex.row == 6) {
        /** 招标服务 */
//        [self pushAnnouncementControllerWithTitle:@"招标服务"];
        FHBaseAnnouncementListController *an = [[FHBaseAnnouncementListController alloc] init];
        an.titleString = @"招标服务";
        an.webTitleString = @"招标服务";
        an.hidesBottomBarWhenPushed = YES;
        an.isHaveSectionView = YES;
        an.ID = 10;
        an.type = 2;
        an.property_id = property_id;
        [self.navigationController pushViewController:an animated:YES];
    } else if (selectIndex.row == 7) {
        /** 活动关爱 */
        [self pushAnnouncementControllerWithTitle:@"活动关爱" ID:11];
    } else if (selectIndex.row == 8) {
        /** 投诉建议 */
        FHSuggestionController *vc = [[FHSuggestionController alloc] init];
        vc.titleString = @"投诉建议";
        vc.property_id = property_id;
        vc.type = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (selectIndex.row == 9) {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   @(property_id),@"owner_id",
                                   nil];
        
        [AFNetWorkTool get:@"owner/isAuth" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                
                if ([responseObj[@"data"][@"audit_status"] integerValue] == 0 || [responseObj[@"data"][@"audit_status"] integerValue] == 3) {
                    FHMyIndustryCommitteeController *vc = [[FHMyIndustryCommitteeController alloc] init];
                    vc.property_id = self->property_id;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([responseObj[@"data"][@"audit_status"] integerValue] == 1) {
                    [self.view makeToast:@"资料认证中"];
                    return ;
                } else if ([responseObj[@"data"][@"audit_status"] integerValue] == 2) {
                    /** 认证通过 */
                    FHOwnerCertificationController *messageVC = [[FHOwnerCertificationController alloc] init];
                    messageVC.authModel = [FHAuthModel mj_objectWithKeyValues:responseObj[@"data"]];
                    messageVC.hidesBottomBarWhenPushed = YES;
                    messageVC.type = @"我的业委";
                    [self.navigationController pushViewController:messageVC animated:YES];
                }
            } else {
                
            }
        } failure:^(NSError *error) {
            [weakSelf.homeTable reloadData];
        }];
    }
}

- (void)pushAnnouncementControllerWithTitle:(NSString *)title
                                         ID:(NSInteger )ID {
    FHBaseAnnouncementListController *an = [[FHBaseAnnouncementListController alloc] init];
    an.titleString = title;
    an.webTitleString = title;
    an.type = 2;
    an.ID = ID;
    an.property_id = property_id;
    an.hidesBottomBarWhenPushed = YES;
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

- (FHScanDetailAlertView *)codeDetailView {
    if (!_codeDetailView) {
        _codeDetailView = [[FHScanDetailAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"com.sheyun",@"app_key",
                                   @(property_id),@"id",
                                   self.realSstateSNameLabel.text,@"name",
                                   self.userName,@"username",
                                   @"2",@"type",
                                   nil];
//        NSDictionary *codeDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"com.sheyun",@"app_key",
//                                   @(property_id),@"id",
//                                   @"2",@"type",
//                                   nil];
        _codeDetailView.dataDetaildic = paramsDic;
        //_codeDetailView.scanCodeDic = codeDic;
    }
    return _codeDetailView;
}

- (UILabel  *)navigationLabel{
    if (!_navigationLabel) {
        _navigationLabel =  [[UILabel alloc] init];
        _navigationLabel.text = @"一键导航";
        _navigationLabel.textColor = [UIColor blueColor];
        _navigationLabel.font = [UIFont systemFontOfSize:12];
        _navigationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabel;
}

@end
