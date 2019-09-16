//
//  FHWebViewController.m
//  RWGame
//
//  Created by liuchao on 2017/7/25.
//  Copyright © 2017年 chao.liu. All rights reserved.
//  通用的web界面 带进度条的

#import "FHWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface FHWebViewController ()
<
UIWebViewDelegate,
NJKWebViewProgressDelegate
>

/** <#Description#> */
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
/** <#Description#> */
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation FHWebViewController

- (void)dealloc
{
    _webViewProgressView = nil;
    _webViewProgress = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self fetchNetworkData];
}

- (void)initSubViews {
    [self.view addSubview:self.webView];
}

- (void)fetchNetworkData {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isHaveProgress) {
         [self.navigationController.navigationBar addSubview:self.webViewProgressView];
    }
    [self fh_creatNav];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.webViewProgressView) {
        [self.webViewProgressView removeFromSuperview];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0));
    }];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('sn-ibar-toggle')[0].style.display = 'none'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('sn-ibar-toggle').style.display = 'none'"];
    
    [self removeHTMLTtitle];
}

- (void)removeHTMLTtitle
{
    NSString *jsStr =
    @"if (document.getElementsByClassName('header-nav').length > 0) {"
    "    document.getElementsByClassName('header-nav')[0].style.display='none';"
    "}"
    "if (document.getElementsByClassName('sn-nav sn-block').length > 0) {"
    "    document.getElementsByClassName('sn-nav sn-block')[0].style.display='none';"
    "}"
    "if (document.getElementsByClassName('fb-top').length > 0) {"
    "    document.getElementsByClassName('fb-top')[0].style.display='none';"
    "}"
    "if (document.getElementsByTagName('header').length > 0) {"
    "    document.getElementsByTagName('header')[0].style.display='none';"
    "}"
    "if (document.title.length <= 0) {"
    "    var tagsObj = document.getElementsByTagName('div');"
    "    for (var i in tagsObj) {"
    "        if (tagsObj[i].className == 'sn-nav-title of') {"
    "            window.stub.jsMethod(tagsObj[i].innerHTML);"
    "        }"
    "    }"
    "}";
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Event Response
- (void)onNavLeftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Getters and Setters
- (NJKWebViewProgressView *)webViewProgressView {
    if (_webViewProgressView == nil) {
        _webViewProgressView = [[NJKWebViewProgressView alloc] init];
        
        CGRect navBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0,navBounds.size.height - 2,navBounds.size.width,2);
        _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_webViewProgressView setProgress:0 animated:YES];
    }
    return _webViewProgressView;
}
- (NJKWebViewProgress *)webViewProgress {
    if (_webViewProgress == nil) {
        _webViewProgress = [[NJKWebViewProgress alloc] init];
        _webViewProgress.webViewProxyDelegate = self;
        _webViewProgress.progressDelegate = self;
        
        self.webView.delegate = _webViewProgress;
    }
    return _webViewProgress;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return _webView;
}

@end
