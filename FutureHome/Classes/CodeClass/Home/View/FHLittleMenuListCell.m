//
//  FHLittleMenuListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHLittleMenuListCell.h"
#import "FHLittleMenuListCollectionCell.h"
#import "FHScanCodeController.h"

@interface FHLittleMenuListCell() <UICollectionViewDataSource,UICollectionViewDelegate>
/** 菜单列表collection */
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

@implementation FHLittleMenuListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
        self.topLogoNameArrs = @[@"扫一扫",
                                 @"付款",
                                 @"收款",
                                 @"生活缴费",
                                 @"财富园"];
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
    cell.listNameLabel.text = [NSString stringWithFormat:@"%@",self.topLogoNameArrs[indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_delegate != nil && [_delegate respondsToSelector:@selector(FHLittleMenuListCellSelectIndex:)]) {
//        [_delegate FHLittleMenuListCellSelectIndex:indexPath];
//    }
    if (indexPath.row == 0) {
        /** 扫一扫 */
        [self pushVCWithName:@"FHScanCodeController"];
    } else if (indexPath.row == 1) {
        /** 付款 */
        [self pushVCWithName:@"FHPayController"];
    } else if (indexPath.row == 2) {
        /** 收款 */
        [self pushVCWithName:@"FHReceivablesController"];
    } else if (indexPath.row == 3) {
        /** 生活缴费 */
        [self pushVCWithName:@"FHLivingExpensesController"];
    } else if (indexPath.row == 4) {
        /** 财富园 */
        [self pushVCWithName:@"FHWealthGardenController"];
    }
}

- (void)pushVCWithName:(NSString *)nameVC {
    UIViewController *vc = [[NSClassFromString(nameVC) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [[CurrentViewController topViewController].navigationController pushViewController:vc animated:YES];
}


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
