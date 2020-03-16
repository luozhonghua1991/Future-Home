//
//  FHWebViewController.h
//  RWGame
//
//  Created by liuchao on 2017/7/25.
//  Copyright © 2017年 chao.liu. All rights reserved.
//  web 页面

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol XYSJSExport <JSExport>

JSExportAs(doshare, - (void)doShareWithPerson :(NSString *)person);
JSExportAs(AdventLink, - (void)AdventLinkWithPerson :(NSString *)person);

@end

@interface FHWebViewController : BaseViewController
/** 是否有进度条 */
@property (nonatomic, assign) BOOL isHaveProgress;
/**url链接*/
@property (nonatomic,copy) NSString *urlString;
/** 标题 */
@property (nonatomic, copy) NSString *titleString;
/**  */
@property (nonatomic, copy) NSString *typeString;

@property(nonatomic,strong)JSContext *context;

@end
