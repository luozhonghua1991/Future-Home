//
//  FHPropertyCostsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  物业费用界面

#import "FHPropertyCostsController.h"
#import "FHAnnouncementListCell.h"
#import "FHCollectionHeaderView.h"

@interface FHPropertyCostsController () <UITableViewDelegate,UITableViewDataSource>
/** 列表数据 */
@property (nonatomic, strong) UITableView *listTable;
/** 表头 */
@property (nonatomic, strong) FHCollectionHeaderView *headerView;

@end

@implementation FHPropertyCostsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self.view addSubview:self.listTable];
    [self.listTable registerClass:[FHAnnouncementListCell class] forCellReuseIdentifier:NSStringFromClass([FHAnnouncementListCell class])];
    self.listTable.tableHeaderView = self.headerView;
    self.listTable.tableHeaderView.height = self.headerView.height;
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES; self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"物业费用";
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHAnnouncementListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHAnnouncementListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark — setter & getter
- (UITableView *)listTable {
    if (_listTable == nil) {
        _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        _listTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listTable.showsVerticalScrollIndicator = NO;
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
        _headerView = [[FHCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) numberCount:4];
        _headerView.leftNameArrs = @[@"房屋物业费",@"车位管理费",@"商铺物业费",@"其他费用"];
        _headerView.rightNameArrs = @[@"110",@"119",@"120",@"118"];
    }
    return _headerView;
}


@end
