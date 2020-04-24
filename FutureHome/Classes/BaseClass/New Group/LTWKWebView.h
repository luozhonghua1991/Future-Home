//
//  LTWKWebView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2020/4/21.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTWKWebView : UIView <WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)WKWebView *webV;

@property(nonatomic,strong)WKWebViewConfiguration * config;

+(instancetype)ShareWKWebView;

@end

NS_ASSUME_NONNULL_END
