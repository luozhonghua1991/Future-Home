//
//  FHCommonCollectionView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FHCommonCollectionViewDelegate <NSObject>

@optional // 可选实现的方法
- (void)FHCommonCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex;

@end

@interface FHCommonCollectionViewCell : UITableViewCell
/** 上面的logoName */
@property (nonatomic, copy) NSArray *topLogoNameArrs;
/** 下面的logoName */
@property (nonatomic, copy) NSArray *bottomLogoNameArrs;
/** 下面的image */
@property (nonatomic, copy) NSArray *bottomImageArrs;

@property(nonatomic, weak) id<FHCommonCollectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
