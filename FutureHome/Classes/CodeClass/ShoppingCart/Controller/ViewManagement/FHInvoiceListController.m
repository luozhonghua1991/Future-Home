//
//  FHInvoiceListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  发票列表

#import "FHInvoiceListController.h"
#import "FHInvoiceListCell.h"
#import "FHAddOrEditInvoiceController.h"
#import "FHInvoiceModel.h"

@interface FHInvoiceListController () <UITableViewDelegate,UITableViewDataSource,FHInvoiceListCellDelegate>
{
    NSInteger curPage;
    NSInteger tolPage;
}
/**发票列表table*/
@property (nonatomic,strong) UITableView *invoiceListTableView;
/** 数据列表 */
@property (nonatomic, strong) NSMutableArray *dataListArrs;

@end

@implementation FHInvoiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isHaveNavBar) {
        [self fh_creatNav];
    }
    self.dataListArrs = [[NSMutableArray alloc] init];
    [self.invoiceListTableView registerClass:[FHInvoiceListCell class] forCellReuseIdentifier:NSStringFromClass([FHInvoiceListCell class])];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.invoiceListTableView];
    [self creatBottomBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadInit];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"发票信息";
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
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- MJrefresh
- (void)headerReload {
    curPage = 1;
    tolPage = 1;
    [self.invoiceListTableView.mj_footer resetNoMoreData];
    
    [self getRequestLoadHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self getRequestLoadHead:NO];
    } else {
        [self.invoiceListTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.invoiceListTableView.mj_header;
    MJRefreshFooter *footer = self.invoiceListTableView.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

- (void)getRequestLoadHead:(BOOL)isHead {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               [SingleManager shareManager].ordertype,@"ordertype",nil];
    
    [AFNetWorkTool get:@"shop/getUserinvoices" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (isHead) {
                [weakSelf.dataListArrs removeAllObjects];
            }
            [weakSelf endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            [weakSelf.dataListArrs addObjectsFromArray:[FHInvoiceModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]]];
            [weakSelf.invoiceListTableView reloadData];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self endRefreshAction];
    }];
}

- (void)creatBottomBtn {
    UIButton *addInvoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isHaveNavBar) {
        addInvoiceBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    } else {
        addInvoiceBtn.frame = CGRectMake(0,SCREEN_HEIGHT - MainSizeHeight - 70 - ZH_SCALE_SCREEN_Height(50) - [self getTabbarHeight], SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    }
    addInvoiceBtn.backgroundColor = HEX_COLOR(0x1296db);
    [addInvoiceBtn setTitle:@"新增发票" forState:UIControlStateNormal];
    [addInvoiceBtn setImage:nil forState:UIControlStateNormal];
    [addInvoiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addInvoiceBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addInvoiceBtn];
}


#pragma mark — event
- (void)addInvoiceBtnClick {
    /** 添加发票界面 */
    [self pushVCWithTitle:@"添加发票" companyName:@"" companyCode:@"" companyAddress:@"" companyPhone:@"" companyBank:@"" companyAccount:@"" companyID:@"0"];
}

- (void)pushVCWithTitle:(NSString *)titleName
            companyName:(NSString *)companyName
            companyCode:(NSString *)companyCode
         companyAddress:(NSString *)companyAddress
           companyPhone:(NSString *)companyPhone
            companyBank:(NSString *)companyBank
         companyAccount:(NSString *)companyAccount
              companyID:(NSString *)companyID{
    FHAddOrEditInvoiceController *addAddressController = [[FHAddOrEditInvoiceController alloc]init];
    addAddressController.hidesBottomBarWhenPushed = YES;
    addAddressController.titleName = titleName;
    addAddressController.companyName = companyName;
    addAddressController.companyCode = companyCode;
    addAddressController.companyAddress = companyAddress;
    addAddressController.companyPhone = companyPhone;
    addAddressController.companyBank = companyBank;
    addAddressController.companyAccount = companyAccount;
    addAddressController.companyID = companyID;
    [self.navigationController pushViewController:addAddressController animated:YES];
}


#pragma mark - TableDelegate
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataListArrs.count;
}

//返回每个区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//每行cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHInvoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHInvoiceListCell class])];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IS_NULL_ARRAY(self.dataListArrs)) {
        cell.invoiceModel = self.dataListArrs[indexPath.section];
    }
    return cell;
}

//返回每行的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

//每行的点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isHaveNavBar) {
        FHInvoiceModel *invoiceModel = self.dataListArrs[indexPath.section];
        if (self.selectResultBlock) {
            self.selectResultBlock(invoiceModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


/** 编辑发票 */
- (void)fh_invoiceListCellSelectModel:(FHInvoiceModel*)model {
    [self pushVCWithTitle:@"编辑发票" companyName:model.companyname companyCode:model.taxpayercode companyAddress:model.companyaddress companyPhone:model.companytel companyBank:model.openbank companyAccount:model.accountinfo companyID:model.id];
}

- (void)fh_deleteInvoiceListCellSelectModel:(FHInvoiceModel *)model {
    WS(weakSelf);
    NSArray *buttonTitleColorArray = @[[UIColor blackColor], [UIColor blueColor]];
    [UIAlertController ba_alertShowInViewController:self
                                              title:@"提示"
                                            message:@"确定删除该发票吗？"
                                   buttonTitleArray:@[@"取 消", @"确 定"]
                              buttonTitleColorArray:buttonTitleColorArray
                                              block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                  if (buttonIndex == 1) {
                                                      [weakSelf deleteInvoiceRequestWithModel:model];
                                                  }
                                                  
                                              }];
}

- (void)deleteInvoiceRequestWithModel:(FHInvoiceModel *)model {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               model.id,@"id",
                               [SingleManager shareManager].ordertype,@"ordertype",nil];
    [AFNetWorkTool post:@"shop/removeUserInvoice" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [self.view makeToast:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadInit];
            });
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"暂无相关数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:167/255.0 green:181/255.0 blue:194/255.0 alpha:1/1.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


#pragma mark — setter && getter
//懒加载
- (UITableView *)invoiceListTableView {
    if (_invoiceListTableView == nil) {
        CGRect tableViewFrame;
        if (self.isHaveNavBar) {
            tableViewFrame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight);
        } else {
            tableViewFrame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - MainSizeHeight - [self getTabbarHeight] - ZH_SCALE_SCREEN_Height(50) - 70);
        }
        _invoiceListTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _invoiceListTableView.dataSource = self;
        _invoiceListTableView.delegate = self;
        _invoiceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _invoiceListTableView.showsVerticalScrollIndicator = NO;
        _invoiceListTableView.backgroundColor =  ZH_COLOR(241, 241, 241);
        _invoiceListTableView.emptyDataSetSource = self;
        _invoiceListTableView.emptyDataSetDelegate = self;
        _invoiceListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
        _invoiceListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
        if (@available (iOS 11.0, *)) {
            _invoiceListTableView.estimatedSectionHeaderHeight = 0.01;
            _invoiceListTableView.estimatedSectionFooterHeight = 0.01;
            _invoiceListTableView.estimatedRowHeight = 0.01;
        }
    }
    return _invoiceListTableView;
}

@end
