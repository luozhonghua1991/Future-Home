//
//  FHTenderingInfoController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/26.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  招标信息界面

#import "FHTenderingInfoController.h"
#import "FHFHTenderingInfoCell.h"
#import "FHTenderingInfModel.h"
#import "FHTendringInfoDetailController.h"

@interface FHTenderingInfoController () <UITableViewDelegate,UITableViewDataSource>
/** 列表数据 */
@property (nonatomic, strong) UITableView *listTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *noticeListArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHTenderingInfModel *infoModel;


@end

@implementation FHTenderingInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.listTable registerClass:[FHFHTenderingInfoCell class] forCellReuseIdentifier:NSStringFromClass([FHFHTenderingInfoCell class])];
    [self.view addSubview:self.listTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fh_getRequest];
}

- (void)fh_getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.owner_id),@"owner_id", nil];
    
    [AFNetWorkTool get:@"owner/tenderList" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.noticeListArrs = [[NSMutableArray alloc] init];
            NSDictionary *dic = responseObj[@"data"];
            self.noticeListArrs = [FHTenderingInfModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
            [weakSelf.listTable reloadData];
            [self endRefreshAction];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.listTable reloadData];
    }];
}


- (void)endRefreshAction
{
    MJRefreshHeader *header = self.listTable.mj_header;
    MJRefreshFooter *footer = self.listTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.noticeListArrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHFHTenderingInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHFHTenderingInfoCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IS_NULL_ARRAY(self.noticeListArrs)) {
        FHTenderingInfModel *model = self.noticeListArrs[indexPath.section];
        cell.infoModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHTenderingInfModel *model = self.noticeListArrs[indexPath.section];
    FHTendringInfoDetailController *vc = [[FHTendringInfoDetailController alloc] init];
    vc.owner_id = self.owner_id;
    vc.id = model.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark — setter && getter
#pragma mark — setter & getter
- (UITableView *)listTable {
    if (_listTable == nil) {
        _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStylePlain];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTable.showsVerticalScrollIndicator = NO;
        _listTable.emptyDataSetSource = self;
        _listTable.emptyDataSetDelegate = self;
        _listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fh_getRequest)];
        if (@available (iOS 11.0, *)) {
            _listTable.estimatedSectionHeaderHeight = 10.0f;
            _listTable.estimatedSectionFooterHeight = 0.01;
            _listTable.estimatedRowHeight = 0.01;
        }
    }
    return _listTable;
}

@end
