//
//  FHOtherFollowController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  其他收藏 船新的收藏界面

#import "FHOtherFollowController.h"
#import "FHOtherFollowCell.h"
#import "FHWebViewController.h"
#import "FHDocumentCollectModel.h"

@interface FHOtherFollowController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 文档收藏列表 */
@property (nonatomic, strong) NSMutableArray *documentCollectArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger page;

@end

@implementation FHOtherFollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.documentCollectArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHOtherFollowCell class] forCellReuseIdentifier:NSStringFromClass([FHOtherFollowCell class])];
    [self.view addSubview:self.homeTable];
    [self getRequest];
    [self setSettingMJRefreshConfiguration];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setSettingMJRefreshConfiguration {
    self.homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRequest];
    }];
    
    self.homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRequest)];
    // 马上进入刷新状态
//        [photoAlbumVC.mj_header beginRefreshing];
    
//    //上啦加载
//    self.homeTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.page ++;
////        [self getPersonalPhotoAlbumData];
//        [self.homeTable.mj_footer endRefreshing];
//    }];
}

- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.page),@"page", nil];
    
    [AFNetWorkTool get:@"sheyun/documentCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.documentCollectArrs = [FHDocumentCollectModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
            [weakSelf.homeTable reloadData];
            [weakSelf.homeTable.mj_header endRefreshing];
            [weakSelf.homeTable.mj_footer endRefreshing];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable.mj_header endRefreshing];
        [weakSelf.homeTable.mj_footer endRefreshing];
    }];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.documentCollectArrs.count;
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
    FHOtherFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHOtherFollowCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectModel = self.documentCollectArrs[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHDocumentCollectModel *infoModel = self.documentCollectArrs[indexPath.row];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    Account *account = [AccountStorage readAccount];
    web.urlString = [NSString stringWithFormat:@"%@?id=%@&userid=%ld",infoModel.singpage,infoModel.id,(long)account.user_id];
    web.hidesBottomBarWhenPushed = YES;
    web.titleString = infoModel.title;
    web.isHaveProgress = YES;
    [self.navigationController pushViewController:web animated:YES];
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
