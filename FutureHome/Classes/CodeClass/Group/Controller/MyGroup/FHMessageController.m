//
//  FHMessageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  对话列表界面

#import "FHMessageController.h"
#import "FHChatMessageCell.h"
#import "FHFriendMessageController.h"

@interface FHMessageController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
//@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.tableFooterView = [UIView new];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        ]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
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

#pragma mark - <RCIMUserInfoDataSource>
/*!
 获取用户信息
 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
//-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
//{
//    //设置用户信息
//    NSString *avatarURL = @"http://xxxxxx.com/static/avatar/137180371639017.jpeg";
//    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userId portrait:avatarURL];
//    
//    //block回调设置用户信息
//    completion(userInfo);
//}

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
            conversationVC.conversationType = model.conversationType;
            conversationVC.targetId = model.targetId;
            conversationVC.titleString = responseObj[@"data"][@"userName"];
            conversationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
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

@end
