//
//  FHWebViewController.h
//  RWGame
//
//  Created by liuchao on 2017/7/25.
//  Copyright © 2017年 chao.liu. All rights reserved.
//  web 页面

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FHTableData.h"

@protocol XYSJSExport <JSExport>

JSExportAs(doshare, - (void)doShareWithPerson :(NSString *)person);
JSExportAs(AdventLink, - (void)AdventLinkWithPerson :(NSString *)person);

@end


@protocol FHWebViewControllerDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法

///** 查看评论的点击方法 */
//- (void)fh_FHWebViewControllerDelegateSelectCommontent:(FHTableData *)data;
///** 喜欢视频的点击方法 */
//- (void)fh_FHWebViewControllerDelegateSelectLikeClicck:(FHTableData *)data
//                                        withBtn:(UIButton *)btn
//                                 withCountLabel:(UILabel *)label;
///** 收藏视频的点击方法 */
//- (void)fh_FHWebViewControllerDelegateSelectFollowClick:(FHTableData *)data
//                                         withBtn:(UIButton *)btn;
///** 分享视频的点击方法 */
//- (void)fh_FHWebViewControllerDelegateShareClick:(FHTableData *)data;

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
/** noShow就是不要显示带评论的功能  其他都带*/
@property (nonatomic, copy) NSString *type;

@property(nonatomic, weak) id<FHWebViewControllerDelegate> delegate;

@property (nonatomic, strong) FHTableData *data;

/** article_type 文章类型 */
@property (nonatomic, copy) NSString *article_type;
/** article_type 文章id */
@property (nonatomic, copy) NSString *article_id;

@end
