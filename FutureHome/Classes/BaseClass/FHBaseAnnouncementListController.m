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
#import "FHNoticeListModel.h"
#import "FHWebViewController.h"

@interface FHBaseAnnouncementListController () <UITableViewDelegate,UITableViewDataSource>
/** 列表数据 */
@property (nonatomic, strong) UITableView *listTable;
/** 表头 */
@property (nonatomic, strong) UIImageView *headerView;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *noticeListArrs;

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
    [self fh_getRequest];
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

- (void)fh_getRequest {
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
    
    /** 上面的headerView */
    [AFNetWorkTool get:@"public/noticeImg" params:paramsDic success:^(id responseObj) {
        NSString *imgUrl = responseObj[@"data"];
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
        [weakSelf.listTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.listTable reloadData];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeListArrs.count;
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
    web.urlString = model.url;
    web.titleString = model.title;
    web.hidesBottomBarWhenPushed = YES;
    web.isHaveProgress = YES;
    [self.navigationController pushViewController:web animated:YES];
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
    }
    return _headerView;
}

@end
