//
//  FHMessageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  对话列表界面

#import "FHMessageController.h"
#import "FHFriendMessageController.h"

@interface FHMessageController () 

@end

@implementation FHMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat tabbarHeight;
    if (KIsiPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max || IS_IPHONE_Xs) {
        tabbarHeight = 83;
    } else {
        tabbarHeight = 49;
    }
    self.conversationListTableView.height = SCREEN_HEIGHT - tabbarHeight - MainSizeHeight - 35;
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        ]];
    self.conversationListTableView.tableFooterView = [UIView new];
}

//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.targetId,@"userId",
                               nil];
    
    [AFNetWorkTool get:@"sheyun/getUserInfor" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            FHFriendMessageController *conversationVC = [[FHFriendMessageController alloc] init];
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = model.targetId;
            conversationVC.titleString = responseObj[@"data"][@"userName"];
            conversationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self.view addSubview:self.homeTable];
//    [self.homeTable registerClass:[FHChatMessageCell class] forCellReuseIdentifier:NSStringFromClass([FHChatMessageCell class])];
//}
//
//
//#pragma mark  -- tableViewDelagate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 15;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70.0f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FHChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHChatMessageCell class])];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    FHFriendMessageController *message = [[FHFriendMessageController alloc] init];
//    message.titleString = @"许狗毛~";
//    message.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:message animated:YES];
//}
//
//#pragma mark — setter & getter
//- (UITableView *)homeTable {
//    if (_homeTable == nil) {
//        CGFloat tabbarHeight;
//        if (KIsiPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max || IS_IPHONE_Xs) {
//            tabbarHeight = 83;
//        } else {
//             tabbarHeight = 49;
//        }
//        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - tabbarHeight - MainSizeHeight - 35 * 2) style:UITableViewStylePlain];
//        _homeTable.dataSource = self;
//        _homeTable.delegate = self;
//        _homeTable.showsVerticalScrollIndicator = NO;
//        if (@available (iOS 11.0, *)) {
//            _homeTable.estimatedSectionHeaderHeight = 0.01;
//            _homeTable.estimatedSectionFooterHeight = 0.01;
//            _homeTable.estimatedRowHeight = 0.01;
//        }
//    }
//    return _homeTable;
//}

//- (UIView *)headerView {
//    if (!_headerView) {
//        _headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
//        _headerView.backgroundColor = [UIColor redColor];
//    }
//    return _headerView;
//}
//
//- (UILabel *)groupCountLabel {
//    if (!_groupCountLabel) {
//        _groupCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, SCREEN_WIDTH - 200, 13)];
//        _groupCountLabel.font = [UIFont systemFontOfSize:13];
//        _groupCountLabel.text = @"群聊数量 : 21 ";
//        _groupCountLabel.textColor = [UIColor blackColor];
//        _groupCountLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _groupCountLabel;
//}
//
//- (UIButton *)creatGroupBtn {
//    if (!_creatGroupBtn) {
//        _creatGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _creatGroupBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 15, 100, 13);
//        [_creatGroupBtn setTitle:@"＋新建群聊" forState:UIControlStateNormal];
//        [_creatGroupBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        _creatGroupBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_creatGroupBtn addTarget:self action:@selector(creatGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _creatGroupBtn;
//}

@end
