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
#import "FHHealthMemberModel.h"
#import "BAAlertController.h"
#import "FHMedicalHistoryController.h"

@interface FHMedicalRecordsListController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *memberListArrs;


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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fh_getRequest];
}

- (void)creatBottomBtn {
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

- (void)fh_getRequest {
    WS(weakSelf);
    self.memberListArrs = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               nil];
    [AFNetWorkTool get:@"health/memberList" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *Dic = responseObj[@"data"];
            self.memberListArrs = [FHHealthMemberModel mj_objectArrayWithKeyValuesArray:Dic[@"list"]];
        } else {
            NSString *msg = responseObj[@"msg"];
            [self.view makeToast:msg];
        }
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberListArrs.count;
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
    FHHealthMemberModel *model = self.memberListArrs[indexPath.row];
    cell.model = model;
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}



#pragma mark  实现成为第一响应者方法
- (BOOL)canBecomeFirstResponder {
    return YES;
}



- (void) cellLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.homeTable];
        NSIndexPath * indexPath = [self.homeTable indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        
        //在此添加你想要完成的功能
        WS(weakSelf);
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定要删除该条记录吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 确定删除 */
                [weakSelf fh_deleteMemberInfoWithIndex:indexPath];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHHealthMemberModel *model = self.memberListArrs[indexPath.row];
    if ([self.yp_tabItemTitle isEqualToString:@"成员列表"]) {
        /** 修改成员信息 */
        FHAddPersonController *add = [[FHAddPersonController alloc] init];
        add.titleString = @"修改成员";
        add.hidesBottomBarWhenPushed = YES;
        add.model = model;
        add.ID = model.id;
        [self.navigationController pushViewController:add animated:YES];
    } else {
//        [self viewControllerPushOther:@"FHMedicalHistoryController"];
        FHMedicalHistoryController *add = [[FHMedicalHistoryController alloc] init];
        add.hidesBottomBarWhenPushed = YES;
        add.ID = model.id;
        [self.navigationController pushViewController:add animated:YES];
    }
}

- (void)fh_deleteMemberInfoWithIndex:(NSIndexPath *)index {
    FHHealthMemberModel *model = self.memberListArrs[index.row];
    /** 删除成员接口 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.id,@"id",
                               nil];
    [AFNetWorkTool post:@"health/deleteMember" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf fh_getRequest];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
    }];
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
