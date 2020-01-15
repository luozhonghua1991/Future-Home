//
//  FHPersonCommitsListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHPersonCommitsListController.h"
#import "FHPersonCommitListCell.h"
#import "ZJCommit.h"
#import "FHNoPicPersonCommitsCell.h"

@interface FHPersonCommitsListController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger curPage;
    NSInteger tolPage;
}

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSMutableArray *dataArray;
/** 数据 */
@property (nonatomic, strong) NSArray *commitsListArrs;
@end

@implementation FHPersonCommitsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllView];
    [self loadInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.mainTable.mj_footer resetNoMoreData];
    
    [self getCommitsDataWithHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getCommitsDataWithHead:NO];
    } else {
        [self.mainTable.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.mainTable.mj_header;
    MJRefreshFooter *footer = self.mainTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

- (void)getCommitsDataWithHead:(BOOL)isHead {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id",
                               self.experience,@"experience",
                               @"20",@"limit",
                               @(curPage),@"page",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool get:@"shop/getOrderComment" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [weakSelf.dataArray removeAllObjects];
            }
            [self requestWithGoodsCommitDic:responseObj[@"data"]];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [weakSelf endRefreshAction];
            [weakSelf.mainTable reloadData];
        } else {
            [weakSelf endRefreshAction];
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.mainTable reloadData];
    }];
}

- (void)requestWithGoodsCommitDic:(NSDictionary *)dic {
    NSArray *commitsList = [dic objectForKey:@"list"];
    self.commitsListArrs = commitsList;
    NSMutableArray *arrM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in commitsList) {
            ZJCommit *commit = [ZJCommit commitWithGoodsCommitDict:dictDict];
            [arrM addObject:commit];
        }
        self.dataArray = arrM;
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.mainTable reloadData];
                [weakSelf.mainTable.mj_header endRefreshing];
                
            });
        });
    });
}

- (void)setUpAllView {
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - MainSizeHeight - 35) style:UITableViewStylePlain];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mainTable.tableFooterView = [[UIView alloc] init];
    self.mainTable.estimatedRowHeight = 100;
    self.mainTable.emptyDataSetSource = self;
    self.mainTable.emptyDataSetDelegate = self;
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
    self.mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
    // 必须先注册cell，否则会报错
    [self.mainTable registerClass:[FHPersonCommitListCell class] forCellReuseIdentifier:@"FHPersonCommitListCell"];
    [self.mainTable registerClass:[FHNoPicPersonCommitsCell class] forCellReuseIdentifier:@"FHNoPicPersonCommitsCell"];
    [self.view addSubview:self.mainTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJCommit *commit = self.dataArray[indexPath.row];
    //图片
    if (commit.pic_urls.count > 0) {
        FHPersonCommitListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FHPersonCommitListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.weakSelf = self;
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    /** 纯文字Cell */
    FHNoPicPersonCommitsCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"FHNoPicPersonCommitsCell"];
    photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    photoCell.model = self.dataArray[indexPath.row];
    return photoCell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJCommit *commit = self.dataArray[indexPath.row];
    if (commit.pic_urls.count > 0) {
        return [SingleManager shareManager].cellPicHeight;
    }
    return [SingleManager shareManager].cellNoPicHeight;
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


@end
