//
//  FHWaitOrderController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  待付款

#import "FHWaitOrderController.h"
#import "FHWatingOrderCell.h"
#import "FHOrderDetailController.h"

@interface FHWaitOrderController () <UITableViewDelegate,UITableViewDataSource>
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;

@end

@implementation FHWaitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHWatingOrderCell class] forCellReuseIdentifier:NSStringFromClass([FHWatingOrderCell class])];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 85.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"未来生鲜-龙湖U城店                                                                    >";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
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
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH, 40)];
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.text = @"合计 : 370";
    bottomLabel.textColor = [UIColor blackColor];
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:bottomLabel];
    
    if (self.type == 0) {
        /** 待付款 */
        UIButton *cancleBtn = [self creatBtnWithBtnName:@"取消订单"];
        cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 140, 50, 60, 20);
        [bgView addSubview:cancleBtn];
        
        UIButton *watieOrderBtn = [self creatBtnWithBtnName:@"待付款"];
        watieOrderBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 50, 60, 20);
        [bgView addSubview:watieOrderBtn];
    } else if (self.type == 1) {
        /** 待收货 */
        UIButton *waitGetBtn = [self creatBtnWithBtnName:@"确认收货"];
        waitGetBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 50, 60, 20);
        [bgView addSubview:waitGetBtn];
    } else if (self.type == 2) {
        /** 待评价 */
        UIButton *waitGetBtn = [self creatBtnWithBtnName:@"待评价"];
        waitGetBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 50, 60, 20);
        [bgView addSubview:waitGetBtn];
    } else if (self.type == 3) {
        /** 退货退款 */
        UIButton *waitGetBtn = [self creatBtnWithBtnName:@"退货退款"];
        waitGetBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 50, 60, 20);
        [bgView addSubview:waitGetBtn];
    }
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHWatingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHWatingOrderCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIButton *)creatBtnWithBtnName:(NSString *)name {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:HEX_COLOR(0x1296db)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    return btn;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHOrderDetailController *detail = [[FHOrderDetailController alloc] init];
    detail.type = self.type;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70) style:UITableViewStyleGrouped];
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
