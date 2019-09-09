//
//  FHMyAccountController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账户信息

#import "FHMyAccountController.h"
#import "FHMyAccountCell.h"
#import "FHChangeNameController.h"

@interface FHMyAccountController () <UITableViewDelegate,UITableViewDataSource>
/** table */
@property (nonatomic, strong) UITableView *homeTable;
/** 名字数组 */
@property (nonatomic, copy) NSArray *logoArrs;

@end

@implementation FHMyAccountController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户信息";
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHMyAccountCell class] forCellReuseIdentifier:NSStringFromClass([FHMyAccountCell class])];
    self.logoArrs = @[@"头像",@"昵称",@"未来家园号",@"未来家园号"];
    
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"账户信息";
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
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHMyAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMyAccountCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.logoLabel.text = [NSString stringWithFormat:@"%@",self.logoArrs[indexPath.row]];
    if (indexPath.row == 0||indexPath.row == 3) {
        cell.headerImg.hidden = NO;
        
        cell.rightArrowImg.hidden = YES;
        cell.contentLabel.hidden = YES;
    } else {
        cell.headerImg.hidden = YES;
        
        cell.rightArrowImg.hidden = NO;
        cell.contentLabel.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        /** 头像修改 */

    } else if (indexPath.row == 1) {
        /** 修改昵称 */
        FHChangeNameController *change = [[FHChangeNameController alloc] init];
        Account *account = [AccountStorage readAccount];
        change.strNikeName = account.nickname;
        [self.navigationController pushViewController:change animated:YES];
    }
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
//        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
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

@end
