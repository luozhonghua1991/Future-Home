//
//  FHBaseAnnouncementListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  通用公告类型的VC

#import "FHBaseAnnouncementListController.h"
#import "FHAnnouncementListCell.h"
#import "FHElectionListController.h"

@interface FHBaseAnnouncementListController () <UITableViewDelegate,UITableViewDataSource>
/** 列表数据 */
@property (nonatomic, strong) UITableView *listTable;
/** 表头 */
@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation FHBaseAnnouncementListController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isHaveSelectView) {
        [self fh_creatNav];
    };
    [self.view addSubview:self.listTable];
    [self.listTable registerClass:[FHAnnouncementListCell class] forCellReuseIdentifier:NSStringFromClass([FHAnnouncementListCell class])];
    if (!self.isNoHaveHeaderView) {
        self.listTable.tableHeaderView = self.headerView;
        self.listTable.tableHeaderView.height = SCREEN_WIDTH * 0.618;
    }
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES; self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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
    if (self.isHaveSectionView) {
        return 80.0;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isHaveSectionView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 60);
        [button setTitle:@"妹妹家小区--第一届通道\n(点击报名)" forState:UIControlStateNormal];
        [button setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 2;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [view addSubview:button];
        
        return view;
    }
    UIView *view = [UIView new];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHAnnouncementListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHAnnouncementListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)buttonClick {
    if ([self.yp_tabItemTitle isEqualToString:@"申请通道"]) {
        [self viewControllerPushOther:@"FHApplicationElectionIndustryCommitteController"];
        return;
    }
    if ([self.titleString isEqualToString:@"物业招标"]) {
        [self viewControllerPushOther:@"FHApplicationBiddingController"];
        return;
    }
    
    FHElectionListController *vc = [[FHElectionListController alloc] init];
    if ([self.yp_tabItemTitle isEqualToString:@"业委海选"]) {
        vc.titleString = @"业委海选";
    } else if ([self.yp_tabItemTitle isEqualToString:@"岗位选举"]) {
        vc.titleString = @"岗位选举";
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark — setter & getter
- (UITableView *)listTable {
    if (_listTable == nil) {
        if (self.isHaveSelectView) {
            _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStylePlain];
        } else {
            _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        }
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

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
        _headerView.image = [UIImage imageNamed:@"头像"];
    }
    return _headerView;
}

@end
