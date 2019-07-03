//
//  CurrentViewController.h
//  SayU
//
//  Created by mac on 15/11/18.
//  Copyright (c) 2015年 xys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentViewController : UIViewController

+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getCurrentVC1;
/**
 *  获取最上层视图
 */
+ (UIViewController*)topViewController;

@end
