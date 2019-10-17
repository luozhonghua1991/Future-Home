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
#import "ZFTableData.h"
#import "FHVideosListModel.h"

@interface FHVideosPublishingController () <UITableViewDelegate,UITableViewDataSource,FHCommonVideosCollectionCellDelegate>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 标头数据 */
@property (nonatomic, strong) FHServiceCommonHeaderView *tableHeaderView;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *videoListArrs;

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
    [self getRequest];
    if ([SingleManager shareManager].shoppingBar) {
        [[SingleManager shareManager].shoppingBar removeFromSuperview];
    }
}

- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    /** 获取视频列表 */
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(account.user_id),@"user_id",
                                      self.shopID,@"shop_id",
                                      @"1",@"page",
                                      @"100000",@"limit",
                                      nil];

    [AFNetWorkTool get:@"shop/getUserVideo" params:paramsDictionary success:^(id responseObj) {
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
    
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id", nil];
    [AFNetWorkTool get:@"shop/getSingShopInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            [weakSelf.tableHeaderView.headerImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"logo_img"]]];
            weakSelf.tableHeaderView.shopNameLabel.text = dic[@"shopname"];
            weakSelf.tableHeaderView.codeLabel.text = [NSString stringWithFormat:@"社云账号: %@",dic[@"username"]];
            weakSelf.tableHeaderView.countLabel.text = [NSString stringWithFormat:@"创作数量: %@",dic[@"document"]];
            weakSelf.tableHeaderView.upCountLabel.text = [NSString stringWithFormat:@"点赞数: %@",dic[@"like"]];
            weakSelf.tableHeaderView.fansLabel.text = [NSString stringWithFormat:@"粉丝数: %@",dic[@"fins"]];
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
    return SCREEN_HEIGHT - MainSizeHeight - 70 - 140;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonVideosCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommonVideosCollectionCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectionViewHeight = SCREEN_HEIGHT - MainSizeHeight - 70 - 140;
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

- (void)personCountBtnClick {
    
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
