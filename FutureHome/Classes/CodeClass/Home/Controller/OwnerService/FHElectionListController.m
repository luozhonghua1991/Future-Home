//
//  FHElectionListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  选举列表界面  业主海选界面

#import "FHElectionListController.h"
#import "FHElectionListCell.h"
#import "FHCandidateListModel.h"
#import "FHApplicationElectionIndustryCommitteController.h"

@interface FHElectionListController () <UITableViewDelegate,UITableViewDataSource,FHElectionListCellDelegate>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *candidateListArrs;
/** 选择的投票人id数据 */
@property (nonatomic, strong) NSMutableArray *selectModelArrs;
/** 是否能提交数据 */
@property (nonatomic, assign) BOOL isCanUpdate;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger maxSelectCount;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIButton *selectedBtn;


@end

@implementation FHElectionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCanUpdate = YES;
    if ([self.titleString isEqualToString:@"业主海选"]) {
        self.maxSelectCount = self.candidate_number;
    } else if ([self.titleString isEqualToString:@"岗位选举"]) {
        self.maxSelectCount = self.election_number;
    }
    [self fh_creatNav];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHElectionListCell class] forCellReuseIdentifier:NSStringFromClass([FHElectionListCell class])];
    [self getRequest];
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.homeTable.mj_header;
    MJRefreshFooter *footer = self.homeTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - 5, MainStatusBarHeight + 5, 35, 35);
    [menuBtn setTitle:@"提交" forState:UIControlStateNormal];
    menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [menuBtn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:menuBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark — request
- (void)getRequest {
    self.selectModelArrs = [[NSMutableArray alloc] init];
    self.candidateListArrs = [[NSMutableArray alloc] init];
    /** 选举列表 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *status;
    if ([self.titleString isEqualToString:@"业主海选"]) {
        status = @"1";
    } else if ([self.titleString isEqualToString:@"岗位选举"]) {
        status = @"2";
    }
    self.candidateListArrs = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.owner_id,@"owner_id",
                               self.pid,@"pid",
                               status,@"status", nil];
    [AFNetWorkTool get:@"owner/candidateList" params:paramsDic success:^(id responseObj) {
        [weakSelf endRefreshAction];
        NSDictionary *Dic = responseObj[@"data"];
        NSArray *upDicArr = Dic[@"list"];
        for (NSDictionary *dic in upDicArr) {
            if ([dic[@"select"] integerValue] == 1) {
                weakSelf.isCanUpdate = NO;
            }
        }
        weakSelf.candidateListArrs = [FHCandidateListModel mj_objectArrayWithKeyValuesArray:upDicArr];
        [weakSelf.homeTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.candidateListArrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.0f)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHElectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHElectionListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FHCandidateListModel *model = self.candidateListArrs[indexPath.section];
    cell.candidateListModel = model;
    if ([self.titleString isEqualToString:@"业主海选"]) {
        cell.countLabel.text = [NSString stringWithFormat:@"%ld票",(long)model.sea_num];
    } else if ([self.titleString isEqualToString:@"岗位选举"]) {
        cell.countLabel.text = [NSString stringWithFormat:@"%ld票",(long)model.post_num];
    }
    if (model.isSelect) {
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    } else {
        if (model.select == 0) {
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        } else if (model.select == 1) {
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        }
    }
//    self.selectedBtn =cell.selectBtn;
    
    cell.delegate = self;
    return cell;
}

- (void)fh_FHElectionListCellDelegateSelectModel:(FHCandidateListModel *)model {
    /** 选举人的详情界面 */
    FHApplicationElectionIndustryCommitteController *vc = [[FHApplicationElectionIndustryCommitteController alloc] init];
    vc.titleString = @"选举人资料";
    vc.personModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isCanUpdate) {
        [self.view makeToast:@"每个人只有一次投票机会,请勿重复提交"];
        return;
    }
    FHElectionListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FHCandidateListModel *model = self.candidateListArrs[indexPath.section];
    NSString *modelID = [NSString stringWithFormat:@"%ld",(long)model.id];
    
//    if (model.select == 1) {
//        [self commitRequestWithStrings:modelID];
//    }
    if (model.isSelect == NO) {
        if (self.selectModelArrs.count < self.maxSelectCount) {
            [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
            [self.selectModelArrs addObject:modelID];
            model.isSelect = YES;
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"您最多能选择%ld人进行投票,请勿多选",(long)self.maxSelectCount]];
            return;
        }
    } else {
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self.selectModelArrs removeObject:modelID];
        model.isSelect = NO;
    }
}

- (void)pushBtnClick {
    if (!self.isCanUpdate) {
        [self.view makeToast:@"每个人只有一次投票机会,请勿重复提交"];
        return;
    }
    
    //在此添加你想要完成的功能
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"每人只有一次投票机会,确定是否提交?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            /** 提交选举的人的资料 */
            NSString *selectIDString = [weakSelf.selectModelArrs componentsJoinedByString:@","];
            [weakSelf commitRequestWithStrings:selectIDString];
            
        }
    }];
}

- (void)commitRequestWithStrings:(NSString *)string {
    WS(weakSelf);
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHud];
    NSString *status;
    if ([self.titleString isEqualToString:@"业主海选"]) {
        status = @"1";
    } else if ([self.titleString isEqualToString:@"岗位选举"]) {
        status = @"2";
    }
    
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.owner_id,@"owner_id",
                               self.pid,@"id",
                               status,@"status",
                               string,@"pid",
                               nil];
    
    [AFNetWorkTool post:@"owner/userVote" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:@"参与投票成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        [weakSelf.loadingHud hideAnimated:YES];
        weakSelf.loadingHud = nil;
    }];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStyleGrouped];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRequest)];
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
