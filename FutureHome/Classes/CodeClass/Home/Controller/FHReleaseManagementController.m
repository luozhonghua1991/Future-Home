//
//  FHReleaseManagementController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  发布管理界面

#import "FHReleaseManagementController.h"
#import "FHHouseSaleCell.h"
#import "FHReleaseManagemengModel.h"
#import "FHCarSaleController.h"
#import "BAAlertController.h"

@interface FHReleaseManagementController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *releaseManagemengtArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHReleaseManagemengModel *managementModel;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIButton *selectBtn;


@end

@implementation FHReleaseManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHHouseSaleCell class] forCellReuseIdentifier:NSStringFromClass([FHHouseSaleCell class])];
    [self getRequest];
}

#pragma mark — Request
- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(self.property_id),@"property_id", nil];
    [AFNetWorkTool get:@"property/houseParkRecord" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            self.releaseManagemengtArrs = [[NSMutableArray alloc] init];
            self.releaseManagemengtArrs = [FHReleaseManagemengModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
            [weakSelf.homeTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.releaseManagemengtArrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHHouseSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHHouseSaleCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.managementModel = self.releaseManagemengtArrs[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.managementModel = self.releaseManagemengtArrs[indexPath.section];
    FHCarSaleController *vc = [[FHCarSaleController alloc] init];
    NSInteger type = 0;
    if ([self.managementModel.house_park integerValue] == 1) {
        /** 房屋 */
        if ([self.managementModel.type integerValue] == 1) {
            /** 出售 */
            type = 0;
        } else if ([self.managementModel.type integerValue] == 2) {
            /** 出租 */
            type = 1;
        }
    } else {
        /** 车位 */
        if ([self.managementModel.type integerValue] == 1) {
            /** 出售 */
            type = 2;
        } else {
            /** 出租 */
            type = 3;
        }
    }
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    vc.property_id = [self.managementModel.property_id integerValue];
    vc.id = [self.managementModel.id integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.managementModel = self.releaseManagemengtArrs[section];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    NSString *str;
    if ([self.managementModel.shelves integerValue]== 1) {
        /** 上架状态 做下架操作 */
        str = @"下架";
    } else {
         /** 下架状态 做上架操作 */
        str = @"上架";
    }
    UIButton *cancleBtn = [self creatBtnWithBtnName:str btnTag:section] ;
    cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 140, 15, 60, 20);
    [bgView addSubview:cancleBtn];
    
    UIButton *watieOrderBtn = [self creatBtnWithBtnName:@"删除" btnTag:section];
    watieOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 15, 60, 20);
    [bgView addSubview:watieOrderBtn];
    
    return bgView;
}

- (UIButton *)creatBtnWithBtnName:(NSString *)name btnTag:(NSInteger )tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:HEX_COLOR(0x1296db)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark — event
- (void)btnClick:(UIButton *)sender {
    self.selectBtn = sender;
    NSInteger index = sender.tag;
    self.managementModel = self.releaseManagemengtArrs[index];
    if ([sender.currentTitle isEqualToString:@"下架"]) {
        /** 下架操作 */
        [self creatAlertWithMessage:@"确定要下架该条信息吗?" type:[self.managementModel.shelves integerValue]];
        
    } else if ([sender.currentTitle isEqualToString:@"上架"]) {
        /** 上架操作 */
        [self creatAlertWithMessage:@"确定要上架该条信息吗?" type:[self.managementModel.shelves integerValue]];
        
    } else if ([sender.currentTitle isEqualToString:@"删除"]) {
        /** 是否删除的弹框 */
        //在此添加你想要完成的功能
        [self creatAlertWithMessage:@"确定要删除该条信息吗?" type:3];
    }
}

- (void)creatAlertWithMessage:(NSString *)message
                         type:(NSInteger )type {
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:message buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (type == 1) {
                /**上架操作 */
//                if ([self.managementModel.house_park integerValue] == 1) {
//                    /** 下架房屋 */
//
//                } else {
//                    /** 下架车位 */
//
//                }
                [weakSelf parkOrHouseShelvesWithModel:self.managementModel type:type];
            } else if (type == 2) {
                /**下架操作 */
//                if ([self.managementModel.house_park integerValue] == 1) {
//                    /** 上架房屋 */
//
//                } else {
//                    /** 上架车位 */
//
//                }
                 [weakSelf parkOrHouseShelvesWithModel:self.managementModel type:type];
            } else if (type == 3) {
                /** 确定删除 */
                [weakSelf deleteCarOrHouseWithModel:weakSelf.managementModel];
            }
        }
    }];
}



- (void)deleteCarOrHouseWithModel:(FHReleaseManagemengModel *)managementModel {
    /** 删除操作 */
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.managementModel.property_id,@"property_id",
                               self.managementModel.id,@"id",
                               nil];
    NSString *url;
    if ([self.managementModel.house_park integerValue] == 1) {
        /** 房屋 */
        url = @"property/houseDelete";
    } else {
        url = @"property/parkDelete";
    }
    
    [self deleteCarOrHouseRequestWithURL:url parmar:paramsDic];
}


#pragma mark — 删除车库或者房屋的接口
- (void)deleteCarOrHouseRequestWithURL:(NSString *)url
                                parmar:(NSDictionary *)parmar {
    /** 删除车库或者房屋的接口 */
    WS(weakSelf);
    [AFNetWorkTool post:url params:parmar success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 确定 */
                [self getRequest];
            });
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)parkOrHouseShelvesWithModel:(FHReleaseManagemengModel *)managementModel
                               type:(NSInteger )type {
    /** 删除操作 */ //shelves 1上架 2下架
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.managementModel.property_id,@"property_id",
                               self.managementModel.id,@"id",
                               @(type),@"shelves",
                               nil];
    NSString *url;
    if ([self.managementModel.house_park integerValue] == 1) {
        /** 房屋 */
        url = @"property/houseShelves";
    } else {
        url = @"property/parkShelves";
    }
    
    [self parkOrHouseShelvesWithUrl:url parmar:paramsDic type:type];
}

#pragma mark — 上架或者下架车库或者房屋的接口
- (void)parkOrHouseShelvesWithUrl:(NSString *)url
                           parmar:(NSDictionary *)parmar
                             type:(NSInteger )type {
    
    /** 上架或者下架车库或者房屋的接口 */
    WS(weakSelf);
    [AFNetWorkTool post:url params:parmar success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1) {
            if (type == 1 || type == 2) {
                if (type == 1) {
                    [weakSelf.view makeToast:@"下架成功"];
                    [self.selectBtn setTitle:@"上架" forState:UIControlStateNormal];
                } else {
                    [weakSelf.view makeToast:@"上架成功"];
                    [self.selectBtn setTitle:@"下架" forState:UIControlStateNormal];
                }
            }
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - 35) style:UITableViewStyleGrouped];
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
