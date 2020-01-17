//
//  FHCommonVideosCollectionCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHServiceCommonHeaderView.h"
NS_ASSUME_NONNULL_BEGIN
@class FHVideosListModel;
@protocol FHCommonVideosCollectionCellDelegate <NSObject>

@optional // 可选实现的方法
- (void)refreshData;

- (void)FHCommonVideosCollectionCellDelegateSelectIndex:(NSIndexPath *)selectIndex;

- (void)fh_collectionCancleVideoSelectIndex:(NSIndexPath *)selectIndex model:(FHVideosListModel *)model;
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
/** type 1类型  2生鲜视频列表*/
@property (nonatomic, assign) NSInteger type;
/** 标头数据 */
@property (nonatomic, strong) FHServiceCommonHeaderView *tableHeaderView;
/** 视频列表collection */
@property (nonatomic, strong) UICollectionView *videoCollectionView;

@end

NS_ASSUME_NONNULL_END
