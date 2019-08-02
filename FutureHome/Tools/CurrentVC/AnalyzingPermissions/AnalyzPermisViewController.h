//
//  AnalyzPermisViewController.h
//  iphonetest
//
//  Created by 杭州任性贸易有限公司 on 16/4/8.
//  Copyright © 2016年 LWJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyzPermisViewController : UIViewController

+ (void)checkServiceEnable:(int)nType :(void (^)(BOOL))result;

@end
