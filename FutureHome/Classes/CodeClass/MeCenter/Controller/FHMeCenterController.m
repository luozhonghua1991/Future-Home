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
#import "FHScanDetailAlertView.h"

@interface FHMeCenterController () <UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate,FHMeCenterUserInfoViewDelegate>
/** 个人中心列表数据 */
@property (nonatomic, strong) UITableView *meCenterTable;
/** 个人信息提示数据 */
@property (nonatomic, copy) NSArray *logoArrs;
/** 头视图 */
@property (nonatomic, strong) FHMeCenterUserInfoView *meCenterHeaderView;
/** 表尾部视图 */
@property (nonatomic, strong) UIView *meCenterFooterView;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHScanDetailAlertView *codeDetailView;

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
                      @"开通账户",
                      @"关于社云"];
    [self.view addSubview:self.meCenterTable];
    self.meCenterTable.tableFooterView = self.meCenterFooterView;
    self.meCenterFooterView.height = self.meCenterFooterView.height;
    self.meCenterTable.tableHeaderView = self.meCenterHeaderView;
    self.meCenterHeaderView.height = self.meCenterHeaderView.height;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Account *account = [AccountStorage readAccount];
    [self.meCenterHeaderView.userHeaderImgView sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.meCenterHeaderView.userNameLabel.text = account.nickname;
    self.meCenterHeaderView.futureHomeCodeLabel.text = [NSString stringWithFormat:@"社云号: %@",account.username];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if (self.codeDetailView) {
//        [self.codeDetailView removeFromSuperview];
//    }
//}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"个人中心";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    cell.textLabel.text = @"投诉邮箱";
    cell.detailTextLabel.text = @"123456@qq.com";
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
            /** 开通账户 */
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"要注销登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"退出账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /** 删除用户信息 */
        [AccountStorage removeAccount];
        [FHLoginTool fh_makePersonToLoging];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:logout];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)exchangeBtnClick {
    /** 切换用户 */
}

- (void)fh_personCodeTapCLick {
    if (self.codeDetailView) {
        [self.codeDetailView removeFromSuperview];
        self.codeDetailView = nil;
    }
    self.codeDetailView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
    [UIView animateWithDuration:0.3 animations:^{
        self.codeDetailView.alpha = 1;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
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
        _meCenterFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _meCenterFooterView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        _meCenterFooterView.userInteractionEnabled = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_meCenterFooterView addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 55);
        [btn addTarget:self action:@selector(logOutClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"退出登录" forState:0];
        [btn setTitleColor:[UIColor redColor] forState:0];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [_meCenterFooterView addSubview:btn];
        
    }
    return _meCenterFooterView;
}

- (FHMeCenterUserInfoView *)meCenterHeaderView {
    if (!_meCenterHeaderView) {
        _meCenterHeaderView = [[FHMeCenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85 + 20)];
        _meCenterHeaderView.delegate = self;
    }
    return _meCenterHeaderView;
}

- (FHScanDetailAlertView *)codeDetailView {
    if (!_codeDetailView) {
        _codeDetailView = [[FHScanDetailAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"com.sheyun",@"app_key",
                                   @(account.user_id),@"id",
                                   account.nickname,@"name",
                                   account.username,@"username",
                                   @"1",@"type",
                                   /** 下面的用不到 没啥用 */
                                   //                                   @"false",@"is_collect",
                                   //                                   @"0",@"slat",
                                   //                                   @"0",@"slng",
                                   //                                   @"",@"address",
                                   nil];
        _codeDetailView.dataDetaildic = paramsDic;
    }
    return _codeDetailView;
}

@end
