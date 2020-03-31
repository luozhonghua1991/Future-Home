//
//  FHScrollNewsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  滚动消息的通用界面

#import "FHScrollNewsController.h"
#import "FHInformationMesageCell.h"
#import "FHScrollNewsModel.h"
#import "FHWebViewController.h"

@interface FHScrollNewsController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 滚动信息列表 */
@property (nonatomic, strong) NSMutableArray *scrollNewsArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger page;


@end

@implementation FHScrollNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollNewsArrs = [[NSMutableArray alloc] init];
    self.page = 1;
    [self fh_creatNav];
    [self.homeTable registerClass:[FHInformationMesageCell class] forCellReuseIdentifier:NSStringFromClass([FHInformationMesageCell class])];
    [self.view addSubview:self.homeTable];
    [self getRequest];
    [self setSettingMJRefreshConfiguration];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"滚动消息列表";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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

- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.type,@"type",
                               @(self.page),@"page",
                               @"20",@"limit",
                               nil];
    [AFNetWorkTool get:@"ScrollNew/getListInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.scrollNewsArrs = [FHScrollNewsModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
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

- (void)setSettingMJRefreshConfiguration {
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


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scrollNewsArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHInformationMesageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHInformationMesageCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FHScrollNewsModel *newsModel = self.scrollNewsArrs[indexPath.row];
    cell.newsModel = newsModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHScrollNewsModel *newsModel = self.scrollNewsArrs[indexPath.row];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    Account *account = [AccountStorage readAccount];
    web.urlString = [NSString stringWithFormat:@"%@?id=%@&userid=%ld",newsModel.singpage,newsModel.id,(long)account.user_id];
    web.titleString = newsModel.title;
    web.typeString = @"information";
    web.hidesBottomBarWhenPushed = YES;
    web.isHaveProgress = YES;
    web.type = @"noShow";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
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
