//
//  FHMenuListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/25.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMenuListCell.h"
#import "FHMenuListCollectionCell.h"

@interface FHMenuListCell() <UICollectionViewDataSource,UICollectionViewDelegate>
/** 菜单列表collection */
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

@implementation FHMenuListCell

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
    return 6;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHMenuListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHMenuListCollectionCell class]) forIndexPath:indexPath];
    
    return cell;
}

#pragma mark — setter && getter
- (UICollectionView *)menuCollectionView {
    if (_menuCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing =  0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH * 0.43 / 2);
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.43) collectionViewLayout:flowLayout];
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        [_menuCollectionView registerClass:[FHMenuListCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FHMenuListCollectionCell class])];
        _menuCollectionView.dataSource = self;
        _menuCollectionView.delegate = self;
        _menuCollectionView.scrollsToTop = NO;
        
    }
    return _menuCollectionView;
}

@end
