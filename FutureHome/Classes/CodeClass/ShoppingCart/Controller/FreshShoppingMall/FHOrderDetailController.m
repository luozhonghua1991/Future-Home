//
//  FHOrderDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  订单详情界面

#import "FHOrderDetailController.h"
#import "FHWatingOrderCell.h"

@interface FHOrderDetailController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self creatBottomBtn];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHWatingOrderCell class] forCellReuseIdentifier:NSStringFromClass([FHWatingOrderCell class])];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"订单详情";
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

- (void)creatBottomBtn {
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    bottomBtn.backgroundColor = HEX_COLOR(0x1296db);
    [bottomBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [completedBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    if (self.type == 0) {
        /** 待付款 */
//        UIButton *cancleBtn = [self creatBtnWithBtnName:@"取消订单"];
//        cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 140, 50, 60, 20);
//        [bgView addSubview:cancleBtn];
//
//        UIButton *watieOrderBtn = [self creatBtnWithBtnName:@"待付款"];
//        watieOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 50, 60, 20);
//        [bgView addSubview:watieOrderBtn];
    } else if (self.type == 1) {
        /** 待收货 */
//        UIButton *waitGetBtn = [self creatBtnWithBtnName:@"确认收货"];
//        waitGetBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 50, 60, 20);
//        [bgView addSubview:waitGetBtn];
    } else if (self.type == 2) {
        /** 待评价 */
        [bottomBtn setTitle:@"待评价" forState:UIControlStateNormal];
    } else if (self.type == 3) {
        /** 退货退款 */
        [bottomBtn setTitle:@"已完成" forState:UIControlStateNormal];
    }
}

#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 5;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 90.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 90.0f;
    } else if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 90.0f;
        }
        return 40.0f;
    } else {
        return 40.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"未来生鲜-龙湖U城店";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.text = @"配送费";
    topLabel.textColor = [UIColor blackColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:topLabel];
    
    UILabel *topRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10, 40)];
    topRightLabel.font = [UIFont systemFontOfSize:13];
    topRightLabel.text = @"￥10";
    topRightLabel.textColor = [UIColor blackColor];
    topRightLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:topRightLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lineView];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 10, 40)];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.text = @"合计 : 370";
    bottomLabel.textColor = [UIColor blackColor];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:bottomLabel];
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            static NSString *ID = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = @"Loren_";
            cell.detailTextLabel.text = @"重庆市恒大未来城";
            return cell;
        } else {
            static NSString *ID = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            if (indexPath.row ==0) {
                cell.textLabel.text = @"物流方式";
                cell.detailTextLabel.text = @"快递到家";
            } else {
                cell.textLabel.text = @"开票单位";
                cell.detailTextLabel.text = @"重庆同熙传媒科技有限公司";
            }
            return cell;
        }
    } else if (indexPath.section == 2) {
        static NSString *ID = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"订单编号";
            cell.detailTextLabel.text = @"CQ23341344";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"支付方式";
            cell.detailTextLabel.text = @"微信支付";
        } else {
            cell.textLabel.text = @"信息备注";
            cell.detailTextLabel.text = @"备注信息(非必填)>";
        }
        return cell;
    }
    FHWatingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHWatingOrderCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - ZH_SCALE_SCREEN_Height(50)) style:UITableViewStyleGrouped];
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
