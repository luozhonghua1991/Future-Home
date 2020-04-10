//
//  ZJMasonryAutolayoutCell.h
//  ZJUIKit
//
//  Created by dzj on 2018/1/26.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCommit;
@protocol ZJMasonryAutolayoutCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional
// 可选实现的方法
- (void)fh_ZJMasonryAutolayoutCellDelegateWithModel:(ZJCommit *)model;
/** 朋友圈点赞 */
- (void)fh_ZJMasonryAutolayoutCellDelegateSelectLikeWithModel:(ZJCommit *)model;

@end

@interface ZJMasonryAutolayoutCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;

/** 没有点赞按钮 */
@property (nonatomic, assign) BOOL isNoUpdateBtn;

@property(nonatomic ,weak) UIViewController      *weakSelf;

@property(nonatomic, weak) id<ZJMasonryAutolayoutCellDelegate> delegate;

@end
