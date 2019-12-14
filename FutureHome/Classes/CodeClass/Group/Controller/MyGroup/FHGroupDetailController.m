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

@interface FHGroupDetailController () <UITableViewDataSource,UITableViewDelegate,TopViewControllerDelagate>
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
    [btnRegis setTitle:@"删除并退出" forState:0];
    [btnRegis setTitleColor:[UIColor whiteColor] forState:0];
    _sendBtn=btnRegis;
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
            self.groupImageURL = responseObj[@"data"][@"groupPortrait"];
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
    int Allcount=allP.count+2;
    int line=Allcount/lie;
    if(Allcount%lie>0)
        line++;
    _topview.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, line*90);
    _showTable.tableHeaderView=_topview.view;
}

//#pragma  mark topview delagate 邀请加群;
//-(void)addBtnClick
//{
//    NSLog(@"add btn click!");
//    PersonModel *pmqq=[[PersonModel alloc]init];
//    int rx = arc4random() % 100;
//    NSString *randomfid=[NSString stringWithFormat:@"%d",rx];
//    pmqq.friendId=randomfid;
//    pmqq.userName=@"默认";
//    pmqq.txicon=[UIImage imageNamed:@"qq"];
//    [_topview addOneTximg:pmqq];
//    [_arrPer addObject:pmqq];
//    [self setTopViewFrame:_arrPer];
//    //添加的时候取消删除模式
//    if(isDel==YES)
//        [self subBtnClick];
//}

//#pragma  mark delagate 点击进入编辑模式
//-(void)subBtnClick
//{
//
//    if(isDel==NO)
//    {
//        [_topview isInputDelMoudle:YES];
//        isDel=YES;
//    }else
//    {
//        [_topview isInputDelMoudle:NO];
//        isDel=NO;
//    }
//}


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
    
    return 6;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor clearColor];
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
        topcell.nameShow.text = self.groupName;
    }
    if (indexPath.section == 1) {
        self.groupImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [self.groupImgView sd_setImageWithURL:[NSURL URLWithString:self.groupImageURL]];
        topcell.accessoryView = self.groupImgView;
    }
    
//    if(indexPath.section==0&&indexPath.row==0)//名字标签的显示
//    {
//        topcell.nameShow.hidden=NO;
//    }else
//    {
//        topcell.nameShow.hidden=YES;
//    }
//    if(indexPath.section==0||indexPath.section==2)//此行要显示点击
//    {
//        topcell.clickimg.hidden=NO;
//    }else
//    {
//        topcell.clickimg.hidden=YES;
//    }
//    if(indexPath.section==1||indexPath.section==2)//要显示开关按钮
//    {
//        topcell.switchClickimg.hidden=NO;
//    }
//    else{
//        topcell.switchClickimg.hidden=YES;
//    }
//
//    //以上控制显示和不显示的控件
//
//    if(indexPath.section==0&&indexPath.row==0)
//    {
//        topcell.nameShow.text=@"ios交流群";
//    }
//
    
    return topcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        /** 修改图片 */
        
    }
    if (indexPath.section == 2) {
        /** 修改群名字 */
        
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
    
}

@end
