//
//  FHPrivacySettingsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/25.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  隐私设置界面

#import "FHPrivacySettingsController.h"
#import "FHPrivacySettingsCell.h"

@interface FHPrivacySettingsController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 上面的logoName */
@property (nonatomic, copy) NSArray *topLogoNameArrs;
/** 下面的logoName */
@property (nonatomic, copy) NSArray *bottomLogoNameArrs;
/** 上面最后选择的indexPath */
@property (nonatomic, assign) NSIndexPath *topLastIndexPath;
/** 下面最后选择的indexPath */
@property (nonatomic, assign) NSIndexPath *bottomLastIndexPath;

@end

@implementation FHPrivacySettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self.view addSubview:self.homeTable];
    self.topLogoNameArrs = @[@"仅限好友",
                             @"好友和粉丝",
                             @"所有人"];
    self.bottomLogoNameArrs = @[@"仅限好友",
                             @"好友和粉丝",
                             @"所有人"];
    [self.homeTable registerClass:[FHPrivacySettingsCell class] forCellReuseIdentifier:NSStringFromClass([FHPrivacySettingsCell class])];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"隐私设置";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 2) {
//        return 1;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        return 10.0f;
//    }
//    return 37.0f;
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 2) {
        return 0.0f;
//    }
//    return 40.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 2) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        view.backgroundColor = [UIColor whiteColor];
//        return view;
//    } else {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        view.backgroundColor = [UIColor whiteColor];
//
//        UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 16)];
//        logoLabel.textAlignment = NSTextAlignmentLeft;
//
//        if (section == 0) {
//            logoLabel.text = @"谁可以发消息给我";
//        } else {
//            logoLabel.text = @"谁可以看我的朋友圈";
//        }
//        [view addSubview:logoLabel];
//        return view;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//        view.backgroundColor = [UIColor whiteColor];
//
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, 2, SCREEN_WIDTH - 40, 1)];
//        bottomLine.backgroundColor = [UIColor lightGrayColor];
//        [view addSubview:bottomLine];
//
//        return view;
//    } else {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
//        view.backgroundColor = [UIColor whiteColor];
//
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, 2, SCREEN_WIDTH - 40, 1)];
//        bottomLine.backgroundColor = [UIColor lightGrayColor];
//        [view addSubview:bottomLine];
//        return view;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1) {
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = @"黑名单";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
//    } else if (indexPath.section == 0) {
//            FHPrivacySettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHPrivacySettingsCell class])];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.logoLabel.text = [NSString stringWithFormat:@"%@",self.topLogoNameArrs[indexPath.row]];
//            if (self.topLastIndexPath == indexPath) {
//                cell.selectBtn.backgroundColor = HEX_COLOR(0x1296db);
//            } else {
//                cell.selectBtn.backgroundColor = [UIColor redColor];
//            }
//        return cell;
//        } else {
//            FHPrivacySettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHPrivacySettingsCell class])];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.logoLabel.text = [NSString stringWithFormat:@"%@",self.bottomLogoNameArrs[indexPath.row]];
//            if (self.bottomLastIndexPath == indexPath) {
//                cell.selectBtn.backgroundColor = HEX_COLOR(0x1296db);
//            } else {
//                cell.selectBtn.backgroundColor = [UIColor redColor];
//            }
//              return cell;
//        }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self viewControllerPushOther:@"FHBlackListController"];
    return;
    
    
    if (indexPath.section == 2) {
        /** 黑名单列表 */
        
    } else {
        if (indexPath.section == 0) {
            FHPrivacySettingsCell *oldCell = [tableView cellForRowAtIndexPath:self.topLastIndexPath];
            oldCell.selectBtn.backgroundColor = [UIColor redColor];
            self.topLastIndexPath = indexPath;
            FHPrivacySettingsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectBtn.backgroundColor = HEX_COLOR(0x1296db);
        } else {
            FHPrivacySettingsCell *oldCell = [tableView cellForRowAtIndexPath:self.bottomLastIndexPath];
            oldCell.selectBtn.backgroundColor = [UIColor redColor];
            self.bottomLastIndexPath = indexPath;
            FHPrivacySettingsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectBtn.backgroundColor = HEX_COLOR(0x1296db);
        }
    }
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
