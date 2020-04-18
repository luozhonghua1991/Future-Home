//
//  HYJFAddressAdministrationController.m
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/22.
//  Copyright © 2017年 HYJF. All rights reserved.
//  地址管理列表

#import "HYJFAddressAdministrationController.h"
#import "HYJFAllAddressModel.h"
#import "HYJFAddressAdministrationCell.h"
#import "HYJFAddOrEditAddressController.h"
#import "CreatNavViewController.h"

@interface HYJFAddressAdministrationController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *allAddressArray;
    /**判断是否有地址数据 如果没有添加地址的时候就要给个默认值*/
    BOOL isNoAddress;
    NSInteger curPage;
    NSInteger tolPage;
}
/**AddressModel*/
@property (nonatomic,strong) HYJFAllAddressModel *addressModel;
/**用户中心页面table*/
@property (nonatomic,strong) UITableView *AddressListTableView;

@end

@implementation HYJFAddressAdministrationController

//懒加载
- (UITableView *)AddressListTableView{
    if (_AddressListTableView == nil) {
        CGRect tableViewFrame;
        if (self.isHaveNavBar) {
            tableViewFrame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight);
        } else {
            tableViewFrame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_HEIGHT - MainSizeHeight - [self getTabbarHeight] - ZH_SCALE_SCREEN_Height(50) - 70);
        }
        _AddressListTableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _AddressListTableView.dataSource = self;
        _AddressListTableView.delegate = self;
        _AddressListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _AddressListTableView.showsVerticalScrollIndicator = NO;
        _AddressListTableView.backgroundColor =  ZH_COLOR(241, 241, 241);
        _AddressListTableView.emptyDataSetSource = self;
        _AddressListTableView.emptyDataSetDelegate = self;
        _AddressListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInit)];
        _AddressListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
        if (@available (iOS 11.0, *)) {
            _AddressListTableView.estimatedSectionHeaderHeight = 0.01;
            _AddressListTableView.estimatedSectionFooterHeight = 0.01;
            _AddressListTableView.estimatedRowHeight = 0.01;
        }

    }
    return _AddressListTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isHaveNavBar) {
        [self fh_creatNav];
    }
    allAddressArray = [[NSMutableArray alloc]init];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.AddressListTableView];
    [self creatBottomBtn];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //刷新数据
    [self loadInit];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"地址信息";
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
    [_AddressListTableView.mj_footer resetNoMoreData];
    
    [self refreshDataWithHead:YES];
}

- (void)footerReload {
    if (++curPage <= tolPage) {
        [self refreshDataWithHead:NO];
    } else {
        [_AddressListTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = _AddressListTableView.mj_header;
    MJRefreshFooter *footer = _AddressListTableView.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}


#pragma mark  -- 获取所有地址数据
- (void)refreshDataWithHead:(BOOL)isHead {
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    //get请求 获取所有地址信息
    __weak typeof(self)weakSelf = self;
    [AFNetWorkTool get:@"shop/getUserAddress" params:paramsDic success:^(id responseObj) {
        ZHLog(@"获取所有地址信息%@",responseObj);
        int code = [[responseObj objectForKey:@"code"] intValue];
        if (code == 1) {
            if (isHead) {
                [self->allAddressArray removeAllObjects];
            }
            [self endRefreshAction];
            self->tolPage = [responseObj[@"data"][@"last_page"] integerValue];
            //请求数据成功
            NSDictionary *dataDic =[responseObj objectForKey:@"data"];
            //addressModel
            [self->allAddressArray addObjectsFromArray: [HYJFAllAddressModel mj_objectArrayWithKeyValuesArray:dataDic[@"list"]]];
            [self.AddressListTableView reloadData];
        } else {
            [ZHProgressHUD showMessage:[responseObj objectForKey:@"msg"] inView:weakSelf.view];
        }
        
    } failure:^(NSError * error) {
        
    }];
}

- (void)creatBottomBtn{
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isHaveNavBar) {
        addAddressBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    } else {
        addAddressBtn.frame = CGRectMake(0,SCREEN_HEIGHT - MainSizeHeight - 70 - ZH_SCALE_SCREEN_Height(50) - [self getTabbarHeight], SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    }
    addAddressBtn.backgroundColor = HEX_COLOR(0x1296db);
    [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    [addAddressBtn setImage:nil forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressBtn];
}

#pragma mark  -- 新增地址
- (void)addAddressBtnClick {
    HYJFAddOrEditAddressController *addAddressController = [[HYJFAddOrEditAddressController alloc]init];
    addAddressController.hidesBottomBarWhenPushed = YES;
    addAddressController.titleName = @"添加地址";
    addAddressController.strName = @"";
    addAddressController.strPhoneNum = @"";
    addAddressController.strAddress = @"";
    addAddressController.strDetialAddress = @"";
    [self.navigationController pushViewController:addAddressController animated:YES];
}

#pragma mark - TableDelegate
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (allAddressArray.count == 0) {
        return 0;
    }
    return allAddressArray.count;
}
//返回每个区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//每行cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    HYJFAddressAdministrationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[HYJFAddressAdministrationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.controller = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IS_NULL_ARRAY(allAddressArray)) {
        self.addressModel = allAddressArray[indexPath.section];
        cell.addressModel = self.addressModel;
    }
    return cell;
}
//返回每行的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

//每行的点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isHaveNavBar) {
        HYJFAllAddressModel *addressModel = allAddressArray[indexPath.section];
        if (self.selectResultBlock) {
            self.selectResultBlock(addressModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**  编辑地址 */
- (void)editAddress:(HYJFAllAddressModel *)address {
    HYJFAddOrEditAddressController *addAddressController = [[HYJFAddOrEditAddressController alloc]init];
    addAddressController.hidesBottomBarWhenPushed = YES;
    addAddressController.titleName = @"编辑地址";
    addAddressController.strName = address.name;
    addAddressController.strPhoneNum = address.mobile;
    addAddressController.strAddress = [NSString stringWithFormat:@"%@%@%@",address.provincename,address.cityname,address.areaname];
    addAddressController.strDetialAddress = address.address;
    addAddressController.addressID = address.id;
    addAddressController.province = address.province_id;
    addAddressController.city = address.city_id;
    addAddressController.district = address.area_id;
    [self.navigationController pushViewController:addAddressController animated:YES];
}

/** 删除地址 */
- (void)deleteAddress:(HYJFAllAddressModel *)addressModel {
    WS(weakSelf);
    NSArray *buttonTitleColorArray = @[[UIColor blackColor], [UIColor blueColor]];
    [UIAlertController ba_alertShowInViewController:self
                                              title:@"提示"
                                            message:@"确定删除该地址吗？"
                                   buttonTitleArray:@[@"取 消", @"确 定"]
                              buttonTitleColorArray:buttonTitleColorArray
                                              block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                  if (buttonIndex == 1) {
                                                      [weakSelf deleteAddressRequestWithModel:addressModel];
                                                  }
                                                  
                                              }];
}

- (void)deleteAddressRequestWithModel:(HYJFAllAddressModel *)addressModel {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(addressModel.id),@"id",
                               [SingleManager shareManager].ordertype,@"ordertype",nil];
    [AFNetWorkTool post:@"shop/removeaddress" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"删除地址成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadInit];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
