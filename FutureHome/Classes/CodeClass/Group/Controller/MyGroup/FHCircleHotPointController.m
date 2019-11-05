//
//  FHCircleHotPointController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  云动态

#import "FHCircleHotPointController.h"
#import "ZJMasonryAutolayoutCell.h"
#import "ZJCommit.h"
#import "FHCommitDetailController.h"
#import "ZJNoHavePhotoCell.h"
#import "FHPersonTrendsController.h"
#import "FHZJHaveMoveCell.h"
#import "ZFDouYinViewController.h"

/** 没有图片的 */
#define kNoPicMasonryCell @"kNoPicMasonryCell"
/** 有图片的 */
#define kPicMasonryCell @"kPicMasonryCell"

@interface FHCircleHotPointController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDActionSheetDelegate,ZJNoHavePhotoCellDelegate,ZJMasonryAutolayoutCellDelegate,FHZJHaveMoveCellDelagate>

@property(nonatomic ,strong) UITableView *mainTable;

@property(nonatomic ,strong) NSMutableArray *dataArray;
/** 表头 */
@property (nonatomic, strong) UIView *headerView;
/** 背景表头 */
@property (nonatomic, strong) UIImageView *headerBgImgView;
/** 超赞label */
@property (nonatomic, strong) UILabel *rulesLabel;
/** 粉丝label */
@property (nonatomic, strong) UILabel *fansLabel;
/** 关注label */
@property (nonatomic, strong) UILabel *followLabel;
/** 发布label */
@property (nonatomic, strong) UILabel *updateLabel;

/** 发布动态的按钮 */
@property (nonatomic, strong) UIButton *updateBtn;
/** 关系按钮 */
@property (nonatomic, strong) UIButton *relationBtn;

/** 用户头像imageView */
@property (nonatomic, strong) UIImageView *personHeaderImgView;
/** 姓名label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 数据 */
@property (nonatomic, strong) NSArray *commitsListArrs;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *followMessage;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *videoListDataArrs;

@end

@implementation FHCircleHotPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllView];
    [self getCommitsData];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self getCommitsData];
//}

#pragma mark - 获取数据
- (void)getCommitsData {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    /** 朋友圈封面信息 */
    NSString *uid;
    NSDictionary *paramsDicy;
    NSDictionary *headerParamsDic;
    if (self.personType == 1) {
        /** 自己看自己 */
        uid = [NSString stringWithFormat:@"%ld",(long)account.user_id];
        paramsDicy= [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     @(account.user_id),@"uid",
                     nil];
        headerParamsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           @(account.user_id),@"user_id",
                           @(account.user_id),@"uid", nil];
        [self.updateBtn setTitle:@"+发布" forState:UIControlStateNormal];
        self.relationBtn.hidden = YES;
    } else if (self.personType == 0) {
        uid = self.personID;
        paramsDicy= [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     uid,@"uid",
                     nil];
        headerParamsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           @(account.user_id),@"user_id",
                           uid,@"uid", nil];
        [self.updateBtn setTitle:@"+对话" forState:UIControlStateNormal];
        self.relationBtn.hidden = NO;
    } else {
        paramsDicy= [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     nil];
        headerParamsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           @(account.user_id),@"user_id",
                           @(account.user_id),@"uid", nil];
        [self.updateBtn setTitle:@"+发布" forState:UIControlStateNormal];
        self.relationBtn.hidden = YES;
    }
    
    /** 朋友圈动态数据 */
    [AFNetWorkTool get:@"sheyun/friendCircle" params:paramsDicy success:^(id responseObj) {
        self.videoListDataArrs = [[NSMutableArray alloc]init];
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *Dic = responseObj[@"data"];
            NSArray *arr = Dic[@"list"];
            for (NSDictionary *dic  in arr) {
                NSArray *videoArr = dic[@"medias"];
                if (videoArr.count > 0) {
                    NSDictionary *videoDic = videoArr[0];
                    if ([videoDic[@"type"] integerValue] == 2) {
                        [self.videoListDataArrs addObject:videoDic];
                    }
                }
            }
            [weakSelf requestWithDontTaiDic:Dic];
            
            
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    /** 朋友圈头部数据 */
    [AFNetWorkTool get:@"sheyun/circleInfo" params:headerParamsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            [weakSelf.personHeaderImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"头像"]];
            [weakSelf.headerBgImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"circle_cover"]] placeholderImage:[UIImage imageNamed:@"头像"]];
            weakSelf.nameLabel.text = dic[@"nickname"];
            weakSelf.rulesLabel.text = [NSString stringWithFormat:@"点赞: %@",dic[@"praise_num"]];
            weakSelf.fansLabel.text = [NSString stringWithFormat:@"粉丝: %@",dic[@"fans_num"]];
            weakSelf.followLabel.text = [NSString stringWithFormat:@"关注: %@",dic[@"follow_num"]];
            weakSelf.updateLabel.text = [NSString stringWithFormat:@"发布: %@",dic[@"publish_num"]];
            if ([dic[@"is_follow"] integerValue] == 0) {
                [weakSelf.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
            } else if ([dic[@"is_follow"] integerValue] == 1) {
                [weakSelf.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
            } else if ([dic[@"is_follow"] integerValue] == 2) {
                [weakSelf.relationBtn setTitle:@"互为关注" forState:UIControlStateNormal];
            }
            [weakSelf.mainTable reloadData];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.mainTable reloadData];
    }];
    
}

- (void)requestWithDontTaiDic:(NSDictionary *)dic {
    NSArray *commitsList = [dic objectForKey:@"list"];
    self.commitsListArrs = commitsList;
    NSMutableArray *arrM = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in commitsList) {
            ZJCommit *commit = [ZJCommit commitWithDongtaiDict:dictDict];
            [arrM addObject:commit];
        }
        self.dataArray = arrM;
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.mainTable reloadData];
                [weakSelf.mainTable.mj_header endRefreshing];
                
            });
        });
    });
}

- (void)setUpAllView {
    if (self.isHaveTabbar) {
         self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - MainSizeHeight - 70 - [self getTabbarHeight]) style:UITableViewStylePlain];
    } else {
        self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - MainSizeHeight - 35) style:UITableViewStylePlain];
    }
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mainTable.tableFooterView = [[UIView alloc] init];
    self.mainTable.estimatedRowHeight = 100;
    // 必须先注册cell，否则会报错
    [_mainTable registerClass:[ZJMasonryAutolayoutCell class] forCellReuseIdentifier:kPicMasonryCell];
    [_mainTable registerClass:[ZJNoHavePhotoCell class] forCellReuseIdentifier:kNoPicMasonryCell];
    [_mainTable registerClass:[FHZJHaveMoveCell class] forCellReuseIdentifier:NSStringFromClass([FHZJHaveMoveCell class])];
    
    [self.view addSubview:self.mainTable];
    if (self.isHaveHeaderView) {
        self.mainTable.tableHeaderView = self.headerView;
        self.mainTable.tableHeaderView.height = self.headerView.height;
    }
    
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommitsData)];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJCommit *commit = self.dataArray[indexPath.row];
    //视频单独处理
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
        photoCell.delegate = self;
        [self configureNoCell:photoCell atIndexPath:indexPath];
        return photoCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJCommit *commit = self.dataArray[indexPath.row];
    if (commit.medias.count > 0) {
        NSDictionary *dic = commit.medias[0];
        if ([dic[@"type"] integerValue]== 2) {
            return [SingleManager shareManager].cellVideoHeight;
        } else if ([dic[@"type"] integerValue]== 1) {
            return [SingleManager shareManager].cellPicHeight;
        }
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

/** 点击视频的播放 */
- (void)fh_ZJHaveMoveCellDelagateSelectMovieModel:(ZJCommit *)Model {
    NSDictionary *dic = Model.medias[0];
    if ([self.videoListDataArrs containsObject:dic]) {
        NSInteger index = [self.videoListDataArrs indexOfObject:dic];
        ZFDouYinViewController *douyin = [[ZFDouYinViewController alloc] init];
        douyin.videoListDataArrs = self.videoListDataArrs;
        [douyin playTheIndex:index];
        douyin.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:douyin animated:YES];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZJCommit *model = self.dataArray[indexPath.row];
    FHCommitDetailController *vc = [[FHCommitDetailController alloc] init];
    vc.type = 3;
    vc.dongTaiDataDic = self.commitsListArrs[indexPath.row];
    vc.isCanCommit = NO;
    vc.ID = model.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateBtnClcik {
    if (self.personType == 0) {
        /** 聊天 */
        
    } else {
        /** 发布动态 */
        [self viewControllerPushOther:@"FHReleaseDynamicsController"];
    }
}


/**  切换关系的按钮点击事件 */
- (void)relationBtnClcik:(UIButton *)sender {
    
}

- (void)imgViewClick {
    /** 选取图片 */
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}


#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:
        {
            [self addCamera];
            break;
        }
        case 1:
        {
            [self addPhotoClick];
            break;
        }
        case 2:
        {
            ZHLog(@"取消");
            break;
        }
        default:
            
            break;
    }
}

//调用系统相机
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * cameraPicker = [[UIImagePickerController alloc]init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = NO;  //是否可编辑
        //摄像头
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

/**
 *  跳转相册页面
 */
- (void)addPhotoClick {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - <相册处理区域>
/**
 *  拍摄完成后要执行的方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    Account *account = [AccountStorage readAccount];
    NSArray *arr = @[@"111"];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               arr,@"cover",
                               nil];
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    [AFNetWorkTool updatePersonPYQBgImageWithUrl:@"sheyun/updateCover" parameter:paramsDic imageData:imageData success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [self getCommitsData];
            [picker dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618 + 40)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.headerBgImgView];
        [_headerView addSubview:self.rulesLabel];
        [_headerView addSubview:self.fansLabel];
        [_headerView addSubview:self.followLabel];
        [_headerView addSubview:self.updateLabel];
        [_headerView addSubview:self.updateBtn];
        [_headerView addSubview:self.relationBtn];
        [_headerView addSubview:self.personHeaderImgView];
        [_headerView addSubview:self.nameLabel];
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UIImageView *)headerBgImgView {
    if (!_headerBgImgView) {
        _headerBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
        _headerBgImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewClick)];
        [_headerBgImgView addGestureRecognizer:tap];
    }
    return _headerBgImgView;
}

- (UILabel *)rulesLabel {
    if (!_rulesLabel) {
        _rulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 200, 13)];
        _rulesLabel.textAlignment = NSTextAlignmentLeft;
        _rulesLabel.text = @"超赞: 54.8W";
        _rulesLabel.font = [UIFont boldSystemFontOfSize:16];
        _rulesLabel.textColor = [UIColor whiteColor];
    }
    return _rulesLabel;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.rulesLabel) + 20, 200, 13)];
        _fansLabel.textAlignment = NSTextAlignmentLeft;
        _fansLabel.text = @"粉丝: 54.8W";
        _fansLabel.font = [UIFont boldSystemFontOfSize:16];
        _fansLabel.textColor = [UIColor whiteColor];
    }
    return _fansLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.fansLabel) + 20, 200, 13)];
        _followLabel.textAlignment = NSTextAlignmentLeft;
        _followLabel.text = @"超赞: 54.8W";
        _followLabel.font = [UIFont boldSystemFontOfSize:16];
        _followLabel.textColor = [UIColor whiteColor];
    }
    return _followLabel;
}

- (UILabel *)updateLabel {
    if (!_updateLabel) {
        _updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.followLabel) + 20, 200, 13)];
        _updateLabel.textAlignment = NSTextAlignmentLeft;
        _updateLabel.text = @"发布: 54.8W";
        _updateLabel.font = [UIFont boldSystemFontOfSize:16];
        _updateLabel.textColor = [UIColor whiteColor];
    }
    return _updateLabel;
}

- (UIButton *)updateBtn {
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.frame = CGRectMake(15, MaxY(self.updateLabel) + 25, 80, 25);
        [_updateBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_updateBtn addTarget:self action:@selector(updateBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}

- (UIButton *)relationBtn {
    if (!_relationBtn) {
        _relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _relationBtn.frame = CGRectMake(MaxX(_updateBtn) + 10, MaxY(self.updateLabel) + 25, 80, 25);
        [_relationBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        [_relationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_relationBtn addTarget:self action:@selector(relationBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _relationBtn;
}

- (UIImageView *)personHeaderImgView {
    if (!_personHeaderImgView) {
        _personHeaderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, MaxY(self.headerBgImgView) - 25, 50, 50)];
        _personHeaderImgView.userInteractionEnabled = YES;
        _personHeaderImgView.layer.cornerRadius = 10;
        _personHeaderImgView.layer.masksToBounds = YES;
        _personHeaderImgView.clipsToBounds = YES;
    }
    return _personHeaderImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.headerBgImgView) - 20, SCREEN_WIDTH - 70, 13)];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.text = @"许大宝~";
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

@end
