//
//  FHMedicalHistoryController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  医疗记录

#import "FHMedicalHistoryController.h"
#import "FHMedicalHistoryCell.h"
#import "FHAddMedicalHistoryController.h"
#import "BAAlertController.h"
#import "FHHealthHistoryModel.h"

@interface FHMedicalHistoryController () <UITableViewDelegate,UITableViewDataSource>
/** 所有价格Btn */
@property (nonatomic, strong) UIButton *allPriceBtn;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *medicalHistoryArrs;
/** 总得消费 */
@property (nonatomic, copy) NSString *total_pay;


@end

@implementation FHMedicalHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self creatBottomBtn];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHMedicalHistoryCell class] forCellReuseIdentifier:NSStringFromClass([FHMedicalHistoryCell class])];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fh_getRequest];
}

- (void)fh_getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    self.medicalHistoryArrs = [[NSMutableArray alloc] init];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.ID,@"pid",
//                               @(1),@"page",
                               nil];
    
    [AFNetWorkTool get:@"health/recordList" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *arr = responseObj[@"data"][@"list"];
            NSDictionary *dic = arr[0];
            weakSelf.total_pay = dic[@"total_pay"];
            [weakSelf.allPriceBtn setTitle:[NSString stringWithFormat:@"合计支出:%@元",self.total_pay] forState:UIControlStateNormal];
            weakSelf.medicalHistoryArrs = [FHHealthHistoryModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
            [weakSelf.homeTable reloadData];
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"医疗记录";
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

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH / 2 - 1, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"添加记录" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    self.allPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allPriceBtn.frame = CGRectMake(MaxX(sureBtn) + 1,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH / 2, ZH_SCALE_SCREEN_Height(50));
    self.allPriceBtn.backgroundColor = HEX_COLOR(0x1296db);
    [self.allPriceBtn setTitle:@"合计支出:2666元" forState:UIControlStateNormal];
    [self.allPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.allPriceBtn];
}

- (void)sureBtnClick {
    /** 添加医疗记录 */
    FHAddMedicalHistoryController *vc = [[FHAddMedicalHistoryController alloc] init];
    vc.titleString = @"添加医疗记录";
    vc.pid = self.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.medicalHistoryArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHMedicalHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMedicalHistoryCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FHHealthHistoryModel *model = self.medicalHistoryArrs[indexPath.row];
    cell.model = model;
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}


#pragma mark  实现成为第一响应者方法
- (BOOL)canBecomeFirstResponder {
    return YES;
}



- (void) cellLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.homeTable];
        NSIndexPath * indexPath = [self.homeTable indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        
        //在此添加你想要完成的功能
        WS(weakSelf);
        [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定要删除该条记录吗?" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                /** 确定删除 */
                [weakSelf fh_deleteHealthHistoryInfoWithIndex:indexPath];
            }
        }];
    }
}

- (void)fh_deleteHealthHistoryInfoWithIndex:(NSIndexPath *)index {
    FHHealthHistoryModel *model = self.medicalHistoryArrs[index.row];
    /** 删除医疗记录接口 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.id,@"id",
                               nil];
    [AFNetWorkTool post:@"health/deleteRecord" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [weakSelf fh_getRequest];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHHealthHistoryModel *model = self.medicalHistoryArrs[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHAddMedicalHistoryController *vc = [[FHAddMedicalHistoryController alloc] init];
    vc.titleString = @"医疗记录";
    vc.hidesBottomBarWhenPushed = YES;
    vc.pid = self.ID;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - ZH_SCALE_SCREEN_Height(50)) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}


@end
