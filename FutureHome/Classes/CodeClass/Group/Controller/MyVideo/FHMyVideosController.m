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

@interface FHMyVideosController () <UITableViewDelegate,UITableViewDataSource,FHCommonVideosCollectionCellDelegate>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *tableHeaderView;
/** 视频数量 */
@property (nonatomic, strong) UILabel *videosCountLabel;
/** 获赞数量 */
@property (nonatomic, strong) UILabel *getUpCountLabel;

@end

@implementation FHMyVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHCommonVideosCollectionCell class] forCellReuseIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    self.homeTable.tableHeaderView = self.tableHeaderView;
    self.homeTable.tableHeaderView.height = self.tableHeaderView.height;
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
    return SCREEN_HEIGHT - MainSizeHeight - [self getTabbarHeight] - 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonVideosCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70) style:UITableViewStylePlain];
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
