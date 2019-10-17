//
//  ZMCusCommentListTableHeaderView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMCusCommentListTableHeaderView : UIView
@property (nonatomic, copy) void(^closeBtnBlock)(void);
/** 评论数 */
@property (nonatomic, assign) NSInteger commmentCount;

@end
