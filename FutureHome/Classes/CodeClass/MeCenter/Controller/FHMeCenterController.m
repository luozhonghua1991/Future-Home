//
//  FHMeCenterController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  个人中心

#import "FHMeCenterController.h"
#import "FHMeCenterUserInfoView.h"

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
    self.title = @"个人中心";
    self.logoArrs = @[@"账户信息",
                      @"我的云数据",
                      @"我的收藏",
                      @"实名认证",
                      @"支付设置",
                      @"隐私设置",
                      @"客户服务",
                      @"账户申请",
                      @"关于未来家园"];
    [self.view addSubview:self.meCenterTable];
    self.meCenterTable.tableHeaderView = self.meCenterHeaderView;
    self.meCenterHeaderView.height = 150;
    self.meCenterTable.tableFooterView = self.meCenterFooterView;
    self.meCenterFooterView.height = 70;
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logoArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.logoArrs[indexPath.row]];
    if (indexPath.row == 7) {
        cell.detailTextLabel.text = @"版本号1.0.1";
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}



#pragma mark — event
- (void)logOutClick {
    /** 退出登录 */

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
        _meCenterFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _meCenterFooterView.backgroundColor = [UIColor whiteColor];
        _meCenterFooterView.userInteractionEnabled = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_meCenterFooterView addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 55);
        [btn addTarget:self action:@selector(logOutClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"退出登录" forState:0];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [_meCenterFooterView addSubview:btn];
    }
    return _meCenterFooterView;
}

- (FHMeCenterUserInfoView *)meCenterHeaderView {
    if (!_meCenterHeaderView) {
        _meCenterHeaderView = [[FHMeCenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    return _meCenterHeaderView;
}

@end
