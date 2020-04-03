//
//  LGJProductsVC.m
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//

#import "LGJProductsVC.h"
#import "FHHealthProductModel.h"
#import "FHWebViewController.h"

@interface LGJProductsVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger curPage;
    NSInteger tolPage;
}
@property(nonatomic, strong)UITableView *productsTableView;
@property(nonatomic, strong)NSMutableArray *productsArr;
@property(nonatomic, strong)NSArray *sectionArr;
@property(nonatomic, assign)BOOL isScrollUp;//是否是向上滚动
@property(nonatomic, assign)CGFloat lastOffsetY;//滚动即将结束时scrollView的偏移量
/** <#assign属性注释#> */
@property (nonatomic, copy) NSString *pid;

@end

@implementation LGJProductsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isScrollUp = false;
    _lastOffsetY = 0;
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configData:) name:@"REFRESHHEALTH" object:nil];
    // Do any additional setup after loading the view.
}

- (void)configData:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    self.productsArr = [[NSMutableArray alloc] init];
    self.pid = dic[@"category_id"];
    [self loadInit];
}

- (void)getRequestWithPid:(NSString *)pid loadHead:(BOOL)isHead{
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(curPage),@"page",
                               pid,@"pid", nil];
    [AFNetWorkTool get:@"health/disesseArticle" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 获取成功 */
            if (isHead) {
                [self.productsArr removeAllObjects];
            }
            [self endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [weakSelf.productsArr addObjectsFromArray:[FHHealthProductModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
            [weakSelf.productsTableView reloadData];
        } else {
            [self endRefreshAction];
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        [self endRefreshAction];
    }];
}

- (void)createTableView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.26, 0, self.view.frame.size.width * 0.74, self.view.frame.size.height)];
    
    self.productsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, self.view.width, self.view.height - MainSizeHeight) style:UITableViewStylePlain];
    self.productsTableView.delegate = self;
    self.productsTableView.dataSource = self;
    self.productsTableView.showsVerticalScrollIndicator = YES;
    self.productsTableView.emptyDataSetSource = self;
    self.productsTableView.emptyDataSetDelegate = self;
    if (@available (iOS 11.0, *)) {
        self.productsTableView.estimatedSectionHeaderHeight = 0;
        self.productsTableView.estimatedSectionFooterHeight = 0;
        self.productsTableView.estimatedRowHeight = 0;
        self.productsTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        

    }
//    if (@available(iOS 11.0, *)) {
//        self.productsTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
//        self.productsTableView.contentInset =UIEdgeInsetsMake(MainSizeHeight,0,0,0);//64和49自己看效果，是否应该改成0
//        self.productsTableView.scrollIndicatorInsets =self.productsTableView.contentInset;
//    }
    self.productsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
    self.productsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
    [self.view addSubview:self.productsTableView];
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

#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.productsTableView.mj_footer resetNoMoreData];
    [self getRequestWithPid:self.pid loadHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getRequestWithPid:self.pid loadHead:NO];
    } else {
        [self.productsTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.productsTableView.mj_header;
    MJRefreshFooter *footer = self.productsTableView.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    FHHealthProductModel *model = [self.productsArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHHealthProductModel *model = self.productsArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = model.url;
    NSArray *arr = [model.url componentsSeparatedByString:@"/"];
    web.article_id = arr[arr.count - 3];
    web.article_type = arr[arr.count - 1];
    web.title = model.title;
    web.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:web animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(willDisplayHeaderView:)] != _isScrollUp &&_productsTableView.isDecelerating) {
//        [self.delegate willDisplayHeaderView:section];
//    }
//
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didEndDisplayingHeaderView:)] && _isScrollUp &&_productsTableView.isDecelerating) {
//        [self.delegate didEndDisplayingHeaderView:section];
//    }
//}

//#pragma mark - scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    NSLog(@"_lastOffsetY : %f,scrollView.contentOffset.y : %f", _lastOffsetY, scrollView.contentOffset.y);
//    _isScrollUp = _lastOffsetY < scrollView.contentOffset.y;
//    _lastOffsetY = scrollView.contentOffset.y;
//    NSLog(@"______lastOffsetY: %f", _lastOffsetY);
//}

#pragma mark - 一级tableView滚动时 实现当前类tableView的联动
- (void)scrollToSelectedIndexPath:(NSIndexPath *)indexPath {
    
//    [self.productsTableView selectRowAtIndexPath:([NSIndexPath indexPathForRow:0 inSection:indexPath.row]) animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}


- (void)resreshDataWithPid:(NSString *)pid {
    self.productsArr = [[NSMutableArray alloc] init];
    self.pid = pid;
    [self loadInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
