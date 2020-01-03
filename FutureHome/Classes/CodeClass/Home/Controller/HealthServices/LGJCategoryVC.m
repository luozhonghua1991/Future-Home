//
//  LGJCategoryVC.m
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//一级分类界面

#import "LGJCategoryVC.h"
#import "LGJProductsVC.h"
#import "FHHealthCategoryModel.h"

@interface LGJCategoryVC ()<UITableViewDelegate, UITableViewDataSource, ProductsDelegate>

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong)  LGJProductsVC *productsVC;
/** <#strong属性注释#> */
@property (nonatomic, strong) UILabel *oldSelectLabel;

@end

@implementation LGJCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self configData];
    [self createTableView];
    
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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

- (void)configData {
    WS(weakSelf);
    self.categoryArr = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.type,@"type", nil];
    [AFNetWorkTool get:@"health/cateMenu" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 获取成功 */
            weakSelf.categoryArr = [FHHealthCategoryModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            [self.categoryTableView reloadData];
            [weakSelf createProductsVC];
            NSArray *arr = responseObj[@"data"];
            NSDictionary *dic = arr[0];
            NSDictionary *healthDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       dic[@"category_id"],@"category_id",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHHEALTH" object:nil userInfo:healthDic];
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {

    }];
    
//    if (!_categoryArr) {
//
//        NSArray *numArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
//        NSMutableArray *tmpArr = [NSMutableArray array];
//        for (int i = 0; i < 20; i++) {
//            NSString *tmpStr = [NSString stringWithFormat:@"第%@类", numArr[i]];
//            [tmpArr addObject:tmpStr];
//        }
//        _categoryArr = tmpArr;
//    }
}

- (void)createTableView {
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, self.view.frame.size.width * 0.26, self.view.frame.size.height - MainSizeHeight) style:UITableViewStylePlain];
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    self.categoryTableView.backgroundColor = HEX_COLOR(0xCCCCCC);
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.categoryTableView];
}

- (void)createProductsVC {
    _productsVC = [[LGJProductsVC alloc] init];
    _productsVC.delegate = self;
    _productsVC.sectionCount = self.categoryArr.count;
    [self addChildViewController:_productsVC];
    [self.view addSubview:_productsVC.view];
}

//MARK:-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categoryArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"ident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        //cell里自己定义label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, self.view.frame.size.width * 0.26 - 6, 44)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 100;
        label.textColor = [UIColor blackColor];
        //换行代码
        label.numberOfLines = 0;
        [cell.contentView addSubview:label];
        UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
        view.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = view;
        cell.backgroundColor = HEX_COLOR(0xE8E8E8);
    }
    UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:100];
    FHHealthCategoryModel *model = [self.categoryArr objectAtIndex:indexPath.row];
    titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (indexPath.row == 0) {
        titleLabel.textColor = [UIColor blueColor];
        self.oldSelectLabel = titleLabel;
        NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.categoryTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:100];
    if (self.oldSelectLabel == titleLabel) {
        
    } else {
        titleLabel.textColor = [UIColor blueColor];
        self.oldSelectLabel.textColor = [UIColor blackColor];
    }
    self.oldSelectLabel = titleLabel;
    FHHealthCategoryModel *model = self.categoryArr[indexPath.row];
    if (_productsVC) {
//        [_productsVC scrollToSelectedIndexPath:indexPath];
        [_productsVC resreshDataWithPid:model.category_id];
    }
}

//#pragma mark - ProductsDelegate
//- (void)willDisplayHeaderView:(NSInteger)section {
//
//    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//}
//
//- (void)didEndDisplayingHeaderView:(NSInteger)section {
//
//    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section + 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
