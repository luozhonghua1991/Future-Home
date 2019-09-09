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

@interface FHHouseSaleController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHHouseSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHHouseSaleCell class] forCellReuseIdentifier:NSStringFromClass([FHHouseSaleCell class])];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCarSaleController *vc = [[FHCarSaleController alloc] init];
    vc.type = self.type;
    vc.hidesBottomBarWhenPushed = YES;
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
