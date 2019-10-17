//
//  ZFDouYinCell.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableData.h"



@protocol ZFDouYinCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法

/** 查看评论的点击方法 */
- (void)fh_ZFDouYinCellDelegateSelectCommontent:(ZFTableData *)data;
/** 喜欢视频的点击方法 */
- (void)fh_ZFDouYinCellDelegateSelectLikeClicck:(ZFTableData *)data;
/** 收藏视频的点击方法 */
- (void)fh_ZFDouYinCellDelegateSelectFollowClick:(ZFTableData *)data;

@end

@interface ZFDouYinCell : UITableViewCell

@property(nonatomic, weak) id<ZFDouYinCellDelegate> delegate;


@property (nonatomic, strong) ZFTableData *data;

@end
