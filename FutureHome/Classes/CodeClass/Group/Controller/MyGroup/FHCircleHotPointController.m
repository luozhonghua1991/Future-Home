//
//  FHCircleHotPointController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  圈热点

#import "FHCircleHotPointController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZJMasonryAutolayoutCell.h"
#import "ZJCommit.h"

#define kMasonryCell @"kMasonryCell"

@interface FHCircleHotPointController () <UITableViewDelegate,UITableViewDataSource>

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
/** 用户头像imageView */
@property (nonatomic, strong) UIImageView *personHeaderImgView;
/** 姓名label */
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FHCircleHotPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllView];
    [self getCommitsData];
}

#pragma mark - 获取数据
- (void)getCommitsData {
    // 从CommitsData 文件加载数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MasonryCellData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *commitsList = [rootDict objectForKey:@"comments_list"];
    NSMutableArray *arrM = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in commitsList) {
            ZJCommit *commit = [ZJCommit commitWithDict:dictDict];
            [arrM addObject:commit];
        }
        self.dataArray = arrM;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTable reloadData];
        });
    });
    
}

-(void)setUpAllView {
    if (self.isHaveTabbar) {
         self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - MainSizeHeight - 70 - [self getTabbarHeight]) style:UITableViewStylePlain];
    } else {
        self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - MainSizeHeight - 35) style:UITableViewStylePlain];
    }
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.tableFooterView = [[UIView alloc]init];
    _mainTable.estimatedRowHeight = 100;
    // 必须先注册cell，否则会报错
    [_mainTable registerClass:[ZJMasonryAutolayoutCell class] forCellReuseIdentifier:kMasonryCell];
    [self.view addSubview:self.mainTable];
    if (self.isHaveHeaderView) {
        self.mainTable.tableHeaderView = self.headerView;
        self.mainTable.tableHeaderView.height = self.headerView.height;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJMasonryAutolayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kMasonryCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.weakSelf = self;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 计算缓存cell的高度
    return [self.mainTable fd_heightForCellWithIdentifier:kMasonryCell cacheByIndexPath:indexPath configuration:^(ZJMasonryAutolayoutCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
    
}

#pragma mark - 给cell赋值
- (void)configureCell:(ZJMasonryAutolayoutCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //    cell.fd_enforceFrameLayout = NO;
    cell.model = self.dataArray[indexPath.row];
}

- (void)updateBtnClcik {
    
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
        [_headerView addSubview:self.personHeaderImgView];
        [_headerView addSubview:self.nameLabel];
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UIImageView *)headerBgImgView {
    if (!_headerBgImgView) {
        _headerBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
        _headerBgImgView.image = [UIImage imageNamed:@"头像"];
        _headerBgImgView.userInteractionEnabled = YES;
    }
    return _headerBgImgView;
}

- (UILabel *)rulesLabel {
    if (!_rulesLabel) {
        _rulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 200, 13)];
        _rulesLabel.textAlignment = NSTextAlignmentLeft;
        _rulesLabel.text = @"超赞: 54.8W";
        _rulesLabel.font = [UIFont boldSystemFontOfSize:13];
        _rulesLabel.textColor = [UIColor whiteColor];
    }
    return _rulesLabel;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.rulesLabel) + 20, 200, 13)];
        _fansLabel.textAlignment = NSTextAlignmentLeft;
        _fansLabel.text = @"粉丝: 54.8W";
        _fansLabel.font = [UIFont boldSystemFontOfSize:13];
        _fansLabel.textColor = [UIColor whiteColor];
    }
    return _fansLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.fansLabel) + 20, 200, 13)];
        _followLabel.textAlignment = NSTextAlignmentLeft;
        _followLabel.text = @"超赞: 54.8W";
        _followLabel.font = [UIFont boldSystemFontOfSize:13];
        _followLabel.textColor = [UIColor whiteColor];
    }
    return _followLabel;
}

- (UILabel *)updateLabel {
    if (!_updateLabel) {
        _updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.followLabel) + 20, 200, 13)];
        _updateLabel.textAlignment = NSTextAlignmentLeft;
        _updateLabel.text = @"发布: 54.8W";
        _updateLabel.font = [UIFont boldSystemFontOfSize:13];
        _updateLabel.textColor = [UIColor whiteColor];
    }
    return _updateLabel;
}

- (UIButton *)updateBtn {
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.frame = CGRectMake(15, MaxY(self.updateLabel) + 25, 80, 25);
        [_updateBtn setTitle:@"+发布" forState:UIControlStateNormal];
        [_updateBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_updateBtn addTarget:self action:@selector(updateBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}

- (UIImageView *)personHeaderImgView {
    if (!_personHeaderImgView) {
        _personHeaderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, MaxY(self.headerBgImgView) - 25, 50, 50)];
        _personHeaderImgView.image = [UIImage imageNamed:@"头像"];
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
