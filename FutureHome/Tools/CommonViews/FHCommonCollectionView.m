//
//  FHCommonCollectionView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  公用collectionView

#import "FHCommonCollectionView.h"
#import "FHCommonCollectionCell.h"

@interface FHCommonCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>
/** <#strong属性注释#> */
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

@implementation FHCommonCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.menuCollectionView];
}


#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHCommonCollectionCell class]) forIndexPath:indexPath];
    
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
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.116 * 2) collectionViewLayout:flowLayout];
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        [_menuCollectionView registerClass:[FHCommonCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FHCommonCollectionCell class])];
        _menuCollectionView.dataSource = self;
        _menuCollectionView.delegate = self;
        _menuCollectionView.scrollsToTop = NO;
        
    }
    return _menuCollectionView;
}

@end
