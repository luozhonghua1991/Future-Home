//
//  FHLittleMenuListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHLittleMenuListCell.h"
#import "FHLittleMenuListCollectionCell.h"

@interface FHLittleMenuListCell() <UICollectionViewDataSource,UICollectionViewDelegate>
/** 菜单列表collection */
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

@implementation FHLittleMenuListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}


#pragma mark — privite
- (void)fh_setUpUI {
    [self addSubview:self.menuCollectionView];
}


#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHLittleMenuListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHLittleMenuListCollectionCell class]) forIndexPath:indexPath];

    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHMenuListCellSelectIndex:)]) {
//        [_delegate FHMenuListCellSelectIndex:indexPath];
//    }
//}


#pragma mark — setter && getter
- (UICollectionView *)menuCollectionView {
    if (_menuCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing =  0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH * 0.116);
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.43) collectionViewLayout:flowLayout];
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        [_menuCollectionView registerClass:[FHLittleMenuListCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FHLittleMenuListCollectionCell class])];
        _menuCollectionView.dataSource = self;
        _menuCollectionView.delegate = self;
        _menuCollectionView.scrollsToTop = NO;
        
    }
    return _menuCollectionView;
}


@end
