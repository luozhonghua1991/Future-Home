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

@interface FHMedicalHistoryController () <UITableViewDelegate,UITableViewDataSource>
/** 所有价格Btn */
@property (nonatomic, strong) UIButton *allPriceBtn;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

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
//    [self.allPriceBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allPriceBtn];
}

- (void)sureBtnClick {
    /** 添加医疗记录 */
    FHAddMedicalHistoryController *vc = [[FHAddMedicalHistoryController alloc] init];
    vc.titleString = @"添加医疗记录";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHAddMedicalHistoryController *vc = [[FHAddMedicalHistoryController alloc] init];
    vc.titleString = @"医疗记录";
    vc.hidesBottomBarWhenPushed = YES;
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
