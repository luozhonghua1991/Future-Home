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
#import "FHApplicationBiddingController.h"
#import "FHApplicationElectionIndustryCommitteController.h"

@interface FHBaseAnnouncementListController () <UITableViewDelegate,UITableViewDataSource>
/** 列表数据 */
@property (nonatomic, strong) UITableView *listTable;
/** 表头 */
@property (nonatomic, strong) UIImageView *headerView;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *noticeListArrs;
/** 点击报名按钮 */
@property (nonatomic, strong) UIButton *clickButton;
/** 第几节选举大会 */
@property (nonatomic, copy) NSString *pid;


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
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickButton.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 60);
    [self.clickButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.clickButton.layer.borderWidth = 1;
    self.clickButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.clickButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.clickButton.titleLabel.numberOfLines = 2;
    self.clickButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
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
    Account *account = [AccountStorage readAccount];
    if (self.type == 2) {
        if (self.ID == 10) {
            /** 投标服务判断 */
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @(account.user_id),@"user_id",
                                    @(self.property_id),@"owner_id",
                                    nil];
            [AFNetWorkTool get:@"owner/tenderPass" params:params success:^(id responseObj) {
                NSDictionary *dic = responseObj[@"data"];
                if ([responseObj[@"code"] integerValue] == 1) {
                    self.pid = dic[@"id"];
                    /** 请求成功 */
                    if ([dic[@"status"] integerValue] == 0) {
                        self.clickButton.hidden = YES;
                        self.clickButton = nil;
                    } else {
                        self.clickButton.hidden = NO;
                        if ([dic[@"status"] integerValue] == 1) {
                            [self.clickButton setTitle:dic[@"title"] forState:UIControlStateNormal];
                            [self.clickButton setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
                            self.clickButton.enabled = YES;
                        } else {
                            [self.clickButton setTitle:dic[@"title"] forState:UIControlStateNormal];
                            [self.clickButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                            self.clickButton.enabled = NO;
                        }
                    }
                } else {
                    
                }
                [weakSelf.listTable reloadData];
            } failure:^(NSError *error) {
                [weakSelf.listTable reloadData];
            }];
        }
    }
    
    self.noticeListArrs = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"property_id",
                               @(self.ID),@"id",
                               @(self.type),@"type", nil];
    
    [AFNetWorkTool get:@"public/noticeList" params:paramsDic success:^(id responseObj) {
        NSDictionary *dic = responseObj[@"data"];
        self.noticeListArrs = [FHNoticeListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [self endRefreshAction];
        
//        if (self.noticeListArrs.count == 0) {
////            [self.clickButton setTitle:@"通道尚未开启" forState:UIControlStateNormal];
//            [self.clickButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            self.clickButton.enabled = NO;
//        }
        [weakSelf.listTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.listTable reloadData];
    }];
    
    /** 上面的headerView */
    [AFNetWorkTool get:@"public/noticeImg" params:paramsDic success:^(id responseObj) {
        NSString *imgUrl = responseObj[@"data"];
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@""]];
        if (IsStringEmpty(imgUrl)) {
            self.headerView.image = [UIImage imageNamed:@"头像"];
        }
        [weakSelf.listTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.listTable reloadData];
    }];
    
    if (self.type == 2) {
        if (self.ID == 6 || self.ID == 7 || self.ID == 8) {
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @(account.user_id),@"user_id",
                                    @(self.property_id),@"owner_id",
                                    nil];
            /** 判断业委投票通道是否关闭 */
            [AFNetWorkTool get:@"owner/voteIsClosed" params:params success:^(id responseObj) {
                NSDictionary *dic = responseObj[@"data"];
                NSInteger status = [dic[@"status"] integerValue];
                self.pid = dic[@"id"];
                if (self.ID == 6) {
                    NSString *title = dic[@"apply_title"];
                    /** 申请通道 */
                    if (status == 1) {
                        [self.clickButton setTitle:title forState:UIControlStateNormal];
                        [self.clickButton setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
                        self.clickButton.enabled = YES;
                    } else {
                        [self.clickButton setTitle:title forState:UIControlStateNormal];
                        [self.clickButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        self.clickButton.enabled = NO;
                    }
                } else if (self.ID == 7) {
                    /** 业委海选 */
                    NSString *title = dic[@"candidate_title"];
                    if (status == 3) {
                        [self.clickButton setTitle:title forState:UIControlStateNormal];
                        [self.clickButton setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
                        self.clickButton.enabled = YES;
                    } else {
                        [self.clickButton setTitle:title forState:UIControlStateNormal];
                        [self.clickButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        self.clickButton.enabled = NO;
                    }
                } else if (self.ID == 8) {
                    /** 岗位选举 */
                    NSString *title = dic[@"candidate_title"];
                    if (status == 5) {
                        [self.clickButton setTitle:title forState:UIControlStateNormal];
                        [self.clickButton setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
                        self.clickButton.enabled = YES;
                    } else {
                        [self.clickButton setTitle:title forState:UIControlStateNormal];
                        [self.clickButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        self.clickButton.enabled = NO;
                    }
                }
                [weakSelf.listTable reloadData];
            } failure:^(NSError *error) {
                [weakSelf.listTable reloadData];
            }];
        }
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.listTable.mj_header;
    MJRefreshFooter *footer = self.listTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
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
//    return  80;
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isHaveSectionView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        view.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:self.clickButton];
        
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
    web.urlString = model.singpage;
    
//    if (self.ID == 1) {
//        self.titleString = @"";
//    } else if (self.ID == 2) {
//        self.titleString = @"";
//    }
    
    web.titleString = self.webTitleString;
    web.hidesBottomBarWhenPushed = YES;
    web.isHaveProgress = YES;
    web.article_type = model.type;
    web.article_id = model.id;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)buttonClick {
    if ([self.yp_tabItemTitle isEqualToString:@"申请通道"]) {
//        [self viewControllerPushOther:@"FHApplicationElectionIndustryCommitteController"];
        FHApplicationElectionIndustryCommitteController *vc = [[FHApplicationElectionIndustryCommitteController alloc] init];
        vc.titleString = @"选举服务申请";
        vc.property_id = self.property_id;
        vc.pid = self.pid;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([self.titleString isEqualToString:@"招标服务"]) {
//        [self viewControllerPushOther:@""];
        FHApplicationBiddingController *vc = [[FHApplicationBiddingController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.property_id = self.property_id;
        vc.pid = self.pid;
        [self.navigationController pushViewController:vc  animated:YES];
        return;
    }
    
    FHElectionListController *vc = [[FHElectionListController alloc] init];
    if ([self.yp_tabItemTitle isEqualToString:@"业委海选"]) {
        vc.titleString = @"业委海选";
    } else if ([self.yp_tabItemTitle isEqualToString:@"岗位选举"]) {
        vc.titleString = @"岗位选举";
    }
    vc.owner_id = [NSString stringWithFormat:@"%ld",(long)self.property_id];
    vc.pid = self.pid;
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
        _listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fh_getRequest)];
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
