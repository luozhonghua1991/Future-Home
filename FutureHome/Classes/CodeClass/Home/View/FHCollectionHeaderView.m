//
//  FHCollectionHeaderView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  表头collectionView

#import "FHCollectionHeaderView.h"
#import "FHheadercCollectioCell.h"

@interface FHCollectionHeaderView () <UICollectionViewDataSource,UICollectionViewDelegate>
/** 告示 */
@property (nonatomic, strong) UICollectionView *headercCollectionView;
/** 个数 */
@property (nonatomic, assign) NSInteger numberCount;


@end

@implementation FHCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame numberCount:(NSInteger)numberCount {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberCount = numberCount;
        [self fh_installUI];
    }
    return self;
}


- (void)fh_installUI {
    [self addSubview:self.headercCollectionView];
}

- (void)layoutSubviews {
    
}


#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberCount;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHheadercCollectioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHheadercCollectioCell class]) forIndexPath:indexPath];
    cell.numberCount = self.numberCount;
    if (self.leftNameArrs.count > 0) {
        cell.leftLabel.text = [NSString stringWithFormat:@"%@",self.leftNameArrs[indexPath.item]];
    }
    if (self.rightNameArrs.count > 0) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.rightNameArrs[indexPath.item]];
    }
    return cell;
}


#pragma mark — setter && getter
- (UICollectionView *)headercCollectionView {
    if (_headercCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing =  0;
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 1, 60);
        
        _headercCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30 * self.numberCount) collectionViewLayout:flowLayout];
        _headercCollectionView.backgroundColor = [UIColor clearColor];
        _headercCollectionView.showsHorizontalScrollIndicator = NO;
        _headercCollectionView.showsVerticalScrollIndicator = NO;
        [_headercCollectionView registerClass:[FHheadercCollectioCell class] forCellWithReuseIdentifier:NSStringFromClass([FHheadercCollectioCell class])];
        _headercCollectionView.dataSource = self;
        _headercCollectionView.delegate = self;
        _headercCollectionView.scrollsToTop = NO;
        _headercCollectionView.userInteractionEnabled = NO;
    }
    return _headercCollectionView;
}

@end
