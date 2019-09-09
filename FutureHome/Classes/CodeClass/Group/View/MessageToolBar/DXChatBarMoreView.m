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

#import "DXChatBarMoreView.h"
#import "Header.h"

#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define CHAT_LITTLE_BUTTON_SIZE 65
#define INSETS 10
#define FontNeveLightWithSize(fontSize)     [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    
   self.backgroundColor = [UIColor clearColor];

    CGRect frame = self.frame;
    //单聊的更多界面
    if (type == ChatMoreTypeChat || type == ChatMoreTypeGroupChat) {
        frame.size.height = 150;
        self.backgroundColor = [UIColor clearColor];
        CGFloat insets = (self.frame.size.width - 4 * 54) / 5;
        _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(insets, 15, 54 , 90)];
        [_photoButton setImage:[UIImage imageNamed:@"tupian"] forState:UIControlStateNormal];
        [_photoButton setImage:[UIImage imageNamed:@"tupian"] forState:UIControlStateHighlighted];
        [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoButton];
        
        
      //群聊的更多界面
    }
	
    self.frame = frame;
}

#pragma mark - action
/**
 *  通知按钮方法
 */
- (void)noticeAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewNoticeAction:)]){
        [_delegate moreViewNoticeAction:self];
    }
}

/**
 *  图片按钮方法
 */
- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    } else{
        [_delegate moreViewPhotoAction:self];
    }
}
/**
 *  投票按钮方法
 */
- (void)ballotAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewballotAction:)]) {
        [_delegate moreViewballotAction:self];
    }
}
/**
 *  统计按钮方法
 */
- (void)countAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewCountAction:)]) {
        [_delegate moreViewCountAction:self];
    }
}
//
//- (void)takeVideoCallAction
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
//        [_delegate moreViewVideoCallAction:self];
//    }
//}
//
//- (void)videoAction
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(moreViewSendVideoAction:)]) {
//        [_delegate moreViewSendVideoAction:self];
//    }
//
//}

@end
