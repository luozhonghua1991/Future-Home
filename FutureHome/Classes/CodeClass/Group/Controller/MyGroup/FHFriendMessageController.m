//
//  FHFriendMessageController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHFriendMessageController.h"
#import "DXMessageToolBar.h"
#import "TZImagePickerController.h"

@interface FHFriendMessageController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DXChatBarMoreViewDelegate,DXMessageToolBarDelegate,TZImagePickerControllerDelegate,UITextViewDelegate>

{
    NSMutableArray *_imgs;//图片数组
    BOOL isNotice;
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
 *  电话按钮
 */
@property (nonatomic,strong)UIButton *phoneButton;
/**
 *  message
 */
@property(nonatomic,copy) NSString   *messageText;

@end

@implementation FHFriendMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
//    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatToolBar];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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


#pragma mark — event
// 点击背景隐藏
- (void)keyBoardHidden {
    [self.chatToolBar endEditing:YES];
}

- (void)applicationDidEnterBackground {
    [_chatToolBar cancelTouchRecord];
}

- (void)aClockButtonClick {
    
}

#pragma mark — setter && getter
//- (UITableView *)tableView{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, self.view.frame.size.width, self.view.frame.size.height - MainSizeHeight -self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
//        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//
//    return _tableView;
//}

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
