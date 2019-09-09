/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;
/**
 *  图片按钮
 */
@property (nonatomic, strong) UIButton *photoButton;
/**
 *  通知按钮
 */
@property (nonatomic, strong) UIButton *noticeButton;
/**
 *  投票按钮
 */
@property (nonatomic, strong) UIButton *ballotButton;
/**
 *  统计按钮
 */
@property (nonatomic, strong) UIButton *countButton;
//@property (nonatomic, strong) UIButton *audioCallButton;
//@property (nonatomic, strong) UIButton *videoCallButton;

- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
/**
 *  图片按钮的代理方法
 */
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
@optional
/**
 *  通知按钮的代理方法
 */
- (void)moreViewNoticeAction:(DXChatBarMoreView *)moreView;
/**
 *  投票按钮的代理方法
 */
- (void)moreViewballotAction:(DXChatBarMoreView *)moreView;
/**
 *  统计按钮的代理方法
 */
- (void)moreViewCountAction:(DXChatBarMoreView *)moreView;

@end
