//
//  FHCollectListViewController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  全类收藏列表界面

#import "FHCollectListViewController.h"
#import "FHCollectListCell.h"
#import "FHFreshMallController.h"
#import "FHSearchResultModel.h"
#import "FHCommonFollowModel.h"

#import "FHSearchResultCell.h"
#import "FHCommonFollowAndPlacementCell.h"

@interface FHCollectListViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FHCommonFollowAndPlacementCellDelegate,
FDActionSheetDelegate,
FHSearchResultCellDelegate
>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *dataArrs;
/** 收藏的主键 */
@property (nonatomic, copy) NSString *cid;

@end

@implementation FHCollectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHCommonFollowAndPlacementCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonFollowAndPlacementCell class])];
    [self.homeTable registerClass:[FHSearchResultCell class] forCellReuseIdentifier:NSStringFromClass([FHSearchResultCell class])];
    [self.view addSubview:self.homeTable];
    [self loadInit];
}

#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.homeTable.mj_footer resetNoMoreData];
    
    [self getRequestDataLoadHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getRequestDataLoadHead:NO];
    } else {
        [self.homeTable.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction {
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
- (void)getRequestDataLoadHead:(BOOL)isHead {
    if (![self.type isEqualToString:@"2019"]) {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   self.type,@"type",
                                   @(curPage),@"page",
                                   nil];
        [AFNetWorkTool get:@"userCenter/collectList" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                if (isHead) {
                    [self.dataArrs removeAllObjects];
                }
                [self endRefreshAction];
                self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
                [self.dataArrs addObjectsFromArray:[FHCommonFollowModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
                [weakSelf.homeTable reloadData];
            } else {
                [self endRefreshAction];
                [self.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            [weakSelf.homeTable reloadData];
        }];
    } else {
        /** 附近的人 专门写的 */
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   @(curPage),@"page",
                                   @"106.311932",@"slng",
                                   @"29.586336",@"slat",
                                   nil];
        [AFNetWorkTool get:@"sheyun/searchNearby" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                if (isHead) {
                    [self.dataArrs removeAllObjects];
                }
                [self endRefreshAction];
                self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
                [self.dataArrs addObjectsFromArray:[FHSearchResultModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
                [weakSelf.homeTable reloadData];
            } else {
                [self endRefreshAction];
                [self.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            [weakSelf.homeTable reloadData];
        }];
    }
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type isEqualToString:@"2019"]) {
        return 92.0;
    }
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.type isEqualToString:@"2019"]) {
        FHCommonFollowAndPlacementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonFollowAndPlacementCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.followModel = self.dataArrs[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    FHSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHSearchResultCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.resultModel = self.dataArrs[indexPath.row];
    cell.delegate = self;
    cell.rightBtn.tag = indexPath.row;
    [cell.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([cell.resultModel.is_collect isEqualToString:@"0"]) {
        /** 未收藏 */
        cell.rightBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        [cell.rightBtn setTitle:@"+收藏" forState:UIControlStateNormal];
        [cell.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cell.rightBtn.enabled = YES;
    } else if ([cell.resultModel.is_collect isEqualToString:@"1"]) {
        /** 已收藏 */
        cell.rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.rightBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cell.rightBtn.enabled = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark — event
- (void)rightBtnClick:(UIButton *)sender {
    FHSearchResultModel *resultModel = self.dataArrs[sender.tag];
    Account *account = [AccountStorage readAccount];
    NSString *urlString;
    NSDictionary *paramsDic;
    NSInteger type = [self.type integerValue] - 1;
    urlString = @"public/collect";
    paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 @(account.user_id),@"user_id",
                 resultModel.id,@"id",
                 @(type),@"type",nil];
    [self cancleCollectRequest:urlString parmars:paramsDic];
}

- (void)cancleCollectRequest:(NSString *)urlString
                     parmars:(NSDictionary *)paramsDic {
    
    WS(weakSelf);
    [AFNetWorkTool post:urlString params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadInit];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    /** 生鲜服务 */
//    FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
//    goodList.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:goodList animated:YES];
//}


- (void)fh_selectMenuWithModel:(FHCommonFollowModel *)followModle {
    self.cid = followModle.cid;
    /** 进行置顶和取消收藏的操作 */
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:@"请按照您的需要设置收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"置顶店铺",@"取消收藏", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *16];
    [actionSheet setButtonTitleColor:[UIColor blueColor] bgColor:nil fontSize:SCREEN_HEIGHT/667 *16 atIndex:0];
    [actionSheet setButtonTitleColor:[UIColor orangeColor] bgColor:nil fontSize:SCREEN_HEIGHT/667 *16 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}

- (void)fh_selectAvaterWithModel:(FHCommonFollowModel *)followModle {
    /** 跳转到物业 */
    
}

#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:
        {
            /** 进行置顶 */
            [self fh_placeShop];
            break;
        }
        case 1:
        {
            /** 取消收藏 */
            [self fh_cancleFollowShop];
            break;
        }
        case 2:
        {
            ZHLog(@"取消");
            break;
        }
        default:
            
            break;
    }
}


/** 置顶功能 */
- (void)fh_placeShop {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               weakSelf.cid,@"cid",
                               weakSelf.type,@"type",
                               nil];
    [AFNetWorkTool post:@"public/roofPlacement" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"置顶成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadInit];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

- (void)fh_cancleFollowShop {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               weakSelf.cid,@"cid",
                               weakSelf.type,@"type",
                               nil];
    [AFNetWorkTool post:@"public/cancelCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"取消收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadInit];
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
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70) style:UITableViewStylePlain];
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
