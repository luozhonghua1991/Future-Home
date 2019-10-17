//
//  ZMCusCommentListView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMCusCommentBottomView.h"
#import "ZMCusCommentListTableHeaderView.h"
#import "FHCommentListModel.h"

#define ZMCusCommentViewTopHeight  SCREEN_HEIGHT * 2 / 5
#define ZMCusComentBottomViewHeight 55

@protocol ZMCusCommentListViewDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法

- (void)fh_ZMCusCommentListViewDelegateSelectComment:(FHCommentListModel *)commentModel;

@end

@interface ZMCusCommentListView : UIView
@property (nonatomic, copy) void(^closeBtnBlock)(void);
@property (nonatomic, copy) void(^tapBtnBlock)(void);
@property (nonatomic, copy) void(^replyBtnBlock)(void);
/** 评论数据 */
@property (nonatomic, strong) NSMutableArray *commentListDataArrs;
@property (nonatomic, strong) ZMCusCommentListTableHeaderView *headerView;
@property (nonatomic, strong) ZMCusCommentBottomView *bottomView;
/** 评论数 */
@property (nonatomic, assign) NSInteger commmentCount;
/** 视频TopicID */
@property (nonatomic, copy) NSString *videoTopicId;

@property(nonatomic, weak) id<ZMCusCommentListViewDelegate> delegate;

@end

