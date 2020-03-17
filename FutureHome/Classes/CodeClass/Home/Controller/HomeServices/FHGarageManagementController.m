//
//  FHGarageManagementController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  车库管理

#import "FHGarageManagementController.h"
#import "FHAnnouncementListCell.h"
#import "FHCollectionHeaderView.h"
#import "FHNoticeListModel.h"
#import "FHWebViewController.h"

@interface FHGarageManagementController ()  <UITableViewDelegate,UITableViewDataSource>
/** 列表数据 */
@property (nonatomic, strong) UITableView *listTable;
/** 表头 */
@property (nonatomic, strong) FHCollectionHeaderView *headerView;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *noticeListArrs;

@end

@implementation FHGarageManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self.view addSubview:self.listTable];
    [self.listTable registerClass:[FHAnnouncementListCell class] forCellReuseIdentifier:NSStringFromClass([FHAnnouncementListCell class])];
    
    [self fh_facthRequest];
}

- (void)fh_facthRequest {
    WS(weakSelf);
    self.noticeListArrs = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"property_id",
                               @(self.ID),@"id",
                               @(self.type),@"type", nil];
    
    [AFNetWorkTool get:@"public/noticeList" params:paramsDic success:^(id responseObj) {
        NSDictionary *dic = responseObj[@"data"];
        self.noticeListArrs = [FHNoticeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [weakSelf.listTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.listTable reloadData];
    }];
    
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(account.user_id),@"user_id",
                                      @(self.property_id),@"property_id",nil];
    /**车库管理费用 */
    [AFNetWorkTool get:@"property/carage" params:paramsDictionary success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [self endRefreshAction];
            self.headerView.leftNameArrs = [[NSMutableArray alloc] init];
            self.headerView.rightNameArrs = [[NSMutableArray alloc] init];
            NSArray *arr = responseObj[@"data"];
            if (arr.count > 0) {
                for (NSDictionary * dic in arr) {
                    [self.headerView.leftNameArrs addObject:dic[@"key1"]];
                    [self.headerView.leftNameArrs addObject:dic[@"key2"]];
                    [self.headerView.rightNameArrs addObject:dic[@"val1"]];
                    [self.headerView.rightNameArrs addObject:dic[@"val2"]];
                }
                self.listTable.tableHeaderView = self.headerView;
                self.listTable.tableHeaderView.height = self.headerView.height;
                [weakSelf.listTable reloadData];
            }
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

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES; self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"车库管理";
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
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.noticeListArrs.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHAnnouncementListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHAnnouncementListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IS_NULL_ARRAY(self.noticeListArrs)) {
        FHNoticeListModel *model = self.noticeListArrs[indexPath.row];
        cell.noticeModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHNoticeListModel *model = self.noticeListArrs[indexPath.row];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = model.singpage;
    web.titleString = @"车库管理";
    web.hidesBottomBarWhenPushed = YES;
    web.isHaveProgress = YES;
    web.type = @"noShow";
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
- (UITableView *)listTable {
    if (_listTable == nil) {
        _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        _listTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listTable.showsVerticalScrollIndicator = NO;
        _listTable.emptyDataSetSource = self;
        _listTable.emptyDataSetDelegate = self;
        _listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fh_facthRequest)];
        if (@available (iOS 11.0, *)) {
            _listTable.estimatedSectionHeaderHeight = 0.01;
            _listTable.estimatedSectionFooterHeight = 0.01;
            _listTable.estimatedRowHeight = 0.01;
        }
    }
    return _listTable;
}

- (FHCollectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FHCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360) numberCount:12];
    }
    return _headerView;
}


@end
