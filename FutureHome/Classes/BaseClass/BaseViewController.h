//
//  BaseViewController.h
//  WMPlayer
//
//  Created by 郑文明 on 16/3/15.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHCommonNavView.h"

@interface BaseViewController : UIViewController 
/**
 用了自定义的手势返回，则系统的手势返回屏蔽
 不用自定义的手势返回，则系统的手势返回启用
 */
@property (nonatomic, assign) BOOL enablePanGesture;//是否支持自定义拖动pop手势，默认yes,支持手势
/** 是否需要导航View */
@property (nonatomic, assign) BOOL isHaveNav;

@property (nonatomic,retain) MBProgressHUD* hud;
- (void)addHud;
- (void)addHudWithMessage:(NSString*)message;
- (void)removeHud;

/**获取tabbar的高度*/
- (CGFloat)getTabbarHeight;
/** 搜索事件 */
- (void)searchClick;
/** 收藏事件 */
- (void)collectClick;

@end
