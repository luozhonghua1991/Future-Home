//
//  FHCommonVideosCollectionCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  通用视频cell

#import "FHCommonVideosCollectionCell.h"
#import "FHVideoListViewCell.h"
#import "FHServiceCommonHeaderView.h"
#import "FHVideosListModel.h"

@interface FHCommonVideosCollectionCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end

@implementation FHCommonVideosCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}


#pragma mark — privite
- (void)fh_setUpUI {
    [self addSubview:self.videoCollectionView];
}

- (void)setRowCount:(NSInteger)rowCount {
    _rowCount = rowCount;
    [self.videoCollectionView reloadData];
}

- (void)setVideoListArrs:(NSMutableArray *)videoListArrs {
    _videoListArrs = videoListArrs;
    [self.videoCollectionView reloadData];
    if (self.type == 2) {
        [self.videoCollectionView setContentOffset:CGPointMake(0, -140)];
    }
}

- (void)setShopID:(NSString *)shopID {
    _shopID = shopID;
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool get:@"shop/getSingShopInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            [weakSelf.tableHeaderView.headerImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"logo_img"]] placeholderImage:[UIImage imageNamed:@""]];
            weakSelf.tableHeaderView.shopNameLabel.text = dic[@"shopname"];
            weakSelf.tableHeaderView.codeLabel.text = [NSString stringWithFormat:@"社云账号: %@",dic[@"username"]];
            weakSelf.tableHeaderView.countLabel.text = [NSString stringWithFormat:@"视频: %@",dic[@"document"]];
            weakSelf.tableHeaderView.upCountLabel.text = [NSString stringWithFormat:@"点赞: %@",dic[@"like"]];
            weakSelf.tableHeaderView.fansLabel.text = [NSString stringWithFormat:@"粉丝: %@",dic[@"fins"]];
            weakSelf.videoCollectionView.contentInset = UIEdgeInsetsMake(140, 0, 0, 0);
            [weakSelf.videoCollectionView addSubview:weakSelf.tableHeaderView];
        } else {
        }
    } failure:^(NSError *error) {
        [weakSelf.videoCollectionView reloadData];
    }];
}

#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHVideoListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHVideoListViewCell class]) forIndexPath:indexPath];
    cell.videoListModel = self.videoListArrs[indexPath.item];
    if (self.type == 1) {
        /** 才有取消收藏功能 */
        //添加长按手势
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        
        longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
        [cell addGestureRecognizer:longPressGesture];
    }
    return cell;
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.videoCollectionView];
        NSIndexPath * indexPath = [self.videoCollectionView indexPathForItemAtPoint:location];
        FHVideosListModel *model = self.videoListArrs[indexPath.item];
        //可以得到此时你点击的哪一行
        if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_collectionCancleVideoSelectIndex:model:)]) {
            [_delegate fh_collectionCancleVideoSelectIndex:indexPath model:model];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHCommonVideosCollectionCellDelegateSelectIndex:)]) {
        [_delegate FHCommonVideosCollectionCellDelegateSelectIndex:indexPath];
    }
}

- (void)setCollectionViewHeight:(CGFloat)collectionViewHeight {
    _collectionViewHeight = collectionViewHeight;
    self.videoCollectionView.height = _collectionViewHeight;
    [self layoutSubviews];
}

#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *title = @"暂无相关数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:167/255.0 green:181/255.0 blue:194/255.0 alpha:1/1.0]
                                 };
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)getRequest {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refreshData)]) {
        [_delegate refreshData];
    }
}


#pragma mark — setter && getter
- (UICollectionView *)videoCollectionView {
    if (_videoCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing =  0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3 + 45);
        
        CGFloat tabbarHeight = KIsiPhoneX ? 83 : 49;
        _videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarHeight - 70) collectionViewLayout:flowLayout];
        _videoCollectionView.backgroundColor = [UIColor clearColor];
        _videoCollectionView.showsHorizontalScrollIndicator = NO;
        _videoCollectionView.showsVerticalScrollIndicator = NO;
        [_videoCollectionView registerClass:[FHVideoListViewCell class] forCellWithReuseIdentifier:NSStringFromClass([FHVideoListViewCell class])];
        _videoCollectionView.dataSource = self;
        _videoCollectionView.delegate = self;
        _videoCollectionView.scrollsToTop = NO;
        _videoCollectionView.emptyDataSetSource = self;
        _videoCollectionView.emptyDataSetDelegate = self;
        }
    return _videoCollectionView;
}

- (FHServiceCommonHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FHServiceCommonHeaderView alloc] initWithFrame:CGRectMake(0, -140, SCREEN_WIDTH, 140)];
    }
    return _tableHeaderView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
