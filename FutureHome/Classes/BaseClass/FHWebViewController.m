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
#import "FHSharingDynamicsController.h"
#import "FHHomeServicesController.h"
#import "FHOwnerServiceController.h"
#import "FHPersonTrendsController.h"
#import "FHFreshMallController.h"

@interface FHWebViewController ()
<
UIWebViewDelegate,
XYSJSExport
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
    Account *account = [AccountStorage readAccount];
    NSString *webUrlString;
    if ([self.typeString isEqualToString:@"information"]) {
        webUrlString = self.urlString;
    } else {
        webUrlString = [NSString stringWithFormat:@"%@?userid=%ld",self.urlString,(long)account.user_id];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrlString]]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isHaveProgress) {
//         [self.navigationController.navigationBar addSubview:self.webViewProgressView];
    }
    [self fh_creatNav];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if (self.webViewProgressView) {
//        [self.webViewProgressView removeFromSuperview];
//    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0));
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    __weak typeof (self) weakSelf = self;
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"ios"] = weakSelf;
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


- (void)doShareWithPerson:(NSString *)person {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [self dictionaryWithJsonString:person];
        /** 文章转发 */
        FHSharingDynamicsController *vc = [[FHSharingDynamicsController alloc] init];
        vc.type = @"文章";
        vc.dataDic = dic;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)AdventLinkWithPerson :(NSString *)person {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [self dictionaryWithJsonString:person];
        /** 社云相关的二维码 */
        NSString *str = dic[@"type"];
        if (IsStringEmpty(str)) {
            [self.view makeToast:@"参数错误"];
            return;
        }
        NSInteger type = [dic[@"type"] integerValue];
        if (type == 0) {
            /** 用户 */
            Account *account = [AccountStorage readAccount];
            NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @(account.user_id),@"user_id",
                                       dic[@"businessId"],@"id",
                                       @(type),@"type", nil];
            [AFNetWorkTool get:@"future/getEntityById" params:paramsDic success:^(id responseObj) {
                NSDictionary *dic = responseObj[@"data"];
                FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
                vc.titleString = dic[@"name"];
                [SingleManager shareManager].isSelectPerson = YES;
                vc.hidesBottomBarWhenPushed = YES;
                vc.user_id = dic[@"businessId"];
                vc.personType = 0;
                [[CurrentViewController topViewController].navigationController pushViewController:vc animated:YES];
                
            } failure:^(NSError *error) {
            }];
        } else if (type == 1) {
            /** 物业 */
            FHHomeServicesController *home = [[FHHomeServicesController alloc]init];
            home.model = [FHCommonFollowModel new];
            [home setHomeSeverID:[dic[@"businessId"] integerValue] homeServerName:@""];
            home.hidesBottomBarWhenPushed = NO;
            [self.navigationController pushViewController:home animated:YES];
        } else if (type == 2) {
            /** 业委 */
            FHOwnerServiceController *home = [[FHOwnerServiceController alloc]init];
            home.model = [FHCommonFollowModel new];
            [home setHomeSeverID:[dic[@"businessId"] integerValue] homeServerName:@""];
            home.hidesBottomBarWhenPushed = NO;
            [self.navigationController pushViewController:home animated:YES];
        } else if (type == 3) {
            FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
            goodList.hidesBottomBarWhenPushed = YES;
            goodList.titleString = @"生鲜商城";
            goodList.shopID = dic[@"businessId"];
            [[CurrentViewController topViewController].navigationController pushViewController:goodList animated:YES];
        } else if (type == 4) {
            FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
            goodList.hidesBottomBarWhenPushed = YES;
            goodList.titleString = @"商业商城";
            goodList.shopID = dic[@"businessId"];
            [[CurrentViewController topViewController].navigationController pushViewController:goodList animated:YES];
        } else if (type == 5) {
            FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
            goodList.hidesBottomBarWhenPushed = YES;
            goodList.titleString = @"医药商城";
            goodList.shopID = dic[@"businessId"];
            [[CurrentViewController topViewController].navigationController pushViewController:goodList animated:YES];
        }
    });
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

#pragma mark - Getters and Setters

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.delegate = self;
    }
    return _webView;
}

@end
