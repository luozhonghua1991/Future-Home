//
//  FHMyVideosController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  我的视频

#import "FHMyVideosController.h"
#import "FHCommonVideosCollectionCell.h"
#import "ZFDouYinViewController.h"
#import "ZFDouYinViewController.h"
#import "ZFTableData.h"
#import "FHVideosListModel.h"

@interface FHMyVideosController () <UITableViewDelegate,UITableViewDataSource,FHCommonVideosCollectionCellDelegate>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *tableHeaderView;
/** 视频数量 */
@property (nonatomic, strong) UILabel *videosCountLabel;
/** 获赞数量 */
@property (nonatomic, strong) UILabel *getUpCountLabel;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *videoListArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *videoListDataArrs;

@end

@implementation FHMyVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoListArrs = [[NSMutableArray alloc] init];
    self.videoListDataArrs = [[NSMutableArray alloc] init];
    [self.homeTable registerClass:[FHCommonVideosCollectionCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    [self.view addSubview:self.homeTable];
    [self loadInit];
}

#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.homeTable.mj_footer resetNoMoreData];
    
    [self getRequestLoadHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getRequestLoadHead:NO];
    } else {
        [self.homeTable.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.homeTable.mj_header;
    MJRefreshFooter *footer = self.homeTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

- (void)getRequestLoadHead:(BOOL)isHead {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *url;
    NSDictionary *paramsDictionary;
    if (self.type == 1) {
        /** 获取收藏的视频列表 */
        paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(account.user_id),@"user_id",
                            self.user_id ? self.user_id : @(account.user_id),@"uid",
                            @(curPage),@"page",
                            nil];
        url = @"sheyun/videoCollect";
    } else {
        /** 获取视频列表 */
        paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(account.user_id),@"user_id",
                            self.user_id ? self.user_id : @(account.user_id),@"uid",
                            @(curPage),@"page",
                            nil];
        url = @"sheyun/myVideo";
    }

    [AFNetWorkTool get:url params:paramsDictionary success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [weakSelf.videoListDataArrs removeAllObjects];
                [weakSelf.videoListArrs removeAllObjects];
            }
            [weakSelf endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [weakSelf.videoListDataArrs addObjectsFromArray:responseObj[@"data"][@"list"]];
            [weakSelf.videoListArrs addObjectsFromArray:[FHVideosListModel mj_objectArrayWithKeyValuesArray:weakSelf.videoListDataArrs]];
            [weakSelf.homeTable reloadData];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf endRefreshAction];
        [weakSelf.homeTable reloadData];
    }];
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
    return SCREEN_HEIGHT - MainSizeHeight - 35 - 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonVideosCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectionViewHeight = SCREEN_HEIGHT - MainSizeHeight - 35 - 20;
    cell.delegate = self;
    cell.rowCount = self.videoListArrs.count;
    cell.videoListArrs = self.videoListArrs;
    cell.type = 1;
    return cell;
}

- (void)fh_collectionCancleVideoSelectIndex:(NSIndexPath *)selectIndex model:(FHVideosListModel *)model {
    //在此添加你想要完成的功能
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定要取消收藏该视频吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            /** 取消收藏视频 */
            [weakSelf fh_collectionCancleVideoSelectIndex:selectIndex model:model];
        }
    }];
}
        
- (void)fh_cancleVideoInfoWithIndex:(NSIndexPath *)index model:(FHVideosListModel *)model {
    /** 取消收藏的接口 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.cid,@"cid",
                               nil];
    [AFNetWorkTool post:@"sheyun/cancelVideoCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"取消收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf loadInit];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
    }];
}


- (void)FHCommonVideosCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex {
    ZFDouYinViewController *douyin = [[ZFDouYinViewController alloc] init];
    douyin.videoListDataArrs = self.videoListDataArrs;
    [douyin playTheIndex:selectIndex.item];
    douyin.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:douyin animated:YES];
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70 - 20) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
        _homeTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
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
        
        self.videosCountLabel.centerY = _tableHeaderView.height / 2;
        self.getUpCountLabel.centerY = _tableHeaderView.height / 2;
        [_tableHeaderView addSubview:self.videosCountLabel];
        [_tableHeaderView addSubview:self.getUpCountLabel];
    }
    return _tableHeaderView;
}

- (UILabel *)videosCountLabel {
    if (!_videosCountLabel) {
        _videosCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 200, 40)];
        _videosCountLabel.font = [UIFont systemFontOfSize:13];
        _videosCountLabel.text = @"视频总数 : 125";
        _videosCountLabel.textColor = [UIColor blackColor];
        _videosCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _videosCountLabel;
}

- (UILabel *)getUpCountLabel {
    if (!_getUpCountLabel) {
        _getUpCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 15, 40)];
        _getUpCountLabel.font = [UIFont systemFontOfSize:13];
        _getUpCountLabel.text = @"获赞数量 : 48.2w";
        _getUpCountLabel.textColor = [UIColor blackColor];
        _getUpCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _getUpCountLabel;
}
@end
