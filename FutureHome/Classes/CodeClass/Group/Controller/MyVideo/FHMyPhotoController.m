//
//  FHMyPhotoController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  我的相册

#import "FHMyPhotoController.h"
#import "FHMyPhotoListCell.h"
#import "DPPhotoLibrary.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FHPhotoModel.h"

#define kMasonryCell @"kMasonryCell"

@interface FHMyPhotoController () <UITableViewDelegate,UITableViewDataSource>
///** 主页列表数据 */
//@property (nonatomic, strong) UITableView *homeTable;
///** 图片列表 */
//@property (nonatomic, copy) NSArray *picListArrs;
///** <#strong属性注释#> */
//@property (nonatomic, strong) DPPhotoListView *photoListView;
///** <#copy属性注释#> */
//@property (nonatomic, copy) NSArray *imgArrs;

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSMutableArray *dataArray;


@end

@implementation FHMyPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.homeTable];
//    [self getRequest];
//    [self.homeTable registerClass:[FHMyPhotoListCell class] forCellReuseIdentifier:NSStringFromClass([FHMyPhotoListCell class])];
    
    [self setUpAllView];
    [self getPhotoListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPhotoListData];
}

- (void)setUpAllView {
    CGFloat tabbarH = [self getTabbarHeight];
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTable.tableFooterView = [[UIView alloc]init];
    _mainTable.estimatedRowHeight = 100;
    // 必须先注册cell，否则会报错
    [_mainTable registerClass:[FHMyPhotoListCell class] forCellReuseIdentifier:kMasonryCell];
    [self.view addSubview:self.mainTable];
}

- (void)getPhotoListData {
    /** 获取相册列表 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.user_id ? self.user_id : @(account.user_id),@"uid", nil];
    [AFNetWorkTool get:@"sheyun/myAlbum" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf requestWithDic:responseObj[@"data"]];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestWithDic:(NSDictionary *)dic {
    NSArray *photoListArrs = [dic objectForKey:@"list"];
    NSMutableArray *arrM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in photoListArrs) {
            FHPhotoModel *commit = [FHPhotoModel commitWithDict:dictDict];
            [arrM addObject:commit];
        }
        self.dataArray = arrM;
        dispatch_async(dispatch_get_main_queue(), ^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mainTable reloadData];
//            });
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FHMyPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMasonryCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.weakSelf = self;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 计算缓存cell的高度
    return [self.mainTable fd_heightForCellWithIdentifier:kMasonryCell cacheByIndexPath:indexPath configuration:^(FHMyPhotoListCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
    
}

#pragma mark - 给cell赋值
- (void)configureCell:(FHMyPhotoListCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;
    cell.model = self.dataArray[indexPath.row];
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//#pragma mark  -- tableViewDelagate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.picListArrs.count;
////    return 2;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dic = self.picListArrs[indexPath.row];
//    NSArray *arr = dic[@"path"];
//    self.photoListView = [[DPPhotoListView alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH - 80, SCREEN_HEIGHT) numberOfCellInRow:3 lineSpacing:15 dataSource:[arr mutableCopy]];
//    CGFloat height = [self.photoListView getItemSizeHeight];
//    CGFloat photoListHeight = 0.0;
//    if (arr.count == 0) {
//        photoListHeight = 0;
//    } else if (arr.count <= 3) {
//        photoListHeight = height + 15;
//    } else if (arr.count <=6 && arr.count > 3) {
//        photoListHeight = 2 * height + 15 * 2;
//    } else if (arr.count <=9 && arr.count > 6) {
//        photoListHeight = 3 * height + 15 * 3;
//    }
//
//    return photoListHeight;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FHMyPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMyPhotoListCell class])];
//    NSDictionary *dic = self.picListArrs[indexPath.row];
//    cell.timeLabel.text = dic[@"create_time"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.imgArrs = dic[@"path"];
//    return cell;
//}
//
//#pragma mark — setter & getter
//- (UITableView *)homeTable {
//    if (_homeTable == nil) {
//        CGFloat tabbarH = [self getTabbarHeight];
//        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 70) style:UITableViewStylePlain];
//        _homeTable.dataSource = self;
//        _homeTable.delegate = self;
//        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _homeTable.showsVerticalScrollIndicator = NO;
//        if (@available (iOS 11.0, *)) {
//            _homeTable.estimatedSectionHeaderHeight = 0.01;
//            _homeTable.estimatedSectionFooterHeight = 0.01;
//            _homeTable.estimatedRowHeight = 0.01;
//        }
//    }
//    return _homeTable;
//}

@end
