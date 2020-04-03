//
//  FHSelectGroupMemberController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHSelectGroupMemberController.h"
#import "FHBlackListCell.h"
#import "FHCreatGroupController.h"

@interface FHSelectGroupMemberController () <UITableViewDataSource,UITableViewDelegate>

/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 用户列表 */
@property (nonatomic, strong) NSMutableArray *blackListArrs;
/** 选取的用户数组 */
@property (nonatomic, strong) NSMutableArray *selectPersonArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FHSelectGroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blackListArrs = [[NSMutableArray alloc] init];
    self.selectPersonArrs = [[NSMutableArray alloc] init];
    [self fh_creatNav];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHBlackListCell class] forCellReuseIdentifier:NSStringFromClass([FHBlackListCell class])];
    [self getDataWithRequest];
    
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:self.titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH - 55, MainStatusBarHeight + 5, 50, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.groupMemberType == GroupMemberType_allMemberList) {
        self.titleLabel.text = @"群组成员列表";
    } else {
        self.titleLabel.text = @"选择群组成员";
        [self.navgationView addSubview:sureBtn];
    }
}

/** 点击确定 到创建群组界面 */
- (void)sureBtnClick {
    if (self.groupMemberType == GroupMemberType_creatGroup) {
        /** 跳转到创建群组界面 */
        Account *account = [AccountStorage readAccount];
        if (self.selectPersonArrs.count <= 0) {
            [self.view makeToast:@"选择人数不能小于1"];
            return;
        }
        if (![self.selectPersonArrs containsObject:account.username]) {
            [self.selectPersonArrs addObject:account.username];
        }
        NSLog(@"xxxxxxxxx%lu",(unsigned long)self.selectPersonArrs.count);
        FHCreatGroupController *group = [[FHCreatGroupController alloc] init];
        group.hidesBottomBarWhenPushed = YES;
        group.selectPersonArrs = self.selectPersonArrs.mutableCopy;
        [self.navigationController pushViewController:group animated:YES];
    } else if (self.groupMemberType == GroupMemberType_addMember) {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSString *personSelectString = [self.selectPersonArrs componentsJoinedByString:@","];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   self.groupId,@"groupId",
                                   self.groupName,@"groupName",
                                   personSelectString,@"number_str",
                                   nil];
        [AFNetWorkTool post:@"sheyun/joinsGroup" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                [weakSelf.view makeToast:@"邀请进群成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    } else if (self.groupMemberType == GroupMemberType_subMember) {
        /** 移除群成员 */
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSString *personSelectString = [self.selectPersonArrs componentsJoinedByString:@","];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   self.groupId,@"groupId",
                                   personSelectString,@"number_str",
                                   nil];
        [AFNetWorkTool post:@"sheyun/groupQuit" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                [weakSelf.view makeToast:@"移除群成员成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getDataWithRequest {
    Account *account = [AccountStorage readAccount];
    NSString *url;
    NSDictionary *paramsDic;
    if (self.groupMemberType == GroupMemberType_allMemberList) {
        /** 群组成员列表 */
        url = @"sheyun/getGroupList";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     self.groupId,@"groupId",
                     @"1",@"type",
                     nil];
    } else if (self.groupMemberType == GroupMemberType_subMember) {
        /** 删除群组成员 */
        url = @"sheyun/getGroupList";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     self.groupId,@"groupId",
                     @"2",@"type",
                     nil];
    } else {
        /** 用户的互关列表 */
        url = @"sheyun/mutualConcern";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     @(account.user_id),@"uid",
                     nil];
    }
    WS(weakSelf);
    [AFNetWorkTool get:url params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *arr = responseObj[@"data"];
            [weakSelf.blackListArrs addObjectsFromArray:arr];
            [weakSelf.homeTable reloadData];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blackListArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHBlackListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSDictionary *dic = self.blackListArrs[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 15)];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@""]];
    cell.nameLabel.text = dic[@"nickname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHBlackListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = self.blackListArrs[indexPath.row];
    NSString *targetID = dic[@"username"];
    if (cell.isSelected) {
        if (![self.selectPersonArrs containsObject:targetID]) {
            [self.selectPersonArrs addObject:targetID];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    FHBlackListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = self.blackListArrs[indexPath.row];
    NSString *targetID = dic[@"username"];
    if (!cell.isSelected) {
        if ([self.selectPersonArrs containsObject:targetID]) {
            [self.selectPersonArrs removeObject:targetID];
        }
    }
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"暂无相关数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:167/255.0 green:181/255.0 blue:194/255.0 alpha:1/1.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (self.groupMemberType != GroupMemberType_allMemberList) {
            _homeTable.allowsMultipleSelectionDuringEditing = YES;
            [_homeTable setEditing:YES animated:YES];
        }
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
