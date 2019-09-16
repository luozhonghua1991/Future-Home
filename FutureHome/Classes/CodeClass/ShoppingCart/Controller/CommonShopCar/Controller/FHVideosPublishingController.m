//
//  FHVideosPublishingController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  视频发布

#import "FHVideosPublishingController.h"
#import "FHCommonVideosCollectionCell.h"
#import "FHServiceCommonHeaderView.h"
#import "ZFDouYinViewController.h"

@interface FHVideosPublishingController () <UITableViewDelegate,UITableViewDataSource,FHCommonVideosCollectionCellDelegate>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 标头数据 */
@property (nonatomic, strong) FHServiceCommonHeaderView *tableHeaderView;
@end

@implementation FHVideosPublishingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    self.homeTable.tableHeaderView = self.tableHeaderView;
    self.homeTable.tableHeaderView.height = self.tableHeaderView.height;
    [self.homeTable registerClass:[FHCommonVideosCollectionCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([SingleManager shareManager].shoppingBar) {
        [[SingleManager shareManager].shoppingBar removeFromSuperview];
    }
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT - MainSizeHeight - 70 - 140;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonVideosCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectionViewHeight = SCREEN_HEIGHT - MainSizeHeight - 70 - 140;
    cell.delegate = self;
    return cell;
}

- (void)FHCommonVideosCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex {
    ZFDouYinViewController *douyin = [[ZFDouYinViewController alloc] init];
    [douyin playTheIndex:0];
    douyin.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:douyin animated:YES];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight + 70, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 70) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.scrollEnabled = NO;
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
