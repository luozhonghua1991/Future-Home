//
//  FHSuggestionListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  投诉建议列表 界面

#import "FHSuggestionListController.h"
#import "ZJMasonryAutolayoutCell.h"
#import "ZJCommit.h"
#import "FHCommitDetailController.h"
#import "ZJNoHavePhotoCell.h"

/** 没有图片的 */
#define kNoPicMasonryCell @"kNoPicMasonryCell"
/** 有图片的 */
#define kPicMasonryCell @"kPicMasonryCell"

@interface FHSuggestionListController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSMutableArray *dataArray;
/** 数据 */
@property (nonatomic, strong) NSArray *commitsListArrs;

@end

@implementation FHSuggestionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllView];
    [self getCommitsData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCommitsData];
}

- (void)getCommitsData {
    /** 投诉或者建议接口 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic;
    if (self.isSelf) {
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     @(self.property_id),@"property_id",
                     @(self.type),@"type",
                     @(1),@"self",
                     nil];
    } else {
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     @(self.property_id),@"property_id",
                     @(self.type),@"type",
                     nil];
    }
    
    [AFNetWorkTool get:@"public/complaintList" params:paramsDic success:^(id responseObj) {
        [self endRefreshAction];
        NSDictionary *Dic = responseObj[@"data"];
        [weakSelf requestWithDic:Dic];
    } failure:^(NSError *error) {
    }];
}

- (void)requestWithDic:(NSDictionary *)dic {
    NSArray *commitsList = [dic objectForKey:@"list"];
    self.commitsListArrs = commitsList;
    NSMutableArray *arrM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in commitsList) {
            ZJCommit *commit = [ZJCommit commitWithDict:dictDict];
            [arrM addObject:commit];
        }
        self.dataArray = arrM;
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mainTable reloadData];
            });
        });
    });
}

- (void)endRefreshAction
{
    MJRefreshHeader *header = self.mainTable.mj_header;
    MJRefreshFooter *footer = self.mainTable.mj_footer;
    
    if (header.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:header];
    }
    if (footer.state == MJRefreshStateRefreshing) {
        [self delayEndRefresh:footer];
    }
}

- (void)setUpAllView {
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - MainSizeHeight - 35) style:UITableViewStylePlain];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mainTable.tableFooterView = [[UIView alloc] init];
    self.mainTable.estimatedRowHeight = 100;
    // 必须先注册cell，否则会报错
    [self.mainTable registerClass:[ZJMasonryAutolayoutCell class] forCellReuseIdentifier:kPicMasonryCell];
    [self.mainTable registerClass:[ZJNoHavePhotoCell class] forCellReuseIdentifier:kNoPicMasonryCell];
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommitsData)];
    [self.view addSubview:self.mainTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJCommit *commit = self.dataArray[indexPath.row];
    //视频单独处理
    if (commit.pic_urls.count > 0) {
        ZJMasonryAutolayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kPicMasonryCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.weakSelf = self;
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    /** 纯文字Cell */
    ZJNoHavePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:kNoPicMasonryCell];
    photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureNoCell:photoCell atIndexPath:indexPath];
    return photoCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJCommit *commit = self.dataArray[indexPath.row];
    if (commit.pic_urls.count > 0) {
        return [SingleManager shareManager].cellPicHeight;
    }
    return [SingleManager shareManager].cellNoPicHeight;
}


#pragma mark - 给cell赋值
- (void)configureCell:(ZJMasonryAutolayoutCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.dataArray[indexPath.row];
}

- (void)configureNoCell:(ZJNoHavePhotoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.dataArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZJCommit *model = self.dataArray[indexPath.row];
    FHCommitDetailController *vc = [[FHCommitDetailController alloc] init];
    vc.isCanCommit = self.isSelf;
    vc.dataDic = self.commitsListArrs[indexPath.row];
    vc.type = self.type;
    vc.property_id = self.property_id;
    vc.ID = model.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
