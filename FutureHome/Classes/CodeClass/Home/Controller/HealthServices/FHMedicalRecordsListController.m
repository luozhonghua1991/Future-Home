//
//  FHMedicalRecordsListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMedicalRecordsListController.h"
#import "FHAddPersonController.h"
#import "FHMedicalRecordsListCell.h"

@interface FHMedicalRecordsListController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHMedicalRecordsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.yp_tabItemTitle isEqualToString:@"成员列表"]) {
        [self creatBottomBtn];
    }
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHMedicalRecordsListCell class] forCellReuseIdentifier:NSStringFromClass([FHMedicalRecordsListCell class])];
}

- (void)creatBottomBtn{
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0,SCREEN_HEIGHT - MainSizeHeight - 35 - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    addBtn.backgroundColor = HEX_COLOR(0x1296db);
    [addBtn setTitle:@"添加成员" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

- (void)addBtnClick {
    /** 添加成员 */
    FHAddPersonController *add = [[FHAddPersonController alloc] init];
    add.titleString = @"添加成员";
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHMedicalRecordsListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMedicalRecordsListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.yp_tabItemTitle isEqualToString:@"成员列表"]) {
        /** 修改成员信息 */
        FHAddPersonController *add = [[FHAddPersonController alloc] init];
        add.titleString = @"修改成员";
        add.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:add animated:YES];
    } else {
        [self viewControllerPushOther:@"FHMedicalHistoryController"];
    }
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        if ([self.yp_tabItemTitle isEqualToString:@"成员列表"]) {
            _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35 - ZH_SCALE_SCREEN_Height(50)) style:UITableViewStylePlain];
        } else {
            _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStylePlain];
        }
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
