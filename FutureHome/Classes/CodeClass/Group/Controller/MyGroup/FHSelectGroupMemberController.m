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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"选择群组成员";
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
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH - 55, MainStatusBarHeight + 5, 50, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:sureBtn];
}

/** 点击确定 到创建群组界面 */
- (void)sureBtnClick {
    /** 跳转到创建群组界面 */
    Account *account = [AccountStorage readAccount];
    if (self.selectPersonArrs.count <= 0) {
        [self.view makeToast:@"创建群组人数不能小于1"];
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
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getDataWithRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(account.user_id),@"uid",
                               nil];
    [AFNetWorkTool get:@"sheyun/mutualConcern" params:paramsDic success:^(id responseObj) {
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
    [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"头像"]];
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
        _homeTable.allowsMultipleSelectionDuringEditing = YES;
        [_homeTable setEditing:YES animated:YES];
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
