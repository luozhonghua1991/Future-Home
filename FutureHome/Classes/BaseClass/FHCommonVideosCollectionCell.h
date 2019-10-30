//
//  FHCommonVideosCollectionCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FHCommonVideosCollectionCellDelegate <NSObject>

@optional // 可选实现的方法
- (void)FHCommonVideosCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex;

@end

@interface FHCommonVideosCollectionCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *videoListArrs;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger rowCount;

@property(nonatomic, weak) id<FHCommonVideosCollectionCellDelegate> delegate;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat collectionViewHeight;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *shopID;

@end

NS_ASSUME_NONNULL_END
