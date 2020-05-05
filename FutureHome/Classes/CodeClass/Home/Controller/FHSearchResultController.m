//
//  FHSearchResultController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHSearchResultController.h"
#import "FHSearchResultCell.h"
#import "FHSearchResultModel.h"
#import "FHPersonTrendsController.h"
#import "FHFreshMallController.h"
#import "FHHomeServicesController.h"
#import "FHOwnerServiceController.h"

@interface FHSearchResultController () <UITableViewDelegate,UITableViewDataSource,FHSearchResultCellDelegate>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 搜索数据Arrs */
@property (nonatomic, strong) NSMutableArray *searchResultArrs;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSArray *dataArr;


@end

@implementation FHSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResultArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHSearchResultCell class] forCellReuseIdentifier:NSStringFromClass([FHSearchResultCell class])];
    [self.view addSubview:self.homeTable];
    [self loadInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchResult:) name:@"GETSEARCHRESULT" object:nil];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GETSEARCHRESULT" object:nil];
}

- (void)getSearchResult:(NSNotification *)notification {
    self.searchText = [notification.userInfo objectForKey:@"searchText"];
    [self getSearchResultLoadHead:YES searchTitle:self.searchText];
}

#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.homeTable.mj_footer resetNoMoreData];
    
    [self getSearchResultLoadHead:YES searchTitle:self.searchText];
}

- (void)footerReload {
    if (self.dataArr.count >= 20) {
        curPage ++;
        [self getSearchResultLoadHead:NO searchTitle:self.searchText];
    } else {
        [self.homeTable.mj_footer endRefreshingWithNoMoreData];
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


#pragma mark — request
- (void)getSearchResultLoadHead:(BOOL)isHead searchTitle:(NSString *)title {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(curPage),@"page",
                               @(10),@"pageSize",
                               self.type,@"type",
                               title ? title : @"",@"title",
                               /** 经纬度 */
                               [SingleManager shareManager].strlongitude,@"slng",
                               [SingleManager shareManager].strlatitude,@"slat",
                               nil];
    
    [AFNetWorkTool get:@"public/search" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [self.searchResultArrs removeAllObjects];
            }
            [self endRefreshAction];
            self.dataArr = responseObj[@"data"][@"list"];
            if (self.dataArr.count > 0) {
                [self.searchResultArrs addObjectsFromArray:[FHSearchResultModel mj_objectArrayWithKeyValuesArray:self.dataArr]];
            }
            [weakSelf.homeTable reloadData];
        } else {
            [self.searchResultArrs removeAllObjects];
            [self endRefreshAction];
            [self.view makeToast:responseObj[@"msg"]];
            [weakSelf.homeTable reloadData];
        }
    } failure:^(NSError *error) {
        [self endRefreshAction];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHSearchResultCell class])];
    cell.delegate = self;
    if ([self.type isEqualToString:@"0"]) {
        cell.distanceLabel.hidden = YES;
    } else {
        cell.distanceLabel.hidden = NO;
    }
    cell.resultModel = self.searchResultArrs[indexPath.row];
    cell.rightBtn.tag = indexPath.row;
    [cell.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (![self.type isEqualToString:@"0"]) {
        if ([cell.resultModel.is_collect isEqualToString:@"0"]) {
            /** 未收藏 */
            cell.rightBtn.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.rightBtn setTitle:@"+收藏" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            cell.rightBtn.enabled = YES;
        } else if ([cell.resultModel.is_collect isEqualToString:@"1"]){
            /** 已收藏 */
            cell.rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [cell.rightBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cell.rightBtn.enabled = NO;
        }
    } else {
        /** 关注和未关注 */
        if ([cell.resultModel.is_collect isEqualToString:@"0"]) {
            Account *account = [AccountStorage readAccount];
            if ([cell.resultModel.id integerValue] == account.user_id) {
                cell.rightBtn.hidden = YES;
            } else {
                cell.rightBtn.hidden = NO;
            }
            /** 未关注 */
            cell.rightBtn.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.rightBtn setTitle:@"+关注" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            cell.rightBtn.enabled = YES;
        } else if ([cell.resultModel.is_collect isEqualToString:@"1"]){
            /** 已关注 */
            cell.rightBtn.hidden = NO;
            cell.rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [cell.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cell.rightBtn.enabled = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHSearchResultModel *resultModel = self.searchResultArrs[indexPath.row];
    [self fh_selectAvaterWithModel:resultModel];
}

- (void)fh_selectAvaterWithModel:(FHSearchResultModel *)model {
    [SingleManager shareManager].selectType = @"HomePage";
    if ([self.type isEqualToString:@"0"]) {
        /** 搜索用户 跳到用户的动态 */
        /** 去用户的动态 */
        FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
        vc.titleString = model.name;
        [SingleManager shareManager].isSelectPerson = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.user_id = model.id;
        vc.personType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.type isEqualToString:@"1"]) {
        /** 物业 */
        FHHomeServicesController *home = [[FHHomeServicesController alloc]init];
        home.model = (FHCommonFollowModel *)model;
        [home setHomeSeverID:[model.id integerValue] homeServerName:model.name];
        home.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:home animated:YES];
    } else if ([self.type isEqualToString:@"2"]) {
        /** 业主 */
        FHOwnerServiceController*home = [[FHOwnerServiceController alloc]init];
        home.model = (FHCommonFollowModel *)model;
        [home setHomeSeverID:[model.id integerValue] homeServerName:model.name];
        home.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:home animated:YES];
    } else if ([self.type isEqualToString:@"3"]) {
        /** 生鲜 */
        /** 生鲜服务 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.titleString = @"生鲜商城";
        goodList.shopID = model.id;
        goodList.isCollect = model.is_collect;
        [self.navigationController pushViewController:goodList animated:YES];
    } else if ([self.type isEqualToString:@"4"]) {
        /** 商业 */
        /** 商业服务 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.titleString = @"商业商城";
        goodList.shopID = model.id;
        goodList.isCollect = model.is_collect;
        [self.navigationController pushViewController:goodList animated:YES];
    } else if ([self.type isEqualToString:@"5"]) {
        /** 医药 */
        /** 医药服务 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.titleString = @"企业商城";
        goodList.shopID = model.id;
        goodList.isCollect = model.is_collect;
        [self.navigationController pushViewController:goodList animated:YES];
    }
}


#pragma mark — event
- (void)rightBtnClick:(UIButton *)sender {
    FHSearchResultModel *resultModel = self.searchResultArrs[sender.tag];
    Account *account = [AccountStorage readAccount];
    NSString *urlString;
    NSDictionary *paramsDic;
    if ([self.type isEqualToString:@"0"]) {
        urlString = @"sheyun/doFollow";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     resultModel.id,@"follow_id", nil];
    } else {
        urlString = @"public/collect";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     resultModel.id,@"id",
                     self.type,@"type",nil];
    }
    [self cancleCollectRequest:urlString parmars:paramsDic];
}

- (void)cancleCollectRequest:(NSString *)urlString
                     parmars:(NSDictionary *)paramsDic {
    
    WS(weakSelf);
    [AFNetWorkTool post:urlString params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf getSearchResultLoadHead:YES searchTitle:weakSelf.searchText];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.view makeToast:@"服务器加载异常"];
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"暂无相关数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:167/255.0 green:181/255.0 blue:194/255.0 alpha:1/1.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
        _homeTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
        _homeTable.emptyDataSetSource = self;
        _homeTable.emptyDataSetDelegate = self;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
