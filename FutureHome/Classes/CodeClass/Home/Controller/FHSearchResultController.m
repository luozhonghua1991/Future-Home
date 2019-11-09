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

@interface FHSearchResultController () <UITableViewDelegate,UITableViewDataSource,FHSearchResultCellDelegate>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 搜索数据Arrs */
@property (nonatomic, strong) NSMutableArray *searchResultArrs;


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSearchResult:) name:@"GETSEARCHRESULT" object:nil];
    
}

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
    [self.homeTable.mj_footer endRefreshingWithNoMoreData];
//    if (++curPage <= tolPage) {
//        [self getSearchResultLoadHead:NO searchTitle:self.searchText];
//    } else {
//        [self.homeTable.mj_footer endRefreshingWithNoMoreData];
//    }
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
                               self.type,@"type",
                               title ? title : @"",@"title",
                               /** 经纬度 */
                               @"106.311932",@"slng",
                               @"29.586336",@"slat",
                               nil];
    
    [AFNetWorkTool get:@"public/search" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [self.searchResultArrs removeAllObjects];
            }
            [self endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [self.searchResultArrs addObjectsFromArray:[FHSearchResultModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
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
    if ([self.type isEqualToString:@"1"]) {
        cell.distanceLabel.hidden = YES;
    } else {
        cell.distanceLabel.hidden = NO;
    }
    cell.resultModel = self.searchResultArrs[indexPath.row];
    cell.rightBtn.tag = indexPath.row;
    [cell.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (![self.type isEqualToString:@"1"]) {
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
            /** 未关注 */
            cell.rightBtn.layer.borderColor = [UIColor orangeColor].CGColor;
            [cell.rightBtn setTitle:@"+关注" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            cell.rightBtn.enabled = YES;
        } else if ([cell.resultModel.is_collect isEqualToString:@"1"]){
            /** 已关注 */
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
}

- (void)fh_selectAvaterWithModel:(FHSearchResultModel *)model {
    if ([self.type isEqualToString:@"1"]) {
        /** 搜索用户 跳到用户的动态 */
        /** 去用户的动态 */
        FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
        vc.titleString = model.name;
        [SingleManager shareManager].isSelectPerson = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.user_id = model.id;
        vc.personType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark — event
- (void)rightBtnClick:(UIButton *)sender {
    FHSearchResultModel *resultModel = self.searchResultArrs[sender.tag];
    Account *account = [AccountStorage readAccount];
    NSString *urlString;
    NSDictionary *paramsDic;
    if ([self.type isEqualToString:@"1"]) {
        urlString = @"sheyun/doFollow";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     resultModel.id,@"follow_id", nil];
    } else {
        NSInteger type;
        if ([self.type isEqualToString:@"3"]) {
            type = 1;
        } else if([self.type isEqualToString:@"2"]){
            type = 2;
        } else {
            type = [self.type integerValue] - 1;
        }
        urlString = @"public/collect";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     resultModel.id,@"id",
                     @(type),@"type",nil];
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
