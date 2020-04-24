//
//  LTWKWebView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/4/21.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "LTWKWebView.h"

@implementation LTWKWebView

static LTWKWebView * _shareTools= nil;

+(instancetype)ShareWKWebView {
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        _shareTools = [[super allocWithZone:NULL] init] ;
        
        _shareTools.config = [[WKWebViewConfiguration alloc] init];
        
        _shareTools.webV = [[WKWebView alloc] initWithFrame:_shareTools.bounds configuration:_shareTools.config];
        
        _shareTools.webV.scrollView.scrollEnabled = false;
        
        _shareTools.webV.scrollView.showsVerticalScrollIndicator =false;
        
        _shareTools.webV.UIDelegate =_shareTools;
        
        _shareTools.webV.navigationDelegate = _shareTools;
        
        [_shareTools addSubview:_shareTools.webV];
        
        [_shareTools.webV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.top.equalTo(_shareTools).offset(6);
            
            make.trailing.bottom.equalTo(_shareTools).offset(-6);
            
        }];
        
    });
    
    return _shareTools;
    
}

+(id)allocWithZone:(struct _NSZone *)zone {
    return [LTWKWebView ShareWKWebView] ;
}

-(id) copyWithZone:(NSZone *)zone {
    
    return [LTWKWebView ShareWKWebView] ;
}

-(id) mutablecopyWithZone:(NSZone *)zone

{
    
    return [LTWKWebView ShareWKWebView] ;
    
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation

{
    
//    [[LTWKWebView ShareWKWebView] remindWaiting];
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation

{
    
    __block CGFloat webViewHeight;
    
//    [[LTWKWebView ShareWKWebView] dismissReminder];
    
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
        
        //获取页面高度，并重置webview的frame
        
        webViewHeight = [result doubleValue];
        
        webView.height = webViewHeight;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommunityDetailWebHeight" object:@(webViewHeight)];
        
    }];
    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error

{
    
//    [[LTWKWebView ShareWKWebView] dismissReminder];
    
}

@end
