//
//  FHGroupMessageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  群聊

#import "FHGroupMessageController.h"
#import "FHFriendMessageController.h"
#import "DXMessageToolBar.h"
#import "TZImagePickerController.h"
@interface FHGroupMessageController () <DXChatBarMoreViewDelegate,DXMessageToolBarDelegate>
{
     NSMutableArray *_imgs;//图片数组
}
/**
 * 聊天的tableView
 */
@property (nonatomic,strong,readwrite) UITableView *tableView;
/**
 *  底部的toolbar
 */
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

/**
 *  message模型数组
 */
@property (nonatomic,strong)NSMutableArray *messageModel;
/**
 *  群成员数组
 */
@property (nonatomic,strong) NSMutableArray *groupMembers;

@end

@implementation FHGroupMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self.view addSubview:self.chatToolBar];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.groupTitle;
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















- (DXMessageToolBar *)chatToolBar {
    if (_chatToolBar == nil) {
        MessageType messageType = MessageTypeChat;
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])MessageType:messageType];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        //单聊
        ChatMoreType type = ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 100) typw:type];
        _chatToolBar.moreView.backgroundColor = RGBACOLOR(240, 242, 247, 1);
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _chatToolBar;
}

@end
