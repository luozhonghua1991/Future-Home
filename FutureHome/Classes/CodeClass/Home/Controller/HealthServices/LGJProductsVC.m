//
//  LGJProductsVC.m
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//

#import "LGJProductsVC.h"
#import "FHHealthProductModel.h"
#import "FHWebViewController.h"

@interface LGJProductsVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *productsTableView;
@property(nonatomic, strong)NSMutableArray *productsArr;
@property(nonatomic, strong)NSArray *sectionArr;
@property(nonatomic, assign)BOOL isScrollUp;//是否是向上滚动
@property(nonatomic, assign)CGFloat lastOffsetY;//滚动即将结束时scrollView的偏移量

@end

@implementation LGJProductsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isScrollUp = false;
    _lastOffsetY = 0;
    
    [self configData];
    [self createTableView];
    
    // Do any additional setup after loading the view.
}

- (void)configData {
    [self getRequestWithPid:@"1"];
}

- (void)getRequestWithPid:(NSString *)pid {
    WS(weakSelf);
    self.productsArr = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(1),@"page",
                               pid,@"pid", nil];
    [AFNetWorkTool get:@"health/disesseArticle" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 获取成功 */
            weakSelf.productsArr = [FHHealthProductModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"][@"list"]];
            [weakSelf.productsTableView reloadData];
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)createTableView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.25, 0, self.view.frame.size.width * 0.75, self.view.frame.size.height)];
    
    self.productsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, self.view.frame.size.width, self.view.frame.size.height - MainSizeHeight)];
    self.productsTableView.delegate = self;
    self.productsTableView.dataSource = self;
    self.productsTableView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.productsTableView];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.sectionCount;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    return [_sectionArr objectAtIndex:section];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    FHHealthProductModel *model = [self.productsArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FHHealthProductModel *model = self.productsArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = model.url;
    web.title = model.title;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(willDisplayHeaderView:)] != _isScrollUp &&_productsTableView.isDecelerating) {
//        [self.delegate willDisplayHeaderView:section];
//    }
//
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
//
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didEndDisplayingHeaderView:)] && _isScrollUp &&_productsTableView.isDecelerating) {
//        [self.delegate didEndDisplayingHeaderView:section];
//    }
//}

//#pragma mark - scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    NSLog(@"_lastOffsetY : %f,scrollView.contentOffset.y : %f", _lastOffsetY, scrollView.contentOffset.y);
//    _isScrollUp = _lastOffsetY < scrollView.contentOffset.y;
//    _lastOffsetY = scrollView.contentOffset.y;
//    NSLog(@"______lastOffsetY: %f", _lastOffsetY);
//}

#pragma mark - 一级tableView滚动时 实现当前类tableView的联动
- (void)scrollToSelectedIndexPath:(NSIndexPath *)indexPath {
    
//    [self.productsTableView selectRowAtIndexPath:([NSIndexPath indexPathForRow:0 inSection:indexPath.row]) animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}


- (void)resreshDataWithPid:(NSString *)pid {
    [self getRequestWithPid:pid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
