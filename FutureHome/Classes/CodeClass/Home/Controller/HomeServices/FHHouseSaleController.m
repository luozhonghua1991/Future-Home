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
        self.houseDataArrs = [FHHouseListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
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
        self.houseDataArrs = [FHHouseListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
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

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
