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
        _AddressListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - [self getTabbarHeight] - ZH_SCALE_SCREEN_Height(50) - 70) style:UITableViewStyleGrouped];
        _AddressListTableView.dataSource = self;
        _AddressListTableView.delegate = self;
        _AddressListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _AddressListTableView.showsVerticalScrollIndicator = NO;
        _AddressListTableView.backgroundColor =  ZH_COLOR(241, 241, 241);
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.AddressListTableView];
    [self creatBottomBtn];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //刷新数据
//    [self refreshData];

}

#pragma mark  -- 获取所有地址数据
- (void)refreshData{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"1",@"pageNum",
                                                              @"11",@"pageSize", nil];
    //get请求 获取所有地址信息
    __weak typeof(self)weakSelf = self;
    [AFNetWorkTool get:@"Address/list" params:paramsDic success:^(id responseObj) {
        ZHLog(@"获取所有地址信息%@",responseObj);
        allAddressArray = [[NSMutableArray alloc]init];
        int code = [[responseObj objectForKey:@"code"] intValue];
        if (code == 0) {
            //请求数据成功
            NSDictionary *dataDic =[responseObj objectForKey:@"data"];
            //addressModel
            self->allAddressArray = [HYJFAllAddressModel mj_objectArrayWithKeyValuesArray:dataDic[@"pageList"]];
            isNoAddress = !allAddressArray.count;
        } else if(code == 3303){
            [ZHProgressHUD showMessage:[responseObj objectForKey:@"msg"] inView:weakSelf.view];
        }
        [self.AddressListTableView reloadData];
    } failure:^(NSError * error) {
        
    }];
}

- (void)creatBottomBtn{
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.frame = CGRectMake(0,SCREEN_HEIGHT - MainSizeHeight - 70 - ZH_SCALE_SCREEN_Height(50) - [self getTabbarHeight], SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    addAddressBtn.backgroundColor = HEX_COLOR(0x1296db);
    [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    [addAddressBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressBtn];
}

#pragma mark  -- 新增地址
- (void)addAddressBtnClick{
    HYJFAddOrEditAddressController *addAddressController = [[HYJFAddOrEditAddressController alloc]init];
    addAddressController.hidesBottomBarWhenPushed = YES;
    addAddressController.titleName = @"添加地址";
    addAddressController.strName = @"";
    addAddressController.strPhoneNum = @"";
    addAddressController.strAddress = @"";
    addAddressController.strDetialAddress = @"";
    addAddressController.isNoAddress = isNoAddress;
    [self.navigationController pushViewController:addAddressController animated:YES];
}

#pragma mark - TableDelegate
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (allAddressArray.count == 0) {
//        return 0;
//    }
//    return allAddressArray.count;
    return 10;
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
//    if (!IS_NULL_ARRAY(allAddressArray)) {
//        self.addressModel = allAddressArray[indexPath.section];
        cell.addressModel = self.addressModel;
//    }
    return cell;
}
//返回每行的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (allAddressArray.count  == 0) {
//        return 0;
//    }
//    return self.addressModel.rowHight;
    return 120;
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
}

- (void)changeDefaultAddress{
    [self refreshData];
}

- (void)editAddress:(HYJFAllAddressModel *)address{
    HYJFAddOrEditAddressController *addAddressController = [[HYJFAddOrEditAddressController alloc]init];
    addAddressController.hidesBottomBarWhenPushed = YES;
    addAddressController.titleName = @"编辑地址";
    addAddressController.strName = address.name;
    addAddressController.strPhoneNum = address.phone;
    addAddressController.strAddress = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.district];
    addAddressController.strDetialAddress = address.address;
    addAddressController.isNoAddress = address.isDefault;
    addAddressController.addressID = address.id;
    addAddressController.province = address.province;
    addAddressController.city = address.city;
    addAddressController.district = address.district;
    [self.navigationController pushViewController:addAddressController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
