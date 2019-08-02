//
//  FHWebViewController.h
//  RWGame
//
//  Created by liuchao on 2017/7/25.
//  Copyright © 2017年 chao.liu. All rights reserved.
//  web 页面

#import "BaseViewController.h"

@interface FHWebViewController : BaseViewController
/** 是否有进度条 */
@property (nonatomic, assign) BOOL isHaveProgress;
/**url链接*/
@property (nonatomic,copy) NSString *urlString;

@end
