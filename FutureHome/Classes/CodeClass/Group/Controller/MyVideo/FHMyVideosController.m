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
@property (nonatomic, copy) NSArray *videoListDataArrs;

@end

@implementation FHMyVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHCommonVideosCollectionCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    [self getRequest];
}


- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *url;
    NSDictionary *paramsDictionary;
    if (self.type == 1) {
        /** 获取收藏的视频列表 */
        paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(account.user_id),@"user_id",
                            self.user_id ? self.user_id : @(account.user_id),@"uid",
                            nil];
        url = @"sheyun/videoCollect";
    } else {
        /** 获取视频列表 */
        paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(account.user_id),@"user_id",
                            self.user_id ? self.user_id : @(account.user_id),@"uid",
                            nil];
        url = @"sheyun/myVideo";
    }

    [AFNetWorkTool get:url params:paramsDictionary success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.videoListArrs = [[NSMutableArray alloc] init];
            weakSelf.videoListDataArrs = responseObj[@"data"][@"list"];
            self.videoListArrs = [FHVideosListModel mj_objectArrayWithKeyValuesArray:weakSelf.videoListDataArrs];
            [weakSelf.homeTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
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
    return cell;
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
