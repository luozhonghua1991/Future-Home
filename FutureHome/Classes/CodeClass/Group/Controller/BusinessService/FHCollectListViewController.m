//
//  FHCollectListViewController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  全类收藏列表界面

#import "FHCollectListViewController.h"
#import "FHCollectListCell.h"
#import "FHFreshMallController.h"

@interface FHCollectListViewController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHCollectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHCollectListCell class] forCellReuseIdentifier:NSStringFromClass([FHCollectListCell class])];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCollectListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCollectListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /** 生鲜服务 */
    FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
    goodList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodList animated:YES];
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
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
