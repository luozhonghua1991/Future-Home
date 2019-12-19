//
//  FHFriendLisController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  好友关注列表

#import "FHFriendLisController.h"
#import "FHFriendListCell.h"
#import "FHPersonTrendsController.h"
#import "FHFollowListModel.h"

@interface FHFriendLisController () <UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate>
/** <#strong属性注释#> */
@property (nonatomic, strong) UITableView *homeTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *followListDataArrs;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *follow_id;

@end

@implementation FHFriendLisController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHFriendListCell class] forCellReuseIdentifier:NSStringFromClass([FHFriendListCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fh_getRequest];
}

- (void)fh_getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.user_id ? self.user_id : @(account.user_id),@"uid",
                               nil];
    NSString *url;
    if ([self.yp_tabItemTitle isEqualToString:@"粉丝"]) {
        url = @"sheyun/fansList";
    } else {
        url = @"sheyun/followList";
    }
    
    [AFNetWorkTool get:url params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.followListDataArrs = [[NSMutableArray alloc] init];
            self.followListDataArrs = [FHFollowListModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
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
    return self.followListDataArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHFriendListCell class])];
    cell.followListModel = self.followListDataArrs[indexPath.row];
    if ([cell.followListModel.follow_msg isEqualToString:@"互为关注"]) {
        cell.followOrNoBtn.layer.borderColor = HEX_COLOR(0x1296db).CGColor;
        [cell.followOrNoBtn setTitle:@"互为关注" forState:UIControlStateNormal];
        [cell.followOrNoBtn setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
    } else if ([cell.followListModel.follow_msg isEqualToString:@"已关注"]) {
        cell.followOrNoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.followOrNoBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [cell.followOrNoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }  else {
        cell.followOrNoBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        [cell.followOrNoBtn setTitle:@"＋关注" forState:UIControlStateNormal];
        [cell.followOrNoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    [cell.followOrNoBtn addTarget:self action:@selector(followOrNoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.followOrNoBtn.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHFollowListModel *followListModel = self.followListDataArrs[indexPath.row];
    FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
    vc.titleString = followListModel.nickname;
    [SingleManager shareManager].isSelectPerson = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.personType = 0;
    vc.follow_msg = followListModel.follow_msg;
    if ([self.yp_tabItemTitle isEqualToString:@"粉丝"]) {
        vc.user_id = followListModel.follower;
    } else {
        vc.user_id = followListModel.follow_id;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark — event
- (void)followOrNoBtnClick:(UIButton *)sender {
    /** 如果是关注状态 取消关注 未关注状态 就关注 */
    NSString *titleStr;
    FHFollowListModel *followListModel = self.followListDataArrs[sender.tag];
    if ([self.yp_tabItemTitle isEqualToString:@"粉丝"]) {
        self.follow_id = followListModel.follower;
    } else {
        self.follow_id = followListModel.follow_id;
    }
    if ([followListModel.follow_msg isEqualToString:@"互为关注"] || [followListModel.follow_msg isEqualToString:@"已关注"]) {
        titleStr = @"确定不再关注?";
    } else {
        titleStr = @"确定关注?";
    }
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [actionSheet setTitleColor:COLOR_1 fontSize:SCREEN_HEIGHT/667 *13];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *13];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *13 atIndex:0];
    [actionSheet addAnimation];
    [actionSheet show];
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        /** 取消关注或者关注 */
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
//                                   @(32),@"user_id",
                                   self.follow_id,@"follow_id", nil];
        
        [AFNetWorkTool post:@"sheyun/doFollow" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                [weakSelf.view makeToast:@"操作成功"];
                [weakSelf fh_getRequest];
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            [weakSelf.homeTable reloadData];
        }];
    }
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH;
        if ([SingleManager shareManager].isSelectPerson) {
            tabbarH = [self getTabbarHeight];
        } else {
            tabbarH = [self getTabbarHeight] + 70;
            
        }
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH) style:UITableViewStylePlain];
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
