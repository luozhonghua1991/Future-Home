//
//  ZMCusCommentBottomView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMCusCommentBottomViewDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
/** 发送评论 */
- (void)fh_ZMCusCommentBottomViewDelegateSendCommentClick;

@end

@interface ZMCusCommentBottomView : UIView

@property (nonatomic, copy) void(^tapBtnBlock)(void);

@property(nonatomic, weak) id<ZMCusCommentBottomViewDelegate> delegate;

@end
