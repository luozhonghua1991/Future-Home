//
//  FHWaitOrderController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  待付款

#import "FHWaitOrderController.h"
#import "FHWatingOrderCell.h"
#import "FHOrderDetailController.h"
#import "FHNewWatiingOrderCell.h"
#import "FHGoodsListModel.h"

@interface FHWaitOrderController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 数据列表 */
@property (nonatomic, strong) NSMutableArray *dataListArrs;

@end

@implementation FHWaitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataListArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHNewWatiingOrderCell class] forCellReuseIdentifier:NSStringFromClass([FHNewWatiingOrderCell class])];
    [self.view addSubview:self.homeTable];
    [self loadInit];
}


#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.homeTable.mj_footer resetNoMoreData];
    
    [self getRequestLoadHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getRequestLoadHead:NO];
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

- (void)getRequestLoadHead:(BOOL)isHead {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.status),@"status",
                               @"20",@"limit",
                               @(curPage),@"page",
                               self.order_type,@"order_type",
                               nil];
    
    [AFNetWorkTool get:@"shop/getOrderList" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [self.dataListArrs removeAllObjects];
            }
            [self endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [self.dataListArrs addObjectsFromArray:[FHGoodsListModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
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
    return self.dataListArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHNewWatiingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHNewWatiingOrderCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IS_NULL_ARRAY(self.dataListArrs)) {
        FHGoodsListModel *listModel = self.dataListArrs[indexPath.row];
        cell.listModel = listModel;
        cell.goodsImgArrs = listModel.covers;
        NSString *typeString;
        if (self.status == 1) {
            typeString =@"待付款";
        } else if (self.status == 2) {
            typeString =@"待收货";
        } else if (self.status == 3) {
            typeString =@"待评价";
        }
        [cell.typeBtn setTitle:typeString forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHGoodsListModel *listModel = self.dataListArrs[indexPath.row];
    FHOrderDetailController *detail = [[FHOrderDetailController alloc] init];
    detail.type = self.type;
    detail.hidesBottomBarWhenPushed = YES;
    detail.order_id = listModel.id;
    [self.navigationController pushViewController:detail animated:YES];
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
        _homeTable.emptyDataSetSource = self;
        _homeTable.emptyDataSetDelegate = self;
        _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
        _homeTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
