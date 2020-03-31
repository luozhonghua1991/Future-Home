//
//  FHGoodsDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商品详情界面

#import "FHGoodsDetailController.h"
#import "BHInfiniteScrollView.h"
#import "SDPhotoBrowser.h"
#import "FHCarSaleCell.h"
#import "FHGoodsDetailCell.h"
#import "PPNumberButton.h"
#import "FHGoodsDetailModel.h"

@interface FHGoodsDetailController () <UITableViewDelegate,UITableViewDataSource,BHInfiniteScrollViewDelegate,SDPhotoBrowserDelegate>
/** 上面的轮播图 */
@property (nonatomic, strong) BHInfiniteScrollView *topScrollView;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 头视图 */
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong)GNRShoppingBar * shoppingBar;

@property (nonatomic, strong) PPNumberButton *numberButton;
/** <#strong属性注释#> */
@property (nonatomic, copy) NSArray *urlArrays;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHGoodsDetailModel *goodsDetailModel;


@end

@implementation FHGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self getGoodsDetailRequest];
    [self.view addSubview:self.homeTable];
    self.homeTable.tableHeaderView = self.headerView;
    self.homeTable.tableHeaderView.height = SCREEN_WIDTH * 0.618;
    [self.homeTable registerClass:[FHGoodsDetailCell class] forCellReuseIdentifier:NSStringFromClass([FHGoodsDetailCell class])];
    [self.view addSubview:self.shoppingBar];
    [self.view addSubview:[SingleManager shareManager].shoppingBar];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"商品详情";
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


- (void)getGoodsDetailRequest {
    WS(weakSelf);
    [ZHProgressHUD showProgress:@"加载中..." inView:self.view];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.goodsModel.goodsID,@"good_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool get:@"shop/getSinggoodInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [ZHProgressHUD hide];
            NSDictionary *dic = responseObj[@"data"];
            weakSelf.urlArrays = dic[@"img_ids"];
            self.topScrollView = [self fh_creatBHInfiniterScrollerViewWithImageArrays:self.urlArrays scrollViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618) scrollViewTag:2018];
            [self.headerView addSubview:self.topScrollView];
            self.goodsDetailModel = [FHGoodsDetailModel mj_objectWithKeyValues:dic];
            self.goodsDetailModel.Isrestrictions = self.goodsModel.Isrestrictions;
            self.goodsDetailModel.sell_price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"sell_price"] floatValue]];
            [weakSelf.homeTable reloadData];
        } else {
            [ZHProgressHUD hide];
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [ZHProgressHUD hide];
        [weakSelf.homeTable reloadData];
    }];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SingleManager shareManager].goodsDetailHeight + 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FHGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHGoodsDetailCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodsDetailModel = self.goodsDetailModel;
    
    /** 重用问题 */
    if (!self.numberButton) {
        self.numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(SCREEN_WIDTH - 120, 14, 100, 30)];
    }
    // 初始化时隐藏减按钮
    self.numberButton.decreaseHide = YES;
    self.numberButton.longPressSpaceTime = CGFLOAT_MAX;
    self.numberButton.increaseImage = [UIImage imageNamed:@"increase_eleme"];
    self.numberButton.decreaseImage = [UIImage imageNamed:@"decrease_eleme"];
    self.numberButton.currentNumber = self.currentNumber;
//    self.numberButton.currentNumber = 7;
    WS(weakSelf);
    self.numberButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        if (increaseStatus) {
            weakSelf.stepper.count++;
            if (weakSelf.stepper.block) {
                weakSelf.stepper.block(number);
            }
            if (weakSelf.stepper.addActionBlock) {
                weakSelf.stepper.addActionBlock((UIButton *)weakSelf.stepper);
            }
        } else {
            /** 减的状态 */
            if (number > 0) {
                weakSelf.stepper.count--;
            }
            
            if (weakSelf.stepper.block) {
                weakSelf.stepper.block(number);
            }

            if (weakSelf.stepper.subActionBlock) {
                weakSelf.stepper.subActionBlock((UIButton *)weakSelf.stepper);
            }
        }
        NSLog(@"%f",number);
//        weakSelf.numberButton.currentNumber = number;
    };
//    [SingleManager shareManager].numberButton = self.numberButton;
    
    [cell.contentView addSubview:self.numberButton];
    
    return cell;
    
}

/** 创建轮播图的实例方法 */
- (BHInfiniteScrollView *)fh_creatBHInfiniterScrollerViewWithImageArrays:(NSArray *)imageArrs
                                                         scrollViewFrame:(CGRect )scrollViewFrame
                                                           scrollViewTag:(NSInteger)scrollViewTag {
    BHInfiniteScrollView *mallScrollView = [BHInfiniteScrollView
                                            infiniteScrollViewWithFrame:scrollViewFrame Delegate:self ImagesArray:imageArrs];
    
    mallScrollView.titleView.hidden = YES;
    mallScrollView.scrollTimeInterval = 3;
    mallScrollView.autoScrollToNextPage = YES;
    mallScrollView.delegate = self;
    mallScrollView.contentMode = UIViewContentModeScaleAspectFill;
    mallScrollView.tag = scrollViewTag;
    return mallScrollView;
}

#pragma mark  -- 点击banner的代理方法
/** 点击图片*/
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = (int)index;
    browser.imageArray = self.urlArrays;
    [browser show];
}

#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

@end
