//
//  FHInformationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  信息发布

#import "FHInformationController.h"
#import "FHServiceCommonHeaderView.h"
#import "FHInformationMesageCell.h"

@interface FHInformationController () <UITableViewDelegate,UITableViewDataSource>
/** 标头数据 */
@property (nonatomic, strong) FHServiceCommonHeaderView *tableHeaderView;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    self.homeTable.tableHeaderView = self.tableHeaderView;
    self.homeTable.tableHeaderView.height = self.tableHeaderView.height;
    [self.homeTable registerClass:[FHInformationMesageCell class] forCellReuseIdentifier:NSStringFromClass([FHInformationMesageCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([SingleManager shareManager].shoppingBar) {
        [[SingleManager shareManager].shoppingBar removeFromSuperview];
    }
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHInformationMesageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHInformationMesageCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark — event
/** 用户评论 */
- (void)personCountBtnClick {
    
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight + 70, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 70) style:UITableViewStylePlain];
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

- (FHServiceCommonHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FHServiceCommonHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        [_tableHeaderView.personCountBtn addTarget:self action:@selector(personCountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableHeaderView;
}

@end
