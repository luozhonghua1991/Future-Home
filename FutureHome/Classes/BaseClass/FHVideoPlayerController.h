//
//  FHVideoPlayerController.h
//  SayU
//
//  Created by 性用社 on 16/11/16.
//  Copyright © 2016年 xys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FHVideoPlayerController : UIViewController
/** 播放视频的URL */
@property (nonatomic,copy)NSString  *URLString;
/** 播放视频的标题 */
@property(nonatomic,copy)NSString *titleStr;

@end
