//
//  FHGroupMessageListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  群聊界面

#import "FHGroupMessageListController.h"
#import "FHGroupMessageCell.h"
#import "FHSelectGroupMemberController.h"
#import "FHFriendMessageController.h"

@interface FHGroupMessageListController () <UIScrollViewDelegate>
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
    //设置需要显示哪些类型的会话
    CGFloat tabbarHeight;
    if (KIsiPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs_Max || IS_IPHONE_Xs) {
        tabbarHeight = 83;
    } else {
        tabbarHeight = 49;
    }
    self.conversationListTableView.height = SCREEN_HEIGHT - tabbarHeight - MainSizeHeight - 35;
    [self setDisplayConversationTypes:@[@(ConversationType_GROUP),
                                        ]];
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.groupCountLabel];
    [self.headerView addSubview:self.creatGroupBtn];
    self.headerView.userInteractionEnabled = YES;
    self.conversationListTableView.tableHeaderView.height = self.headerView.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupCount) name:@"UPDATEGROUPCOUNT" object:nil];
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

- (void)updateGroupCount {
    self.groupCountLabel.text = [NSString stringWithFormat:@"群聊数量 : %lu ",(unsigned long)[SingleManager shareManager].allGroupsArrs.count];
}

#pragma mark — event
- (void)creatGroupBtnClick {
    /** 创建新的群聊 */
    FHSelectGroupMemberController *VC = [[FHSelectGroupMemberController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.groupMemberType = GroupMemberType_creatGroup;
    [self.navigationController pushViewController:VC animated:YES];
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.targetId,@"groupId",
                               nil];
    
    [AFNetWorkTool get:@"sheyun/getGroupDetail" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            FHFriendMessageController *conversationVC = [[FHFriendMessageController alloc] init];
            conversationVC.conversationType = ConversationType_GROUP;
            conversationVC.targetId = model.targetId;
            conversationVC.titleString = responseObj[@"data"][@"groupName"];
            conversationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [SingleManager shareManager].scrolling = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark — setter & getter
//- (UITableView *)homeTable {
//    if (_homeTable == nil) {
//        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [self getTabbarHeight] - MainSizeHeight - 70 - 35) style:UITableViewStylePlain];
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UILabel *)groupCountLabel {
    if (!_groupCountLabel) {
        _groupCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 200, 13)];
        _groupCountLabel.font = [UIFont systemFontOfSize:13];
        _groupCountLabel.textColor = [UIColor blackColor];
        _groupCountLabel.textAlignment = NSTextAlignmentLeft;
        _groupCountLabel.text = [NSString stringWithFormat:@"群聊数量 : %lu ",(unsigned long)[SingleManager shareManager].allGroupsArrs.count];
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
