//
//  FHCommitDetailController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/19.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  动态详情界面

#import "FHCommitDetailController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZJMasonryAutolayoutCell.h"
#import "ZJCommit.h"
#import "XHInputView.h"
#import "FHCommitModel.h"
#import "FHCommitDetaolCell.h"
#import "ZJNoHavePhotoCell.h"
#import "FHZJHaveMoveCell.h"
#import "FHPersonTrendsController.h"

/** 没有图片的 */
#define kNoPicMasonryCell @"kNoPicMasonryCell"
/** 有图片的 */
#define kPicMasonryCell @"kPicMasonryCell"

@interface FHCommitDetailController () <UITableViewDelegate,UITableViewDataSource,XHInputViewDelagete,FDActionSheetDelegate,ZJNoHavePhotoCellDelegate,ZJMasonryAutolayoutCellDelegate,FHZJHaveMoveCellDelagate>

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
        //    /** 动态详情数据 */
        [self requestWithDic:self.dongTaiDataDic];
    } else {
        //    /** 评论详情数据 */
        [self requestWithDic:self.dataDic];
    }
    /** 评论数据 */
    [self getCommitsData];
    
    if (self.isCanCommit) {
        [self fh_creatBottomInputView];
    }
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"动态详情";
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
    
    if (self.type == 3) {
        Account *account = [AccountStorage readAccount];
        if ([self.dongTaiDataDic[@"user_id"] integerValue] == account.user_id) {
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 50, MainStatusBarHeight - 10, MainNavgationBarHeight, MainNavgationBarHeight);
            [deleteBtn setTitle:@"···" forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = [UIFont systemFontOfSize:35];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
            [self.navgationView addSubview:deleteBtn];
        }
    }
}

- (void)tapClick {
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:@"确定删除该条动态吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}


#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex)
    {
        case 0: {
            /** 做删除动态的操作 */
            [self deleteDynamic];
            break;
        }
        case 1: {
            ZHLog(@"取消");
            break;
        }
        default:

            break;
    }
}

- (void)deleteDynamic {
    ZJCommit *commit = self.dataArray[0];
    Account *account = [AccountStorage readAccount];
    if ([commit.user_id integerValue] == account.user_id) {
        /** 只能删除自己的动态 */
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   commit.ID,@"id",
                                   nil];
        
        [AFNetWorkTool post:@"sheyun/deleteDynamic" params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                [weakSelf.view makeToast:@"操作成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
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
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    if (self.type == 3) {
        [self.mainTable registerClass:[FHZJHaveMoveCell class] forCellReuseIdentifier:NSStringFromClass([FHZJHaveMoveCell class])];
    }
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
        if (self.type == 3) {
            if (commit.medias.count > 0) {
                NSDictionary *dic = commit.medias[0];
                if ([dic[@"type"] integerValue]== 2) {
                    /** 视频Cell */
                    FHZJHaveMoveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHZJHaveMoveCell class])];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = self.dataArray[indexPath.row];
                    cell.delegate = self;
                    return cell;
                    
                } else if ([dic[@"type"] integerValue]== 1) {
                    /** 图片Cell */
                    ZJMasonryAutolayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kPicMasonryCell];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.weakSelf = self;
                    cell.delegate = self;
                    [self configureCell:cell atIndexPath:indexPath];
                    
                    return cell;
                }
            }
            /** 纯文字Cell */
            ZJNoHavePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:kNoPicMasonryCell];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self configureNoCell:photoCell atIndexPath:indexPath];
            photoCell.delegate = self;
            return photoCell;
        } else {
            if (commit.pic_urls > 0) {
                ZJMasonryAutolayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kPicMasonryCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.weakSelf = self;
                cell.delegate = self;
                [self configureCell:cell atIndexPath:indexPath];
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                return cell;
            } else {
                ZJNoHavePhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:kNoPicMasonryCell];
                photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                photoCell.delegate = self;
                [self configureNoCell:photoCell atIndexPath:indexPath];
                
                return photoCell;
            }
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
    if (indexPath.section == 0) {
        ZJCommit *commit = self.dataArray[indexPath.row];
        if (self.type == 3) {
            if (commit.medias.count > 0) {
                NSDictionary *dic = commit.medias[0];
                if ([dic[@"type"] integerValue]== 2) {
                    return [SingleManager shareManager].cellVideoHeight;
                } else if ([dic[@"type"] integerValue]== 1) {
                    return [SingleManager shareManager].cellPicHeight;
                }
            }
            return [SingleManager shareManager].cellNoPicHeight;
        } else {
            if (commit.pic_urls > 0) {
                return [SingleManager shareManager].cellPicHeight;
            } else {
                return  [SingleManager shareManager].cellNoPicHeight;
            }
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
    cell.model = self.dataArray[indexPath.row];
}

- (void)configureNoCell:(ZJNoHavePhotoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.dataArray[indexPath.row];
}

- (void)fh_creatBottomInputView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:topLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 100, 35)];
    label.text = @" 我来说两句。。。";
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.textColor = [UIColor lightGrayColor];
    label.layer.borderWidth = 1;
    label.font = [UIFont systemFontOfSize:15];
    label.userInteractionEnabled = YES;
    [bottomView addSubview:label];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.backgroundColor = HEX_COLOR(0x1296db);
    [pushBtn setTitle:@"发布" forState:0];
    pushBtn.enabled = NO;
    pushBtn.layer.cornerRadius = 5;
    pushBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    pushBtn.frame = CGRectMake(MaxX(label) + 15, 5, 75, 35);
    [bottomView addSubview:pushBtn];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInputView)];
    bottomView.userInteractionEnabled = YES;
    [bottomView addGestureRecognizer:tap];
}

- (void)fh_ZJMasonryAutolayoutCellDelegateWithModel:(ZJCommit *)model {
    /** 去用户的动态 */
    [self pushVCWithModel:model];
}

- (void)fh_ZJNoHavePhotoCellSelectModel:(ZJCommit *)model {
    [self pushVCWithModel:model];
}

- (void)fh_ZJHaveMoveCellDelagateSelectModel:(ZJCommit *)Model {
    [self pushVCWithModel:Model];
}

- (void)pushVCWithModel:(ZJCommit *)model {
    /** 去用户的动态 */
    FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
    vc.titleString = model.nickname;
    [SingleManager shareManager].isSelectPerson = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.user_id = model.user_id;
    vc.personType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fh_ZJHaveMoveCellDelagateSelectLikeWithModel:(ZJCommit *)Model {
    /** 用户点赞 */
//    [self getRequestLickWithModel:Model];
}

- (void)fh_ZJNoHavePhotoCellSelecLiketModel:(ZJCommit *)model {
    /** 用户点赞 */
//    [self getRequestLickWithModel:model];
}

- (void)fh_ZJMasonryAutolayoutCellDelegateSelectLikeWithModel:(ZJCommit *)model {
    /** 用户点赞 */
//    [self getRequestLickWithModel:model];
}

//- (void)getRequestLickWithModel:(ZJCommit *)model {
//    WS(weakSelf);
//    Account *account = [AccountStorage readAccount];
//    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @(account.user_id),@"user_id",
//                               @"1",@"type",
//                               model.ID,@"pid",
//                               @"user_id",@"uid",
//                               nil];
//    [AFNetWorkTool post:@"sheyun/circleLike" params:paramsDic success:^(id responseObj) {
//        if ([responseObj[@"code"] integerValue] == 1) {
//
//        } else {
//            [self.view makeToast:responseObj[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//    }];
//}

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
                                @"0",@"to_id",
                                @"1",@"type",
                                self.ID,@"pid",
                                text,@"content",
                                nil];
    
    self.commitDataArrs = [[NSMutableArray alloc] init];
    [AFNetWorkTool post:@"sheyun/circleComment" params:paramsDic success:^(id responseObj) {
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
