//
//  FHCommonCollectionView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  公用collectionView

#import "FHCommonCollectionViewCell.h"
#import "FHCommonCollectionCell.h"

@interface FHCommonCollectionViewCell () <UICollectionViewDataSource,UICollectionViewDelegate>
/** 菜单collectionView */
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

@implementation FHCommonCollectionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.menuCollectionView];
}


#pragma mark — collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bottomLogoNameArrs.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHCommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FHCommonCollectionCell class]) forIndexPath:indexPath];
    cell.listNameLabel.text = [NSString stringWithFormat:@"%@",self.bottomLogoNameArrs[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHCommonCollectionCellDelegateSelectIndex:)]) {
        [_delegate FHCommonCollectionCellDelegateSelectIndex:indexPath];
    }
}


#pragma mark — setter && getter
- (UICollectionView *)menuCollectionView {
    if (_menuCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing =  0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH * 0.43 / 2);
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.43) collectionViewLayout:flowLayout];
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
