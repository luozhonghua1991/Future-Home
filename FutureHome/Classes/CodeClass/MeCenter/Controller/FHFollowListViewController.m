//
//  FHFollowListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHFollowListViewController.h"
#import "FHFollowListViewCell.h"

@interface FHFollowListViewController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** tableHeaderView */
@property (nonatomic, strong) UIView *tableHeaderView;
/** 个数label */
@property (nonatomic, strong) UILabel *countLabel;


@end

@implementation FHFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.homeTable];
    self.homeTable.tableHeaderView = self.tableHeaderView;
    self.countLabel.text = [NSString stringWithFormat:@"%@数量: 520",self.yp_tabItemTitle];
    [self.tableHeaderView addSubview:self.countLabel];
    [self.homeTable registerClass:[FHFollowListViewCell class] forCellReuseIdentifier:NSStringFromClass([FHFollowListViewCell class])];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.yp_tabItemTitle isEqualToString:@"文档收藏"]) {
        return 100;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.yp_tabItemTitle isEqualToString:@"文档收藏"]) {
        UIView *view = [[UIView alloc] init];
        return view;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.yp_tabItemTitle isEqualToString:@"文档收藏"]) {
        FHFollowListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHFollowListViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = ZH_COLOR(242, 242, 242);
        return cell;
    }
    static NSString *ID = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"恒大未来城一期物业平台";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = @"CQW190786";
    cell.backgroundColor = ZH_COLOR(242, 242, 242);
    return cell;
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.backgroundColor = ZH_COLOR(242, 242, 242);
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _tableHeaderView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        _countLabel.text = @"物业收藏数量: 12";
    }
    return _countLabel;
}

@end
