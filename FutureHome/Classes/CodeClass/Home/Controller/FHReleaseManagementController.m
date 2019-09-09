//
//  FHReleaseManagementController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHReleaseManagementController.h"
#import "FHHouseSaleCell.h"

@interface FHReleaseManagementController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHReleaseManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHHouseSaleCell class] forCellReuseIdentifier:NSStringFromClass([FHHouseSaleCell class])];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    UIButton *cancleBtn = [self creatBtnWithBtnName:@"下架"];
    cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 140, 15, 60, 20);
    [bgView addSubview:cancleBtn];
    
    UIButton *watieOrderBtn = [self creatBtnWithBtnName:@"删除"];
    watieOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 15, 60, 20);
    [bgView addSubview:watieOrderBtn];
    
    return bgView;
}

- (UIButton *)creatBtnWithBtnName:(NSString *)name {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:HEX_COLOR(0x1296db)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    return btn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHHouseSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHHouseSaleCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStyleGrouped];
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
