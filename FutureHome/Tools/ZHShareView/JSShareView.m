//
//  JSShareView.m
//  JSShareView
//
//  Created by 乔同新 on 16/6/7.
//  Copyright © 2016年 乔同新. All rights reserved.
//
#import "JSShareView.h"
#import "JSShareItemButton.h"
//#import <ShareSDK/ShareSDK.h>
#import "UIView+YYAdd.h"
#import "FHAppDelegate.h"

//背景色
#define SHARE_BG_COLOR                        XNColor(239, 240, 241, 1)
//高
#define SHARE_BG_HEIGHT                       ZH_SCALE_SCREEN_Height(280)
//
#define SHARE_SCROLLVIEW_HEIGHT               (SHARE_BG_HEIGHT- 50 - 17)/2
//item宽
#define SHARE_ITEM_WIDTH                      XNWindowWidth*0.15
//左间距
#define SHARE_ITEM_SPACE_LEFT                  ZH_SCALE_SCREEN_Width(24)
//间距
#define SHARE_ITEM_SPACE                       ZH_SCALE_SCREEN_Width(24)
//第一行 item  base tag
#define ROW1BUTTON_TAG                        1000
//第二行 item base tag
#define ROW2BUTTON_TAG                        600
//item base tag
#define BUTTON_TAG                            700
//背景view tag
#define BG_TAG                                1234

#define XNColor(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define XNWindowWidth        ([[UIScreen mainScreen] bounds].size.width)

#define XNWindowHeight       ([[UIScreen mainScreen] bounds].size.height)

#define XNFont(font)         [UIFont systemFontOfSize:(font)]

#define XNWidth_Scale        [UIScreen mainScreen].bounds.size.width/375.0f
@interface JSShareView ()
{
    NSMutableArray *_ButtonTypeShareArray1;
    NSMutableArray *_ButtonTypeShareArray2;
    BOOL _report;//判断是否需要举报来改变原本举报按钮功能；
    BOOL _isLocalIMage;
    NSString *_type;
}
@end

@implementation JSShareView
/**
 *  分享
 *
 *  @param content     内容
 *  @param resultBlock 结果
 */
+ (JSShareView *)showShareViewWithPublishContent:(NSDictionary *)content
                                         DataArray:(NSArray *)dataArray
                                      TypeArray1:(NSArray *)typeArray1
                                      TypeArray2:(NSArray *)typeArray2
                                    IsShowReport:(BOOL)isShowReport
                                    isLocalImage:(BOOL)isLocalImage
                                     addViewType:(NSString *)viewType
                                          Result:(ShareResultBlock)resultBlock{
    JSShareView *shareView =[[JSShareView alloc]init];
    shareView.publishContent = content;
    shareView.dataArray = dataArray;
    shareView.typeArray1 = typeArray1;
    shareView.typeArray2 = typeArray2;
    shareView.ShareResultBlock = resultBlock;
    [shareView setupWithIsShowReport:isShowReport IsLocalImage:isLocalImage addViewTypr:viewType];
    
    return shareView;
}
- (void)setupWithIsShowReport:(BOOL)isShowReport IsLocalImage:(BOOL)isLocalImage addViewTypr:(NSString *)viewType{
    _report = isShowReport;
    _isLocalIMage = isLocalImage;
    [self initData];
    [self initShareUIWithType:viewType];
    _type = viewType;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)initData{
    _ButtonTypeShareArray1 = [NSMutableArray array];
    _ButtonTypeShareArray2 = [NSMutableArray array];
}

/**
 *  初始化视图
 */
- (void)initShareUIWithType:(NSString *)viewType{
    CGRect orginRect = CGRectMake(0, XNWindowHeight, XNWindowWidth, ZH_SCALE_SCREEN_Height(280));
    CGRect finaRect = orginRect;
    finaRect.origin.y =  XNWindowHeight - SHARE_BG_HEIGHT;
    /***************************** 添加底层bgView ********************************************/
    UIWindow *window;
    if ([viewType isEqualToString:@"game"]) {
        FHAppDelegate *deleage = (FHAppDelegate *)[UIApplication sharedApplication].delegate;
    } else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    window.backgroundColor =[UIColor clearColor];
//    self.backgroundColor =[UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XNWindowWidth, XNWindowHeight)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = BG_TAG;
    bgView.alpha = 0.3f;
    [window addSubview:bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
    [bgView addGestureRecognizer:tap1];
    /***************************** 添加分享shareBGView ***************************************/
    UIVisualEffectView *shareBGView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    shareBGView.frame = orginRect;
    shareBGView.userInteractionEnabled = YES;
    shareBGView.backgroundColor = COLOR_23;
    shareBGView.tag = 10000123;
    [window addSubview:shareBGView];
    
    UILabel *shareLabel =[[UILabel alloc]init];
    shareLabel.text = @"分享到";
    shareLabel.textColor =COLOR_1;
    shareLabel.textAlignment  = NSTextAlignmentCenter;
    shareLabel.font =[UIFont systemFontOfSize:ZH_SCALE_SCREEN_Height(15)];
    shareLabel.frame =CGRectMake(0, ZH_SCALE_SCREEN_Height(11), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(17));
    [shareBGView addSubview:shareLabel];
    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(tapNoe)];
//    [shareBGView addGestureRecognizer:tap2];
    /****************************** 添加item ************************************************/
    for (int i = 0; i<_dataArray.count; i++) {
        
        UIScrollView *rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, i*(SHARE_SCROLLVIEW_HEIGHT+0.5) + CGRectGetMaxY(shareLabel.frame), shareBGView.width, SHARE_SCROLLVIEW_HEIGHT)];
        rowScrollView.directionalLockEnabled = YES;
        rowScrollView.showsVerticalScrollIndicator = NO;
        rowScrollView.showsHorizontalScrollIndicator = NO;
        rowScrollView.backgroundColor = [UIColor clearColor];
        [shareBGView addSubview:rowScrollView];
        
        /* add item */
        NSArray *itemArray = _dataArray[i][@(i)];
        rowScrollView.contentSize = CGSizeMake((SHARE_ITEM_WIDTH+ SHARE_ITEM_SPACE_LEFT+SHARE_ITEM_SPACE)*itemArray.count, SHARE_SCROLLVIEW_HEIGHT);
        //按钮数组
        for (NSDictionary *itemDict in itemArray) {
            NSInteger index           = [itemArray indexOfObject:itemDict];
            JSShareItemButton *button = [JSShareItemButton shareButton];
            CGFloat itemHeight        = SHARE_ITEM_WIDTH+15;
            CGFloat itemY             = (SHARE_SCROLLVIEW_HEIGHT-itemHeight)/2;
            
            NSInteger imageTag = 0;
            if (i == 0) {
                [_ButtonTypeShareArray1 addObject:button];
                imageTag = ROW1BUTTON_TAG+index;
            } else {
                imageTag = ROW2BUTTON_TAG+index;
                [_ButtonTypeShareArray2 addObject:button];
            }
            button = [[JSShareItemButton alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT+index*(SHARE_ITEM_WIDTH+SHARE_ITEM_SPACE), itemY+SHARE_ITEM_WIDTH-5, SHARE_ITEM_WIDTH, itemHeight)
                                                ImageName:[itemDict allValues][0]
                                                 imageTag:imageTag
                                                    title:[itemDict allKeys][0]
                                                titleFont:12
                                               titleColor:COLOR_1];
            
            button.tag = BUTTON_TAG+imageTag;
            [button addTarget:self
                       action:@selector(shareTypeClickIndex:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [rowScrollView addSubview:button];
            if (i == 0) {
                [_ButtonTypeShareArray1 addObject:button];
            } else {
                [_ButtonTypeShareArray2 addObject:button];
            }
            
        }
        if (i == 0) {
            /*line*/
            UIView *lineView1  = [[UIView alloc] initWithFrame:CGRectMake(0, rowScrollView.height + ZH_SCALE_SCREEN_Height(23), shareBGView.width, 0.5)];
            lineView1.backgroundColor = COLOR_24;
            [shareBGView addSubview:lineView1];
            CGFloat H;
            if (SCREEN_WIDTH == 320) {
              H =  WCX_SCALE_SCREEN_Height(106);
            }else if(SCREEN_WIDTH == 375){
                H = WCX_SCALE_SCREEN_Height(101);
            }else{
               H = WCX_SCALE_SCREEN_Height(96);
            }
            UIView *lineView2  = [[UIView alloc] initWithFrame:CGRectMake(0, rowScrollView.height + WCX_SCALE_SCREEN_Height(23) +H, shareBGView.width, 0.5)];
            lineView2.backgroundColor = COLOR_24;
            [shareBGView addSubview:lineView2];
        }
    }
    /****************************** 取消 ********************************************/
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, shareBGView.height-ZH_SCALE_SCREEN_Height(50), shareBGView.width, WCX_SCALE_SCREEN_Height(50));
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = XNFont(15);
    cancleButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
    [shareBGView addSubview:cancleButton];
    
    /****************************** 动画 ********************************************/
    shareBGView.alpha = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         bgView.alpha = 0.3f;
                         shareBGView.frame = finaRect;
                         shareBGView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
    for (JSShareItemButton *button in _ButtonTypeShareArray1) {
        NSInteger idx = [_ButtonTypeShareArray1 indexOfObject:button];
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y -= SHARE_ITEM_WIDTH;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    for (JSShareItemButton *button in _ButtonTypeShareArray2) {
        NSInteger idx = [_ButtonTypeShareArray2 indexOfObject:button];
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y -= SHARE_ITEM_WIDTH;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)shareTypeClickIndex:(UIButton *)btn{
    NSInteger tag = btn.tag-BUTTON_TAG;
    NSInteger intV = tag % ROW1BUTTON_TAG;
    NSInteger intV1 = tag % ROW2BUTTON_TAG;
    NSInteger countRow1 = _typeArray1.count;
    NSInteger countRow2 = _typeArray2.count;
    // share type
    NSUInteger typeUI = 0;
    if (intV>=0&&intV<=countRow1) {
        NSLog(@"第一行");
        typeUI = [_typeArray1[intV] unsignedIntegerValue];
        
    }else if (intV1>=0&&intV1<=countRow2 && !_report){
        typeUI = [_typeArray2[intV1] unsignedIntegerValue];
    } else if (intV1>=0&&intV1<=countRow2){
        NSLog(@"第2行");
        [self dismissShareView];
        typeUI = [_typeArray2[intV1] unsignedIntegerValue];
        if(_delegate !=nil && [_delegate respondsToSelector:@selector(JSShareViewDelegateClickReport)]){
            [_delegate JSShareViewDelegateClickReport];
        }
        return;
        
    }
    //built share parames
    NSDictionary *shareContent = _publishContent;
    NSString *text             = shareContent[@"text"];
    NSString *url              = shareContent[@"url"];
    NSString *tittle           =  shareContent[@"tittle"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKEnableUseClientShare];
    //为1的时候是新浪微博分享，链接需要拼接到分享内容中
    if (typeUI == 1) {
        NSArray *image = shareContent[@"image"];
//        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@",text,url]
//                                         images:image
//                                            url:[NSURL URLWithString:url]
//                                          title:tittle
//                                           type:SSDKContentTypeImage];
    }else{
        id image;
        if (_isLocalIMage) {
            UIImage *ima = [self OriginImage:shareContent[@"image"] scaleToSize:CGSizeMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
            image = ima;
        }else{
            NSArray *ima = shareContent[@"image"];
            image = ima;
        }
//        [shareParams SSDKSetupShareParamsByText:text
//                                         images:image
//                                            url:[NSURL URLWithString:url]
//                                          title:tittle
//                                           type:SSDKContentTypeAuto];
    }
//    [ShareSDK share:typeUI
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//
//         switch (state) {
//             case SSDKResponseStateSuccess:
//             {
//                 NSLog(@"分享成功~");
//                 self.ShareResultBlock(ShareTypeSocial,YES);
//             }
//                 break;
//             case SSDKResponseStateFail:
//             {
//                 NSLog(@"分享失败~");
//                 NSLog(@"%@",userData);
//                self.ShareResultBlock(ShareTypeSocial,NO);
//             }
//                 break;
//             case SSDKResponseStateCancel:
//             {
//                 NSLog(@"分享取消~");
//                self.ShareResultBlock(ShareTypeSocial,NO);
//             }
//                 break;
//             default:
//                 break;
//         }
//     }];
    [self dismissShareView];
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)dismissShareView{
    UIWindow *window;
    if ([_type isEqualToString:@"game"]) {
        FHAppDelegate *deleage = (FHAppDelegate *)[UIApplication sharedApplication].delegate;
    } else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    UIView *blackView = [window viewWithTag:BG_TAG];
    UIView *shareBGView =[window viewWithTag:10000123];
    [UIView animateWithDuration:0.3
                     animations:^{
                         blackView.alpha = 0;
                         shareBGView.alpha = 0;
                         self.alpha = 0;
                        }
                     completion:^(BOOL finished) {
                         [blackView removeFromSuperview];
                         [shareBGView removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
    
}

- (void)tapNoe{
    
}

@end
