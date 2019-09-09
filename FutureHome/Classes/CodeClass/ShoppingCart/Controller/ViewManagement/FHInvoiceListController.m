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

@interface FHInvoiceListController () <UITableViewDelegate,UITableViewDataSource,FHInvoiceListCellDelegate>
/**发票列表table*/
@property (nonatomic,strong) UITableView *invoiceListTableView;
@end

@implementation FHInvoiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.invoiceListTableView];
    [self.invoiceListTableView registerClass:[FHInvoiceListCell class] forCellReuseIdentifier:NSStringFromClass([FHInvoiceListCell class])];
    [self creatBottomBtn];
}






- (void)creatBottomBtn{
    UIButton *addInvoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addInvoiceBtn.frame = CGRectMake(0,SCREEN_HEIGHT - MainSizeHeight - 70 - ZH_SCALE_SCREEN_Height(50) - [self getTabbarHeight], SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    addInvoiceBtn.backgroundColor = HEX_COLOR(0x1296db);
    [addInvoiceBtn setTitle:@"新增发票" forState:UIControlStateNormal];
    [addInvoiceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [addInvoiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addInvoiceBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addInvoiceBtn];
}


#pragma mark — event
- (void)addInvoiceBtnClick {
    /** 添加发票界面 */
    [self pushVCWithTitle:@"添加发票" companyName:@"罗氏集团" companyCode:@"罗氏集团"];
}

- (void)pushVCWithTitle:(NSString *)titleName
            companyName:(NSString *)companyName
            companyCode:(NSString *)companyCode {
    FHAddOrEditInvoiceController *addAddressController = [[FHAddOrEditInvoiceController alloc]init];
    addAddressController.hidesBottomBarWhenPushed = YES;
    addAddressController.titleName = titleName;
    addAddressController.companyName = companyName;
    addAddressController.companyCode = companyCode;
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
    FHInvoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHInvoiceListCell class])];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    if (!IS_NULL_ARRAY(allAddressArray)) {
    //        self.addressModel = allAddressArray[indexPath.section];
//    cell.addressModel = self.addressModel;
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


#pragma mark — setter && getter
//懒加载
- (UITableView *)invoiceListTableView {
    if (_invoiceListTableView == nil) {
        _invoiceListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - [self getTabbarHeight] - ZH_SCALE_SCREEN_Height(50) - 70) style:UITableViewStyleGrouped];
        _invoiceListTableView.dataSource = self;
        _invoiceListTableView.delegate = self;
        _invoiceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _invoiceListTableView.showsVerticalScrollIndicator = NO;
        _invoiceListTableView.backgroundColor =  ZH_COLOR(241, 241, 241);
        if (@available (iOS 11.0, *)) {
            _invoiceListTableView.estimatedSectionHeaderHeight = 0.01;
            _invoiceListTableView.estimatedSectionFooterHeight = 0.01;
            _invoiceListTableView.estimatedRowHeight = 0.01;
        }
    }
    return _invoiceListTableView;
}

@end
