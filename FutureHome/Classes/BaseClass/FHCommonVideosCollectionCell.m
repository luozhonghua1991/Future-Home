//
//  FHCommonVideosCollectionCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  通用视频cell

#import "FHCommonVideosCollectionCell.h"
#import "FHVideoListViewCell.h"


@interface FHCommonVideosCollectionCell () <UICollectionViewDataSource,UICollectionViewDelegate>
/** 视频列表collection */
@property (nonatomic, strong) UICollectionView *videoCollectionView;

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
}

#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowCount;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHVideoListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHVideoListViewCell class]) forIndexPath:indexPath];
    cell.videoListModel = self.videoListArrs[indexPath.item];
    return cell;
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
    }
    return _videoCollectionView;
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
