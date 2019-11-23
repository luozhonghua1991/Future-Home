//
//  FHInformationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  信息发布

#import "FHInformationController.h"
#import "FHServiceCommonHeaderView.h"
#import "FHInformationMesageCell.h"
#import "FHInformationModel.h"
#import "FHWebViewController.h"

@interface FHInformationController () <UITableViewDelegate,UITableViewDataSource>
/** 标头数据 */
@property (nonatomic, strong) FHServiceCommonHeaderView *tableHeaderView;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 信息发布列表 */
@property (nonatomic, strong) NSMutableArray *informationArrs;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *shopName;


@end

@implementation FHInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    self.homeTable.tableHeaderView = self.tableHeaderView;
    self.homeTable.tableHeaderView.height = self.tableHeaderView.height;
    [self.homeTable registerClass:[FHInformationMesageCell class] forCellReuseIdentifier:NSStringFromClass([FHInformationMesageCell class])];
    [self getRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)getRequest {
    /** 获取商家详情 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id", nil];
    [AFNetWorkTool get:@"shop/getSingShopInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            [weakSelf.tableHeaderView.headerImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"logo_img"]] placeholderImage:[UIImage imageNamed:@"头像"]];
            weakSelf.tableHeaderView.shopNameLabel.text = dic[@"shopname"];
            weakSelf.shopName = weakSelf.tableHeaderView.shopNameLabel.text;
            weakSelf.tableHeaderView.codeLabel.text = [NSString stringWithFormat:@"社云账号: %@",dic[@"username"]];
            weakSelf.tableHeaderView.countLabel.text = [NSString stringWithFormat:@"文档: %@",dic[@"document"]];
            weakSelf.tableHeaderView.upCountLabel.text = [NSString stringWithFormat:@"点赞: %@",dic[@"like"]];
             weakSelf.tableHeaderView.fansLabel.text = [NSString stringWithFormat:@"粉丝: %@",dic[@"fins"]];
            [weakSelf.homeTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
    
    self.informationArrs = [[NSMutableArray alloc] init];
    /** 获取文章列表 */
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(account.user_id),@"user_id",
                                      self.shopID,@"shop_id",
                                      @"1",@"page",
                                      @"100000",@"limit",
                                      nil];
    
    [AFNetWorkTool get:@"shop/getUserArticle" params:paramsDictionary success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.informationArrs = [FHInformationModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
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
    return self.informationArrs.count;
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
    FHInformationModel *infoModel = self.informationArrs[indexPath.row];
    cell.infoModel = infoModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHInformationModel *infoModel = self.informationArrs[indexPath.row];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    Account *account = [AccountStorage readAccount];
    web.urlString = [NSString stringWithFormat:@"%@?id=%@&userid=%ld",infoModel.singpage,infoModel.id,(long)account.user_id];
    web.titleString = self.shopName;
    web.hidesBottomBarWhenPushed = YES;
    web.isHaveProgress = YES;
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark — event
/** 用户评论 */
- (void)personCountBtnClick {
    
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight + 70, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 70) style:UITableViewStylePlain];
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

- (FHServiceCommonHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FHServiceCommonHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        [_tableHeaderView.personCountBtn addTarget:self action:@selector(personCountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableHeaderView;
}

@end
