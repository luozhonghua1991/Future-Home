//
//  FHGroupMessageListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  群聊界面

#import "FHGroupMessageListController.h"
#import "FHGroupMessageCell.h"

@interface FHGroupMessageListController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 表头 */
@property (nonatomic, strong) UIView *headerView;
/** 群组数量界面 */
@property (nonatomic, strong) UILabel *groupCountLabel;
/** 创建群组 */
@property (nonatomic, strong) UIButton *creatGroupBtn;

@end

@implementation FHGroupMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHGroupMessageCell class] forCellReuseIdentifier:NSStringFromClass([FHGroupMessageCell class])];
    [self.headerView addSubview:self.groupCountLabel];
    [self.headerView addSubview:self.creatGroupBtn];
    self.homeTable.tableHeaderView = self.headerView;
    self.homeTable.tableHeaderView.height = self.headerView.height;
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
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHGroupMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHGroupMessageCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark — event
- (void)creatGroupBtnClick {
    /** 创建新的群聊 */

}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [self getTabbarHeight] - MainSizeHeight - 70 - 35) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UILabel *)groupCountLabel {
    if (!_groupCountLabel) {
        _groupCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, SCREEN_WIDTH - 200, 13)];
        _groupCountLabel.font = [UIFont systemFontOfSize:13];
        _groupCountLabel.text = @"群聊数量 : 21 ";
        _groupCountLabel.textColor = [UIColor blackColor];
        _groupCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _groupCountLabel;
}

- (UIButton *)creatGroupBtn {
    if (!_creatGroupBtn) {
        _creatGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _creatGroupBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 15, 100, 13);
        [_creatGroupBtn setTitle:@"＋新建群聊" forState:UIControlStateNormal];
        [_creatGroupBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _creatGroupBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_creatGroupBtn addTarget:self action:@selector(creatGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creatGroupBtn;
}

@end
