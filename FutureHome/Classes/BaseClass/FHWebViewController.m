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
#import "UIView+ZFFrame.h"
#import "FHArticleDetailModel.h"
#import "ZMCusCommentView.h"
#import "ZFTableData.h"

@interface FHWebViewController ()
<
UIWebViewDelegate,
XYSJSExport
>

id setBeingRemoved(id self, SEL selector, ...);
id willBeRemoved(id self, SEL selector, ...);

/** <#Description#> */
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
/** <#Description#> */
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *likeBtn;
/** 点赞数 */
@property (nonatomic, strong) UILabel *likeCountLabel;

@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, strong) UIButton *commentBtn;
/** 评论数 */
@property (nonatomic, strong) UILabel *commentCountLabel;

@property (nonatomic, strong) UIButton *shareBtn;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHArticleDetailModel *articleModel;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *commentListArrs;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

@end

@implementation FHWebViewController

- (void)dealloc {
    _webView = nil;
    _webViewProgressView = nil;
    _webViewProgress = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    
    if (IsStringEmpty(self.titleString)) {
        if ([self.type isEqualToString:@"noShow"]) {
            self.titleString = @"广告";
        } else if ([self.type isEqualToString:@"adver"]) {
            self.titleString = @"平台协议";
        }
    }
    if ([self.type isEqualToString:@"noShow"]||[self.type isEqualToString:@"adver"]) {
        /** 不展示评论列表 */
        [self fetchNetworkData];
    } else {
        [self getArticleInfo];
    }
}


- (void)getArticleInfo {
    WS(weakSelf);
    /** 获取文章详情 */
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.article_type,@"type",
                               self.article_id,@"article_id",
                               nil];
    
    [AFNetWorkTool get:@"Article/getSingInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSString *titleString = responseObj[@"data"][@"title"];
            if (IsStringEmpty(titleString)) {
                [weakSelf.view makeToast:@"该文章已经删除"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf fetchNetworkData];
                weakSelf.articleModel = [FHArticleDetailModel mj_objectWithKeyValues:responseObj[@"data"]];
                /** 展示评论列表 */
                [self fh_creatCommentView];
                [self fh_layoutSubView];
                [weakSelf updateArticleDataWithModel:weakSelf.articleModel];
            }
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 更新文章详情数据 */
- (void)updateArticleDataWithModel:(FHArticleDetailModel *)articleModel {
    self.commentCountLabel.text = articleModel.comment_num;
    self.likeCountLabel.text = articleModel.like_num;
    if (articleModel.islike == 0) {
        /** 未点赞 */
        [self.likeBtn setImage:[UIImage imageNamed:@"点赞前 空心"] forState:UIControlStateNormal];
        self.likeBtn.tag = 0;
    } else if (articleModel.islike == 1) {
        /** 已经点赞 */
        [self.likeBtn setImage:[UIImage imageNamed:@"评论点赞后"] forState:UIControlStateNormal];
        self.likeBtn.tag = 1;
    }
    //是否收藏
    if (articleModel.iscollection == 0) {
        /** 未收藏 */
        [self.followBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        self.followBtn.tag = 0;
    } else if (articleModel.iscollection == 1) {
        /** 已收藏 */
        [self.followBtn setImage:[UIImage imageNamed:@"收藏后"] forState:UIControlStateNormal];
        self.followBtn.tag = 1;
    }
}

- (void)fh_creatCommentView {
    [self.view addSubview:self.likeBtn];
    [self.view addSubview:self.likeCountLabel];
    [self.view addSubview:self.commentBtn];
    [self.view addSubview:self.commentCountLabel];
    [self.view addSubview:self.followBtn];
    [self.view addSubview:self.shareBtn];
}

- (void)fh_layoutSubView {
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.view.zf_width;
    CGFloat min_view_h = self.view.zf_height;
    CGFloat margin = 30;
    
    min_w = 40;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
//    self.shareBtn.frame = CGRectMake(min_x, min_y - 120, min_w, min_h);
    self.shareBtn.frame = CGRectMake(min_x, min_y - 60, min_w, min_h);
    
    min_w = 40;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
//    self.followBtn.frame = CGRectMake(min_x, min_y - 180, min_w, min_h);
    self.followBtn.frame = CGRectMake(min_x, min_y - 120, min_w, min_h);
    
    min_w = CGRectGetWidth(self.followBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.followBtn.frame);
    min_y = CGRectGetMinY(self.followBtn.frame) - min_h - margin;
    self.commentBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.followBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.commentBtn.frame);
    min_y = CGRectGetMinY(self.commentBtn.frame) - min_h - margin;
    self.likeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.likeCountLabel.frame = CGRectMake(MinX(self.likeBtn), MaxY(self.likeBtn) + 8, self.likeBtn.frame.size.width, 15);
    self.commentCountLabel.frame = CGRectMake(MinX(self.commentBtn), MaxY(self.commentBtn) + 8, self.commentBtn.frame.size.width, 15);
}

- (void)initSubViews {
    [self.view addSubview:self.webView];
    
    /** 此处初始化webview，具体代码省略 **/
    
    //此处给webview增加容错方法
    [self webViewAddMethods];
}


/** 可能会引起调用私有api的错误 */
- (void)webViewAddMethods {
    //预防报错:WebActionDisablingCALayerDelegate    willBeRemoved
    Class class = NSClassFromString(@"WebActionDisablingCALayerDelegate");
    class_addMethod(class, NSSelectorFromString(@"setBeingRemoved"), setBeingRemoved, "v@:");
    class_addMethod(class, NSSelectorFromString(@"willBeRemoved"), willBeRemoved, "v@:");
    
    class_addMethod(class, NSSelectorFromString(@"removeFromSuperview"), willBeRemoved, "v@:");
}

id setBeingRemoved(id self, SEL selector, ...)
{
    return nil;
}

id willBeRemoved(id self, SEL selector, ...)
{
    return nil;
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
    [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.isHaveProgress) {
        //[self.navigationController.navigationBar addSubview:self.webViewProgressView];
    }
    [self fh_creatNav];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    [self.lodingHud hideAnimated:YES];
    self.lodingHud = nil;
    __weak typeof (self) weakSelf = self;
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"ios"] = weakSelf;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view makeToast:@"加载失败"];
    [self.lodingHud hideAnimated:YES];
    self.lodingHud = nil;
}

- (void)removeHTMLTtitle {
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
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
            goodList.titleString = @"企业商城";
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


#pragma mark — event
/** 评论 */
- (void)commentBtnClick {
    /** 评论列表 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.article_id,@"article_id",
                               self.article_type,@"type",
                               @(1),@"page",
                               @"20",@"limit",
                               nil];
    
    [AFNetWorkTool get:@"Article/getCommentlist" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.commentListArrs = [[NSMutableArray alloc] init];
            NSArray *arr = responseObj[@"data"][@"list"];
            [weakSelf.commentListArrs addObjectsFromArray:arr];
            /** 展示评论列表 */
            [[ZMCusCommentManager shareManager] showCommentWithArticleid:weakSelf.article_id dataArrs:weakSelf.commentListArrs articleType:weakSelf.article_type tpye:weakSelf.commentCountLabel.text];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 点赞 */
- (void)likeBtnClick:(UIButton *)likeBtn {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.article_type,@"type",
                               self.article_id,@"id",
                               nil];
    [AFNetWorkTool post:@"Article/doLike" params:paramsDic success:^(id responseObj) {
        NSInteger count = [self.likeCountLabel.text integerValue];
        if ([responseObj[@"code"] integerValue] == 1) {
            if (self.likeBtn.tag == 0) {
                /** 未点赞 */
                [self.likeBtn setImage:[UIImage imageNamed:@"评论点赞后"] forState:UIControlStateNormal];
                self.likeBtn.tag = 1;
                count ++;
                self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            } else if (self.likeBtn.tag == 1) {
                /** 已经点赞 */
                [self.likeBtn setImage:[UIImage imageNamed:@"点赞前 空心"] forState:UIControlStateNormal];
                self.likeBtn.tag = 0;
                count --;
                self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            }
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}

/** 公告收藏 */
- (void)followBtnClick:(UIButton *)followBtn {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.article_type,@"type",
                               self.article_id,@"id",
                               nil];
    [AFNetWorkTool post:@"public/articleCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (self.followBtn.tag == 0) {
                /** 未收藏 */
                [self.view makeToast:@"收藏成功"];
                [self.followBtn setImage:[UIImage imageNamed:@"收藏后"] forState:UIControlStateNormal];
                self.followBtn.tag = 1;
            } else if (self.followBtn.tag == 1) {
                /** 已经收藏 */
                [self.view makeToast:@"取消收藏成功"];
                [self.followBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                self.followBtn.tag = 0;
            }
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}

/** 公告转发 */
- (void)shareBtnClick {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.articleModel.cover,@"cover",
                         self.articleModel.title,@"title",
                         self.articleModel.path,@"path",
                         self.articleModel.writer,@"forwarder",
                         nil];
    FHSharingDynamicsController *vc = [[FHSharingDynamicsController alloc] init];
    vc.type = @"文章";
    vc.dataDic = dic;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Getters and Setters
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
//        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.delegate = self;
    }
    return _webView;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_likeBtn setImage:[UIImage imageNamed:@"点赞前 空心"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _likeBtn;
}

- (UILabel *)likeCountLabel {
    if (!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont boldSystemFontOfSize:15];
        _likeCountLabel.text = @"1";
        _likeCountLabel.textColor = [UIColor whiteColor];
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _likeCountLabel;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UILabel *)commentCountLabel {
    if (!_commentCountLabel) {
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.font = [UIFont boldSystemFontOfSize:15];
        _commentCountLabel.text = @"1";
        _commentCountLabel.textColor = [UIColor whiteColor];
        _commentCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _commentCountLabel;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_followBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (MBProgressHUD *)lodingHud {
    if (_lodingHud == nil) {
        _lodingHud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _lodingHud.mode = MBProgressHUDModeIndeterminate;
        _lodingHud.removeFromSuperViewOnHide = YES;
        _lodingHud.label.text = @"加载中...";
        [_lodingHud showAnimated:YES];
    }
    return _lodingHud;
}

@end
