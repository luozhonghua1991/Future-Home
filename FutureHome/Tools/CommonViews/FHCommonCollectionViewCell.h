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

@property(nonatomic, weak) id<FHCommonCollectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
