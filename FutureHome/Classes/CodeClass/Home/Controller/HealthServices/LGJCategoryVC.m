//
//  LGJCategoryVC.m
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//一级分类界面

#import "LGJCategoryVC.h"
#import "LGJProductsVC.h"

@interface LGJCategoryVC ()<UITableViewDelegate, UITableViewDataSource, ProductsDelegate>

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSArray *categoryArr;
@property (nonatomic, strong)  LGJProductsVC *productsVC;

@end

@implementation LGJCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self configData];
    [self createTableView];
    [self createProductsVC];
    
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
    
    if (!_categoryArr) {
        
        NSArray *numArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NSString *tmpStr = [NSString stringWithFormat:@"第%@类", numArr[i]];
            [tmpArr addObject:tmpStr];
        }
        _categoryArr = tmpArr;
    }
}

- (void)createTableView {
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, self.view.frame.size.width * 0.45, self.view.frame.size.height - MainSizeHeight) style:UITableViewStylePlain];
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.categoryTableView];
}

- (void)createProductsVC {
    
    _productsVC = [[LGJProductsVC alloc] init];
    _productsVC.delegate = self;
    [self addChildViewController:_productsVC];
    [self.view addSubview:_productsVC.view];
}

//MARK:-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _categoryArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ident = @"ident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = [_categoryArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_productsVC) {
        [_productsVC scrollToSelectedIndexPath:indexPath];
    }
}

#pragma mark - ProductsDelegate
- (void)willDisplayHeaderView:(NSInteger)section {
    
    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didEndDisplayingHeaderView:(NSInteger)section {
    
    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section + 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
