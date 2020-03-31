//
//  FHGroupDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  群组详情

#import "FHGroupDetailController.h"
#import "TopViewController.h"
#import "GroupInfoCell.h"
#import "FHSelectGroupMemberController.h"

@interface FHGroupDetailController () <UITableViewDataSource,UITableViewDelegate,TopViewControllerDelagate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDActionSheetDelegate,UITextFieldDelegate>
{
    UITableView *_showTable;
    TopViewController *_topview;
    UIButton *_sendBtn;
    NSMutableArray *_groupAll;
    NSMutableArray *_arrPer;
    BOOL isDel;
}

/** 是否是群主 */
@property (nonatomic, assign) BOOL isGroupOwner;
/** 头像 */
@property (nonatomic, strong) NSString *groupImageURL;
/** 群头像 */
@property (nonatomic, strong) UIImageView *groupImgView;
/** <#strong属性注释#> */
@property (nonatomic, strong) UITextField *groupNameTF;

@end

@implementation FHGroupDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self initMyView];
    [self initCreateData];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"群组信息";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark — setUI
-(void)initMyView {
    _showTable=[[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight)];
    _showTable.delegate = self;
    _showTable.dataSource = self;
    _showTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _showTable.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    [self.view addSubview:_showTable];
    
    _topview = [[TopViewController alloc] initWithNibName:@"TopViewController" bundle:nil];
    _topview.delagate = self;
    _topview.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    _topview.isGroupM = YES;
    _showTable.tableHeaderView=_topview.view;
    
    UIView *txtfootview=[[UIView alloc]init];
    txtfootview.frame=CGRectMake(0, 0, SCREEN_WIDTH,100);
    txtfootview.backgroundColor=[UIColor clearColor];
    UIButton *btnRegis= [[UIButton alloc]initWithFrame:CGRectMake(10, 40,SCREEN_WIDTH-20, 44)];
    UIImage *buttonImageRegis=[UIImage imageNamed:@"deletebtn"];
    UIImage *stretchableRegister=[buttonImageRegis stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [btnRegis.layer setMasksToBounds:YES];
    [btnRegis.layer setCornerRadius:3];
    [btnRegis setBackgroundImage:stretchableRegister forState:UIControlStateNormal];
    btnRegis.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:19.0];
    [btnRegis setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [btnRegis setTitle:@"删除并退出" forState:0];
    [btnRegis setTitleColor:[UIColor whiteColor] forState:0];
    _sendBtn = btnRegis;
    [txtfootview addSubview:_sendBtn];
    [_sendBtn addTarget:self action:@selector(exitGroupClick) forControlEvents:UIControlEventTouchUpInside];
    _showTable.tableFooterView=txtfootview;
}

-(void)initCreateData {
    _groupAll=[NSMutableArray new];
    _arrPer=[NSMutableArray new];
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.groupID,@"groupId",
                               nil];
    [AFNetWorkTool get:@"sheyun/getGroupInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 是否是群主 */
            weakSelf.isGroupOwner  = [responseObj[@"data"][@"groupOwner"] boolValue];
            if (weakSelf.isGroupOwner) {
                [self->_sendBtn setTitle:@"解散群" forState:UIControlStateNormal];
            } else {
                [self->_sendBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
            }
            weakSelf.groupImageURL = responseObj[@"data"][@"groupPortrait"];
            NSString *groupCount = [NSString stringWithFormat:@"全部群成员(%@)",responseObj[@"data"][@"count"]];
            NSArray *arr1=@[groupCount];
            NSArray *arr2=@[@"群头像"];
            NSArray *arr3=@[@"群名称"];
            NSArray *arr4=@[@"清空聊天记录"];
            [self->_groupAll addObject:arr1];
            [self->_groupAll addObject:arr2];
            [self->_groupAll addObject:arr3];
            [self->_groupAll addObject:arr4];
            
            NSArray *arr = responseObj[@"data"][@"list"];
            for (NSDictionary *dic in arr) {
                PersonModel *pm = [[PersonModel alloc] init];
                pm.friendId = dic[@"username"];
                pm.userName = dic[@"nickname"];
                pm.txicon = dic[@"avatar"];
                [self->_topview addOneTximg:pm];
                [self->_arrPer addObject:pm];
            }
            [self setTopViewFrame:self->_arrPer];
            [self->_showTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}


// 设置topview的高度变化
-(void)setTopViewFrame:(NSArray*)allP
{
    int lie=0;
    if([UIScreen mainScreen].bounds.size.width>320)
    {
        lie=5;
    }else
    {
        lie=4;
    }
    int Allcount;
    Allcount = allP.count+2;
//    if (self.isGroupOwner) {
//
//    } else {
//        Allcount = allP.count+1;
//    }
    int line=Allcount/lie;
    if(Allcount%lie>0)
        line++;
    _topview.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, line*90);
    _showTable.tableHeaderView=_topview.view;
}

#pragma  mark topview delagate 邀请加群;
-(void)addBtnClick {
    FHSelectGroupMemberController *group = [[FHSelectGroupMemberController alloc] init];
    group.groupMemberType = GroupMemberType_addMember;
    group.hidesBottomBarWhenPushed = YES;
    group.groupId = self.groupID;
    group.groupName = self.groupName;
    [self.navigationController pushViewController:group animated:YES];
}

#pragma  mark delagate 点击删除好友的状态
-(void)subBtnClick {
    if (self.isGroupOwner) {
        FHSelectGroupMemberController *group = [[FHSelectGroupMemberController alloc] init];
        group.groupMemberType = GroupMemberType_subMember;
        group.hidesBottomBarWhenPushed = YES;
        group.groupId = self.groupID;
        group.groupName = self.groupName;
        [self.navigationController pushViewController:group animated:YES];
    } else {
        [self.view makeToast:@"你不是群主不能做此操作。。。"];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupAll[section]count] ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupAll.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1.5;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *idfCell=@"grouptopcell";
    GroupInfoCell *topcell=(GroupInfoCell*)[tableView dequeueReusableCellWithIdentifier:idfCell];
    if(topcell==nil)
    {
        topcell=[[[NSBundle mainBundle]loadNibNamed:@"GroupInfoCell" owner:self options:nil] lastObject];
    }
    topcell.titleShow.text=_groupAll[indexPath.section][indexPath.row];
    topcell.nameShow.text = @"";
    if (indexPath.section == 2) {
        if (!self.groupNameTF) {
            self.groupNameTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 220, 4.5, 200, 35)];
            self.groupNameTF.text = self.groupName;
            self.groupNameTF.font = [UIFont systemFontOfSize:14];
            self.groupNameTF.delegate = self;
            self.groupNameTF.returnKeyType = UIReturnKeyDone;
            [topcell.contentView addSubview:self.groupNameTF];
        }
    }
    if (indexPath.section == 1) {
        self.groupImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [self.groupImgView sd_setImageWithURL:[NSURL URLWithString:self.groupImageURL]];
        topcell.accessoryView = self.groupImgView;
    }
    return topcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        /** 全体群成员 */
        FHSelectGroupMemberController *group = [[FHSelectGroupMemberController alloc] init];
        group.groupMemberType = GroupMemberType_allMemberList;
        group.hidesBottomBarWhenPushed = YES;
        group.groupId = self.groupID;
        group.groupName = self.groupName;
        [self.navigationController pushViewController:group animated:YES];
    }
    if (indexPath.section == 1) {
        /** 修改图片 */
        if (self.isGroupOwner) {
            [self addImagBtnClick];
        } else {
            [self.view makeToast:@"你不是群主不能做此操作。。。"];
        }
    }
    if (indexPath.section == 2) {
        /** 修改群名字 */
        if (self.isGroupOwner) {
            [self.groupNameTF becomeFirstResponder];
        } else {
            [self.view makeToast:@"你不是群主不能做此操作。。。"];
        }
    }
    if (indexPath.section == 3) {
        /** 清空会话 */
        WS(weakSelf);
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定清空聊天记录吗" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 删除聊天记录 */
                [[RCIMClient sharedRCIMClient] clearHistoryMessages:ConversationType_GROUP targetId:weakSelf.groupID recordTime:0 clearRemote:NO success:^{
                    [self.view makeToast:@"清空聊天记录成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    });
                } error:^(RCErrorCode status) {
                    [self.view makeToast:@"删除聊天记录失败"];
                }];
            }
        }];
    }
}

#pragma mark — 删除并退出群
- (void)exitGroupClick {
    WS(weakSelf);
    if (self.isGroupOwner) {
        /** 解散群 */
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定解散该群吗" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //** 解散群的操作 */
                WS(weakSelf);
                Account *account = [AccountStorage readAccount];
                NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @(account.user_id),@"user_id",
                                           account.username,@"number_str",
                                           weakSelf.groupID,@"groupId",
                                           nil];
                [AFNetWorkTool post:@"sheyun/groupDismiss" params:paramsDic success:^(id responseObj) {
                    if ([responseObj[@"code"] integerValue] == 1) {
                        [weakSelf.view makeToast:@"解散群成功"];
                        /** 删除聊天记录 */
                        BOOL isClear =  [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:weakSelf.groupID];
                        [self deleteGroupID];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (isClear) {
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            }
                        });
                    } else {
                        [weakSelf.view makeToast:responseObj[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    } else {
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定删除并退出群吗" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //** 退出群的操作并且删除聊天信息 */
                WS(weakSelf);
                Account *account = [AccountStorage readAccount];
                NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @(account.user_id),@"user_id",
                                           account.username,@"number_str",
                                           weakSelf.groupID,@"groupId",
                                           nil];
                
                [AFNetWorkTool post:@"sheyun/groupQuit" params:paramsDic success:^(id responseObj) {
                    if ([responseObj[@"code"] integerValue] == 1) {
                        [weakSelf.view makeToast:@"删除并退出群成功"];
//                        /** 删除聊天记录 */
                        BOOL isClear =  [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:weakSelf.groupID];
                        [self deleteGroupID];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (isClear) {
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            }
                        });
                    } else {
                        [weakSelf.view makeToast:responseObj[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }
}

- (void)deleteGroupID {
    if ([[SingleManager shareManager].allGroupsArrs containsObject:self.groupID]) {
        [[SingleManager shareManager].allGroupsArrs removeObject:self.groupID];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEGROUPCOUNT" object:nil];
    }
}

#pragma mark  -- 点击添加群头像
- (void)addImagBtnClick{
    /** 选取图片 */
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}

#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:
        {
            [self addCamera];
            break;
        }
        case 1:
        {
            [self addPhotoClick];
            break;
        }
        case 2:
        {
            ZHLog(@"取消");
            break;
        }
        default:
            
            break;
    }
}

//调用系统相机
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * cameraPicker = [[UIImagePickerController alloc]init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = NO;  //是否可编辑
        //摄像头
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

/**
 *  跳转相册页面
 */
- (void)addPhotoClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.naviBgColor = HEX_COLOR(0x1296db);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            self.groupImgView.image = image;
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - <相册处理区域>
/**
 *  拍摄完成后要执行的方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.groupImgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self updateGroupHeaderImageView];
}

- (void)updateGroupHeaderImageView {
    /** 修改群头像 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.groupID,@"groupId",
                               self.groupImgView.image,@"avatar",
                               nil];
    NSData *imageData = UIImageJPEGRepresentation(self.groupImgView.image,0.5);
    [AFNetWorkTool updateHeaderImageWithUrl:@"sheyun/updateGroupPortrait" parameter:paramsDic imageData:imageData success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"修改群头像成功"];
            RCGroup *groupInfo = [[RCGroup alloc] init];
            groupInfo.groupId = self.groupID;
            groupInfo.groupName = responseObj[@"data"][@"groupName"];
            groupInfo.portraitUri = responseObj[@"data"][@"groupPortrait"];
            [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:weakSelf.groupID];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
        }
    } failure:^(NSError *error) {
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.groupNameTF  resignFirstResponder];
        /** 修改群名字 */
        if (self.isGroupOwner) {
            [self updateGroupName];
        } else {
            self.groupNameTF.text = self.groupName;
            [self.view makeToast:@"你不是群主不能做此操作。。。"];
        }
        return NO;
    }
    return YES;
    
}

- (void)updateGroupName {
    //** 更新群名字 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.groupNameTF.text,@"groupName",
                               weakSelf.groupID,@"groupId",
                               nil];
    [AFNetWorkTool post:@"sheyun/refreshGroup" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"修改群名字成功"];
            RCGroup *groupInfo = [[RCGroup alloc] init];
            groupInfo.groupId = weakSelf.groupID;
            groupInfo.groupName = responseObj[@"data"][@"groupName"];
            groupInfo.portraitUri = responseObj[@"data"][@"groupPortrait"];
            [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:weakSelf.groupID];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
