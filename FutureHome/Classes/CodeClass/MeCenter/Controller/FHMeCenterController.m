//
//  FHMeCenterController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  个人中心

#import "FHMeCenterController.h"
#import "FHMeCenterUserInfoView.h"
#import "FHLoginTool.h"

@interface FHMeCenterController () <UITableViewDelegate,UITableViewDataSource>
/** 个人中心列表数据 */
@property (nonatomic, strong) UITableView *meCenterTable;
/** 个人信息提示数据 */
@property (nonatomic, copy) NSArray *logoArrs;
/** 头视图 */
@property (nonatomic, strong) FHMeCenterUserInfoView *meCenterHeaderView;
/** 表尾部视图 */
@property (nonatomic, strong) UIView *meCenterFooterView;

@end

@implementation FHMeCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    self.logoArrs = @[@"账户信息",
                      @"我的收藏",
                      @"实名认证",
                      @"隐私设置",
                      @"账户申请",
                      @"关于未来家园"];
    [self.view addSubview:self.meCenterTable];
    self.meCenterTable.tableHeaderView = self.meCenterHeaderView;
    self.meCenterHeaderView.height = self.meCenterHeaderView.height;
    self.meCenterTable.tableFooterView = self.meCenterFooterView;
    self.meCenterFooterView.height = self.meCenterFooterView.height;
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"个人中心";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.logoArrs.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 35.f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 35.f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.f;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.logoArrs[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 5) {
            cell.detailTextLabel.text = @"版本号1.0.1";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        } else {
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *ID = @"cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = @"客服电话 : 02555555555";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            /** 账户信息 */
            [self viewControllerPushOther:@"FHMyAccountController"];
        } else if (indexPath.row == 1) {
            /** 我的收藏 */
            [self viewControllerPushOther:@"FHMyFollowListController"];
        } else if (indexPath.row == 2) {
            /** 实名认证 */
            [self viewControllerPushOther:@"FHCertificationController"];
        } else if (indexPath.row == 3) {
            /** 隐私设置 */
            [self viewControllerPushOther:@"FHPrivacySettingsController"];
        } else if (indexPath.row == 4) {
            /** 账户申请 */
            [self viewControllerPushOther:@"FHAccountApplyController"];
        } else if (indexPath.row == 5) {
            /** 关于未来家园 */
            [self viewControllerPushOther:@"FHAboutFutureHomeController"];
        }
    }
                                                                                    
}

- (void)viewControllerPushOther:(nonnull NSString *)nameVC {
    UIViewController *vc = [[NSClassFromString(nameVC) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark — event
- (void)logOutClick {
    /** 退出登录 */
    [FHLoginTool fh_makePersonToLoging];
}

- (void)exchangeBtnClick {
    /** 切换用户 */
}

#pragma mark — setter & getter
- (UITableView *)meCenterTable {
    if (_meCenterTable == nil) {
        CGFloat tabbarH = KIsiPhoneX ? 83 : 49;
        _meCenterTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH) style:UITableViewStylePlain];
        _meCenterTable.dataSource = self;
        _meCenterTable.delegate = self;
        _meCenterTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _meCenterTable.showsVerticalScrollIndicator = NO;
        _meCenterTable.scrollEnabled = YES;
        if (@available (iOS 11.0, *)) {
            _meCenterTable.estimatedSectionHeaderHeight = 0.01;
            _meCenterTable.estimatedSectionFooterHeight = 0.01;
            _meCenterTable.estimatedRowHeight = 0.01;
        }
    }
    return _meCenterTable;
}

- (UIView *)meCenterFooterView {
    if (!_meCenterFooterView) {
        _meCenterFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        _meCenterFooterView.backgroundColor = [UIColor whiteColor];
        _meCenterFooterView.userInteractionEnabled = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_meCenterFooterView addSubview:lineView];
        
        UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeBtn.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 55);
        [exchangeBtn addTarget:self action:@selector(exchangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [exchangeBtn setTitle:@"切换用户" forState:0];
        [exchangeBtn setBackgroundColor:[UIColor redColor]];
        [_meCenterFooterView addSubview:exchangeBtn];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 75, SCREEN_WIDTH - 20, 55);
        [btn addTarget:self action:@selector(logOutClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"退出登录" forState:0];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [_meCenterFooterView addSubview:btn];
        
    }
    return _meCenterFooterView;
}

- (FHMeCenterUserInfoView *)meCenterHeaderView {
    if (!_meCenterHeaderView) {
        _meCenterHeaderView = [[FHMeCenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85 + 20)];
    }
    return _meCenterHeaderView;
}

@end
