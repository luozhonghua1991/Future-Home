//
//  FHFollowListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHFollowListViewController.h"
#import "FHFollowListViewCell.h"
#import "FHSearchResultCell.h"
#import "FHSearchResultModel.h"
#import "FHCommonFollowAndPlacementCell.h"
#import "FHCommonFollowModel.h"
#import "FHFreshMallController.h"
#import "FHHomeServicesController.h"
#import "FHOwnerServiceController.h"

@interface FHFollowListViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FHCommonFollowAndPlacementCellDelegate,
FDActionSheetDelegate
>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** tableHeaderView */
@property (nonatomic, strong) UIView *tableHeaderView;
/** 个数label */
@property (nonatomic, strong) UILabel *countLabel;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *dataArrs;
/** 收藏的主键 */
@property (nonatomic, copy) NSString *cid;

@end

@implementation FHFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHCommonFollowAndPlacementCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonFollowAndPlacementCell class])];
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
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonFollowAndPlacementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonFollowAndPlacementCell class])];
    cell.followModel = self.dataArrs[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SingleManager shareManager].selectType = @"MeCenter";
    FHCommonFollowModel*model = self.dataArrs[indexPath.row];
    if ([self.type isEqualToString:@"1"]) {
        /** 物业 */
        FHHomeServicesController *home = [[FHHomeServicesController alloc]init];
        home.model = model;
        home.isFollow = YES;
        [home setHomeSeverID:[model.id integerValue] homeServerName:model.name];
        home.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:home animated:YES];
    } else if ([self.type isEqualToString:@"2"]) {
        /** 业委 */
        FHOwnerServiceController *home = [[FHOwnerServiceController alloc]init];
        home.model = model;
        home.isFollow = YES;
        [home setHomeSeverID:[model.id integerValue] homeServerName:model.name];
        home.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:home animated:YES];
    } else if ([self.type isEqualToString:@"3"]) {
        /** 生鲜 */
        /** 生鲜商城 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.shopID = model.id;
        goodList.isCollect = model.is_collect;
        goodList.titleString = @"生鲜商城";
        [self.navigationController pushViewController:goodList animated:YES];
    } else if ([self.type isEqualToString:@"4"]) {
        /** 商业 */
        /** 商业商城 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.shopID = model.id;
        goodList.isCollect = model.is_collect;
        goodList.titleString = @"商业商城";
        [self.navigationController pushViewController:goodList animated:YES];
    } else if ([self.type isEqualToString:@"5"]) {
        /** 医药 */
        /** 医药商城 */
        FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
        goodList.hidesBottomBarWhenPushed = YES;
        goodList.shopID = model.id;
        goodList.isCollect = model.is_collect;
        goodList.titleString = @"医药商城";
        [self.navigationController pushViewController:goodList animated:YES];
    }
}

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

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeaderView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        _countLabel.text = @"物业收藏数量: 12";
    }
    return _countLabel;
}

@end
