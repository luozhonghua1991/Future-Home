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

@interface FHFriendLisController () <UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate>
/** <#strong属性注释#> */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHFriendLisController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHFriendListCell class] forCellReuseIdentifier:NSStringFromClass([FHFriendListCell class])];
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHFriendListCell class])];
    if ([self.yp_tabItemTitle isEqualToString:@"粉丝"]) {
        cell.followOrNoBtn.layer.borderColor = HEX_COLOR(0x1296db).CGColor;
        [cell.followOrNoBtn setTitle:@"＋关注" forState:UIControlStateNormal];
        [cell.followOrNoBtn setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
    } else if ([self.yp_tabItemTitle isEqualToString:@"关注"]) {
        cell.followOrNoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.followOrNoBtn setTitle:@"√已关注" forState:UIControlStateNormal];
        [cell.followOrNoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [cell.followOrNoBtn addTarget:self action:@selector(followOrNoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SingleManager shareManager].isSelectPerson) {
        return;
    }
    FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
    vc.titleString = @"许大宝~";
    [SingleManager shareManager].isSelectPerson = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark — event
- (void)followOrNoBtnClick {
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:@"确定不再关注?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [actionSheet setTitleColor:COLOR_1 fontSize:SCREEN_HEIGHT/667 *13];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *13];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *13 atIndex:0];
    [actionSheet addAnimation];
    [actionSheet show];
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
    
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH;
        if ([SingleManager shareManager].isSelectPerson) {
            tabbarH = 35;
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
