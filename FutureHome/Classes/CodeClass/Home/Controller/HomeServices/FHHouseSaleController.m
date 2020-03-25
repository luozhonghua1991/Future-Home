//
//  FHHouseSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  房子出售

#import "FHHouseSaleController.h"
#import "FHHouseSaleCell.h"
#import "FHCarSaleController.h"
#import "FHCarSaleController.h"
#import "FHHouseListModel.h"

@interface FHHouseSaleController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 1 出售 2出租 */
@property (nonatomic, copy) NSString *getType;
/** 房屋数据 */
@property (nonatomic, strong) NSMutableArray *houseDataArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHHouseListModel *houseListModel;

@end

@implementation FHHouseSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHHouseSaleCell class] forCellReuseIdentifier:NSStringFromClass([FHHouseSaleCell class])];
    if (self.type == 0 || self.type == 1) {
        [self fh_getHouseRequest];
    } else {
        [self fh_geCarRequest];
    }
}


- (void)fh_getHouseRequest {
    WS(weakSelf);
    self.houseDataArrs = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    if (self.type == 0) {
        self.getType = @"1";
    } else if (self.type == 1) {
        self.getType = @"2";
    }
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"property_id",
                               self.getType,@"type", nil];
    
    [AFNetWorkTool get:@"property/houseList" params:paramsDic success:^(id responseObj) {
        NSDictionary *dic = responseObj[@"data"];
        [self endRefreshAction];
        self.houseDataArrs = [FHHouseListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [self endRefreshAction];
        [weakSelf.homeTable reloadData];
    }];
}

- (void)fh_geCarRequest {
    WS(weakSelf);
    self.houseDataArrs = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    if (self.type == 2) {
        self.getType = @"1";
    } else if (self.type == 3) {
        self.getType = @"2";
    }
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"property_id",
                               self.getType,@"type", nil];
    
    [AFNetWorkTool get:@"property/parkList" params:paramsDic success:^(id responseObj) {
        NSDictionary *dic = responseObj[@"data"];
        [self endRefreshAction];
        self.houseDataArrs = [FHHouseListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [self endRefreshAction];
        [weakSelf.homeTable reloadData];
    }];
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

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.houseDataArrs.count;
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
    FHHouseSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHHouseSaleCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.houseListModel = self.houseDataArrs[indexPath.row];
    cell.houseListModel = self.houseListModel;
    cell.houseNameLabel.text = [NSString stringWithFormat:@"标题名称: %@",_houseListModel.community];
    if (self.type == 0) {
        /** 房屋出售 */
        cell.houseTypeLabel.text = [NSString stringWithFormat:@"房屋户型: %@",_houseListModel.hall];
        cell.priceSugmentLabel.text = [NSString stringWithFormat:@"房屋面积 :%@㎡",_houseListModel.area];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@万元/套",_houseListModel.rent];
    } else if (self.type == 1) {
        /** 出租 */
        cell.houseTypeLabel.text = [NSString stringWithFormat:@"房屋户型: %@",_houseListModel.hall];
        cell.priceSugmentLabel.text = [NSString stringWithFormat:@"房屋面积 :%@㎡",_houseListModel.area];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@元/月",_houseListModel.rent];
    } else if (self.type == 2) {
        cell.houseTypeLabel.text = [NSString stringWithFormat:@"车位编号: %@",_houseListModel.park_number];
        cell.priceSugmentLabel.text = [NSString stringWithFormat:@"车位面积 :%@㎡",_houseListModel.area];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@万元/套",_houseListModel.rent];
    } else if (self.type == 3) {
        /** 车位出租 */
        cell.houseTypeLabel.text = [NSString stringWithFormat:@"车位编号: %@",_houseListModel.park_number];
        cell.priceSugmentLabel.text = [NSString stringWithFormat:@"车位面积 :%@㎡",_houseListModel.area];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@元/月",_houseListModel.rent];
    }
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_managementModel.rent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHHouseListModel *houseListModel = self.houseDataArrs[indexPath.row];
    FHCarSaleController *vc = [[FHCarSaleController alloc] init];
    vc.type = self.type;
    vc.hidesBottomBarWhenPushed = YES;
    vc.property_id = self.property_id;
    vc.id = houseListModel.id;
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


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (self.type == 0 || self.type == 1) {
           _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fh_getHouseRequest)];
        } else {
            _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fh_geCarRequest)];
        }
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
