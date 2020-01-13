//
//  FHOtherFollowController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  其他收藏 船新的收藏界面

#import "FHOtherFollowController.h"
#import "FHOtherFollowCell.h"
#import "FHWebViewController.h"
#import "FHDocumentCollectModel.h"

@interface FHOtherFollowController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 文档收藏列表 */
@property (nonatomic, strong) NSMutableArray *documentCollectArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger page;

@end

@implementation FHOtherFollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.documentCollectArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHOtherFollowCell class] forCellReuseIdentifier:NSStringFromClass([FHOtherFollowCell class])];
    [self.view addSubview:self.homeTable];
    [self loadInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
                               @(curPage),@"page", nil];
    
    [AFNetWorkTool get:@"sheyun/documentCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [self.documentCollectArrs removeAllObjects];
            }
            [self endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [self.documentCollectArrs addObjectsFromArray:[FHDocumentCollectModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
            [weakSelf.homeTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable.mj_header endRefreshing];
        [weakSelf.homeTable.mj_footer endRefreshing];
    }];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.documentCollectArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHOtherFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHOtherFollowCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectModel = self.documentCollectArrs[indexPath.row];
    
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}

- (void) cellLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.homeTable];
        NSIndexPath * indexPath = [self.homeTable indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        
        //在此添加你想要完成的功能
        WS(weakSelf);
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定要取消收藏吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 取消收藏文档 */
                [weakSelf fh_cancleFollowInfoWithIndex:indexPath];
            }
        }];
    }
}

- (void)fh_cancleFollowInfoWithIndex:(NSIndexPath *)index {
    FHDocumentCollectModel * model = self.documentCollectArrs[index.row];
    /** 取消收藏的接口 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.cid,@"cid",
                               nil];
    [AFNetWorkTool post:@"sheyun/cancelDocCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"取消收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf loadInit];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHDocumentCollectModel *infoModel = self.documentCollectArrs[indexPath.row];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    Account *account = [AccountStorage readAccount];
    web.urlString = [NSString stringWithFormat:@"%@?id=%@&userid=%ld",infoModel.singpage,infoModel.id,(long)account.user_id];
    web.hidesBottomBarWhenPushed = YES;
    web.titleString = infoModel.title;
    web.typeString = @"information";
    web.isHaveProgress = YES;
    [self.navigationController pushViewController:web animated:YES];
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
