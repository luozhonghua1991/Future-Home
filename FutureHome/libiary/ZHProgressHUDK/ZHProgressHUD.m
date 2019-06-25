//
//  ZHProgressHUD.m
//  PictureHouseKeeper
//
//  Created by  on 16/8/19.
//  Copyright © 2016年 . All rights reserved.
//

#import "ZHProgressHUD.h"

@implementation ZHProgressHUD

+(instancetype)shareinstance{
    
    static ZHProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(ZHProgressMode *)myMode{
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(ZHProgressMode *)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if ([ZHProgressHUD shareinstance].hud != nil) {
        [[ZHProgressHUD shareinstance].hud hideAnimated:YES];
        [ZHProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [ZHProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //这里设置是否显示遮罩层
    //[ZHProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [ZHProgressHUD shareinstance].hud.bezelView.color = [UIColor blackColor];
    [ZHProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    
    [[ZHProgressHUD shareinstance].hud setMargin:10];
    [[ZHProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [ZHProgressHUD shareinstance].hud.detailsLabel.text = msg;

    [ZHProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    switch ((NSInteger)myMode) {
        case ZHProgressModeOnlyText:
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;

        case ZHProgressModeLoading:
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;

        case ZHProgressModeCircle:{
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.toValue = [NSNumber numberWithFloat:M_PI*2];
            animation.duration = 1.0;
            animation.repeatCount = 100;
            [img.layer addAnimation:animation forKey:nil];
            [ZHProgressHUD shareinstance].hud.customView = img;
            
            
            break;
        }
        case ZHProgressModeCustomerImage:
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [ZHProgressHUD shareinstance].hud.customView = customImgView;
            break;

        case ZHProgressModeCustomAnimation:
            //这里设置动画的背景色
            [ZHProgressHUD shareinstance].hud.bezelView.color = [UIColor yellowColor];
            
            
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [ZHProgressHUD shareinstance].hud.customView = customImgView;
            
            break;

        case ZHProgressModeSuccess:
            [ZHProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [ZHProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;

        default:
            break;
    }
    
    
    
}
+ (void)hide{
    if ([ZHProgressHUD shareinstance].hud != nil) {
        [[ZHProgressHUD shareinstance].hud hideAnimated:YES];
    }
}


+ (void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ZHProgressModeOnlyText];
    [[ZHProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}



+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:ZHProgressModeOnlyText];
    [[ZHProgressHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+ (void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:ZHProgressModeSuccess];
    [[ZHProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+(void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:ZHProgressModeCustomerImage customImgView:img];
    [[ZHProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ZHProgressModeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
    
    
}

+(void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:ZHProgressModeCircle];
    
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:ZHProgressModeOnlyText];
    [[ZHProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:ZHProgressModeCustomAnimation customImgView:showImageView];
    

}

@end
