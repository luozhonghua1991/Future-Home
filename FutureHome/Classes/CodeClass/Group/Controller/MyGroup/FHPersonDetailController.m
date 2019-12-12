//
//  FHPersonDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHPersonDetailController.h"

@interface FHPersonDetailController() <UITableViewDelegate,UITableViewDataSource>
/** <#strong属性注释#> */
@property (nonatomic, strong) UITableView *table;

@end

@implementation FHPersonDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self.view addSubview:self.table];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"用户详情";
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

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//返回每个区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"加入黑名单";
    } else {
        cell.textLabel.text = @"清除聊天数据";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        WS(weakSelf);
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"加入黑名单后,你将不再收到对方的消息,同时删除与该联系人的聊天记录" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 加入黑名单的操作 */
                WS(weakSelf);
                Account *account = [AccountStorage readAccount];
                NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @(account.user_id),@"user_id",
                                           weakSelf.targetId,@"number_str",
                                           account.username,@"userId",
                                           nil];
                [AFNetWorkTool post:@"sheyun/userBlacklistAdd" params:paramsDic success:^(id responseObj) {
                    if ([responseObj[@"code"] integerValue] == 1) {
                        [weakSelf.view makeToast:@"添加黑名单成功"];
                        /** 删除聊天记录 */
                        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:weakSelf.targetId];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [weakSelf.view makeToast:responseObj[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    } else {
        WS(weakSelf);
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定删除聊天记录吗" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 删除聊天记录 */
//                [[RCIMClient sharedRCIMClient] deleteMessages:@[weakSelf.targetId]];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:weakSelf.targetId];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}



#pragma mark — setter && getter
//懒加载
- (UITableView *)table{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.showsVerticalScrollIndicator = NO;
        _table.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        _table.tableFooterView = view;
        _table.tableHeaderView = view;
    }
    return _table;
}

@end
