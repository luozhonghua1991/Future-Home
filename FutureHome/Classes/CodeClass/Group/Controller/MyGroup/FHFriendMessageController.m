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
#import "FHPersonDetailController.h"
#import "FHGroupDetailController.h"

@interface FHFriendMessageController () <RCPluginBoardViewDelegate>

{
    NSMutableArray *_imgs;//图片数组
    BOOL isNotice;
}
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *codeImgView;

/** 自定义导航栏视图 */
@property (nonatomic, strong) UIView *navgationView;
/** <#strong属性注释#> */
@property (nonatomic, strong) UILabel *titleLabel;

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
    self.conversationMessageCollectionView.backgroundColor = [UIColor whiteColor];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
}

////隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    if (!self.navgationView) {
        self.navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainSizeHeight)];
        self.navgationView.backgroundColor = HEX_COLOR(0x1296db);
        self.navgationView.userInteractionEnabled = YES;
        [self.view addSubview:self.navgationView];
        self.navgationView.userInteractionEnabled = YES;
    }
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    self.titleLabel.text = self.titleString;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:self.titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
    
    self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, MainStatusBarHeight + 5, 25, 25)];
    if (self.conversationType == ConversationType_PRIVATE) {
        /** 单聊 */
        self.codeImgView.image = [UIImage imageNamed:@"geren"];
    } else if (self.conversationType == ConversationType_GROUP) {
        /** 群聊 */
        self.codeImgView.image = [UIImage imageNamed:@"qun"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.codeImgView.userInteractionEnabled = YES;
    [self.codeImgView addGestureRecognizer:tap];
    [self.navgationView addSubview:self.codeImgView];
}

- (void)backBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tapClick {
    /** 用户详情 */
    if (self.conversationType == ConversationType_GROUP) {
        FHGroupDetailController *vc = [[FHGroupDetailController alloc] init];
        vc.groupID = self.targetId;
        vc.groupName = self.titleLabel.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        FHPersonDetailController *vc = [[FHPersonDetailController alloc] init];
        vc.targetId = self.targetId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
