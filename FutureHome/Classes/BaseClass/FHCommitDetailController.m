//
//  FHCommitDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/19.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  信息详情界面

#import "FHCommitDetailController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZJMasonryAutolayoutCell.h"
#import "ZJCommit.h"
#import "XHInputView.h"
#import "FHCommitModel.h"
#import "FHCommitDetaolCell.h"
#import "ZJNoHavePhotoCell.h"

/** 没有图片的 */
#define kNoPicMasonryCell @"kNoPicMasonryCell"
/** 有图片的 */
#define kPicMasonryCell @"kPicMasonryCell"

@interface FHCommitDetailController () <UITableViewDelegate,UITableViewDataSource,XHInputViewDelagete,FDActionSheetDelegate>

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSMutableArray *dataArray;
/** 评论列表 */
@property (nonatomic, strong) NSMutableArray *commitDataArrs;

/** 二维码图 */
@property (nonatomic, strong) UIImageView *codeImgView;

@end

@implementation FHCommitDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self setUpAllView];
    if (self.type == 3) {
        //    /** 评论详情数据 */
        [self requestWithDic:self.dongTaiDataDic];
    } else {
        //    /** 评论详情数据 */
        [self requestWithDic:self.dataDic];
    }
    /** 评论数据 */
    [self getCommitsData];
    
    if (!self.isCanCommit) {
        [self fh_creatBottomInputView];
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    /** 评论详情数据 */
//    [self requestWithDic:self.dataDic];
//    [self getCommitsData];
//}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"信息详情";
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
    
    self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, MainStatusBarHeight + 5, 25, 25)];
    self.codeImgView.image = [UIImage imageNamed:@"saoyisao-2"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.codeImgView.userInteractionEnabled = YES;
    [self.codeImgView addGestureRecognizer:tap];
    [self.navgationView addSubview:self.codeImgView];
}

- (void)tapClick {
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:@"确定删除该条动态吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet addAnimation];
    [actionSheet show];
}


#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
//    switch (buttonIndex)
//    {
//        case 0:
//        {
//            /** 做删除动态的操作 */
//
////            [self addCamera];
//            break;
//        }
//        case 1:
//        {
//            ZHLog(@"取消");
//            break;
//        }
//        default:
//
//            break;
//    }
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 获取评论的数据数据
- (void)getCommitsData {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *url;
    NSDictionary *paramsDic;
    if (self.type == 3) {
        url = @"sheyun/commentList";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     self.ID,@"id",
                     nil];
    } else {
        url = @"public/complaintDetail";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     @(self.property_id),@"property_id",
                     @(self.type),@"type",
                     self.ID,@"id",
                     nil];
    }
    self.commitDataArrs = [[NSMutableArray alloc] init];
    [AFNetWorkTool get:url params:paramsDic success:^(id responseObj) {
        NSDictionary *Dic = responseObj[@"data"];
        weakSelf.commitDataArrs = [FHCommitModel mj_objectArrayWithKeyValuesArray:Dic[@"list"]];
        [weakSelf.mainTable reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestWithDic:(NSDictionary *)dic {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:dic];
    NSMutableArray *arrM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in arr) {
            if (self.type == 3) {
                ZJCommit *commit = [ZJCommit commitWithDongtaiDict:dictDict];
                [arrM addObject:commit];
            } else {
                ZJCommit *commit = [ZJCommit commitWithDict:dictDict];
                [arrM addObject:commit];
            }
            
        }
        self.dataArray = arrM;
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mainTable reloadData];
            });
        });
    });
}


- (void)setUpAllView {
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, kScreenWidth, kScreenHeight - MainSizeHeight - 40) style:UITableViewStylePlain];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable.tableFooterView = [[UIView alloc] init];
    if (@available (iOS 11.0, *)) {
        self.mainTable.estimatedSectionHeaderHeight = 0.01;
        self.mainTable.estimatedSectionFooterHeight = 0.01;
        self.mainTable.estimatedRowHeight = 0.01;
    }
    // 必须先注册cell，否则会报错
    [self.mainTable registerClass:[ZJMasonryAutolayoutCell class] forCellReuseIdentifier:kPicMasonryCell];
    [self.mainTable registerClass:[ZJNoHavePhotoCell class] forCellReuseIdentifier:kNoPicMasonryCell];
    [self.mainTable registerClass:[FHCommitDetaolCell class] forCellReuseIdentifier:NSStringFromClass([FHCommitDetaolCell class])];
    [self.view addSubview:self.mainTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;
    }
    return self.commitDataArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZJCommit *commit = self.dataArray[indexPath.row];
        if (commit.pic_urls > 0) {
            ZJMasonryAutolayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kPicMasonryCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.weakSelf = self;
            [self configureCell:cell atIndexPath:indexPath];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        } else {
            ZJNoHavePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:kNoPicMasonryCell];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self configureNoCell:photoCell atIndexPath:indexPath];
            
            return photoCell;
        }
    }
    FHCommitDetaolCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCommitDetaolCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    FHCommitModel *model = self.commitDataArrs[indexPath.row];
    cell.commitModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     ZJCommit *commit = self.dataArray[indexPath.row];
    if (indexPath.section == 0) {
        if (commit.pic_urls > 0) {
            // 计算缓存cell的高度
//            return [self.mainTable fd_heightForCellWithIdentifier:kPicMasonryCell cacheByIndexPath:indexPath configuration:^(ZJMasonryAutolayoutCell *cell) {
//                [self configureCell:cell atIndexPath:indexPath];
//            }];
            return [SingleManager shareManager].cellPicHeight;
        } else {
            return [self.mainTable fd_heightForCellWithIdentifier:kNoPicMasonryCell cacheByIndexPath:indexPath configuration:^(ZJNoHavePhotoCell *photoCell) {
                [self configureNoCell:photoCell atIndexPath:indexPath];
            }];
        }
    }
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"评论列表";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:lineView];
        
        return view;
    }
    return [[UIView alloc] init];
}


#pragma mark - 给cell赋值
- (void)configureCell:(ZJMasonryAutolayoutCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;
    cell.model = self.dataArray[indexPath.row];
}

- (void)configureNoCell:(ZJNoHavePhotoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.dataArray[indexPath.row];
}

- (void)fh_creatBottomInputView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 50, 35)];
    label.text = @"我来说两句。。。";
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1;
    label.font = [UIFont systemFontOfSize:15];
    label.userInteractionEnabled = YES;
    [bottomView addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInputView)];
    bottomView.userInteractionEnabled = YES;
    [bottomView addGestureRecognizer:tap];
}

#pragma mark — event
- (void)showInputView {
    /** 可以评论 */
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = @"请输入评论文字...";
        /** 设置最大输入字数 */
        inputView.maxCount = 500;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            [self updateCommitWithContent:text];
            NSLog(@"输入为信息为:%@",text);
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-你输入的内容为空");
            return NO;//return NO,不收键盘
        }
    }];
}

- (void)updateCommitWithContent:(NSString *)text {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary * paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                @(account.user_id),@"user_id",
                                @(self.property_id),@"property_id",
                                @(self.type),@"type",
                                self.ID,@"id",
                                text,@"content",
                                nil];
    self.commitDataArrs = [[NSMutableArray alloc] init];
    [AFNetWorkTool post:@"public/feedComplaints" params:paramsDic success:^(id responseObj) {
        
        [weakSelf getCommitsData];
    } failure:^(NSError *error) {
    }];
}

#pragma mark — setter && getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
