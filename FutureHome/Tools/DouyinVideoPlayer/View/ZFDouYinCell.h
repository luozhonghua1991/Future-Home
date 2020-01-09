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
- (void)fh_ZFDouYinCellDelegateSelectLikeClicck:(ZFTableData *)data
                                        withBtn:(UIButton *)btn
                                 withCountLabel:(UILabel *)label;
/** 收藏视频的点击方法 */
- (void)fh_ZFDouYinCellDelegateSelectFollowClick:(ZFTableData *)data
                                         withBtn:(UIButton *)btn;
/** 分享视频的点击方法 */
- (void)fh_ZFDouYinCellDelegateShareClick:(ZFTableData *)data;

@end

@interface ZFDouYinCell : UITableViewCell

@property(nonatomic, weak) id<ZFDouYinCellDelegate> delegate;
@property (nonatomic, strong) UIButton *likeBtn;
/** 点赞数 */
@property (nonatomic, strong) UILabel *likeCountLabel;

@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, strong) ZFTableData *data;

@end
