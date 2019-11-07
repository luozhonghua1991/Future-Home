//
//  FHCommonFollowAndPlacementCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FHCommonFollowModel;

@protocol FHCommonFollowAndPlacementCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
/** 点击头像的跳转事件 */
- (void)fh_selectAvaterWithModel:(FHCommonFollowModel *)followModle;
/** 选择是否取消关注或置顶 */
- (void)fh_selectMenuWithModel:(FHCommonFollowModel *)followModle;

@end

@interface FHCommonFollowAndPlacementCell : UITableViewCell

@property(nonatomic, weak) id<FHCommonFollowAndPlacementCellDelegate> delegate;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommonFollowModel *followModel;

@end

NS_ASSUME_NONNULL_END
