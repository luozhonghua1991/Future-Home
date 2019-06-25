//
//  UIViewController+Swizzling.m
//  SayU
//
//  Created by 性用社 on 16/10/19.
//  Copyright © 2016年 xys. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
@implementation UIViewController (Swizzling)

+ (void)load {
    //我们只有在开发的时候才需要查看哪个viewController将出现
    //所以在release模式下就没必要进行方法的交换
#ifdef DEBUG
    //原本的viewDidLoad方法
    Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
    //需要替换成 能够输出日志的viewDidLoad
    Method logViewDidLoad = class_getInstanceMethod(self, @selector(logViewDidLoad));
    //两方法进行交换
    method_exchangeImplementations(viewDidLoad, logViewDidLoad);
    
#endif
    
}
- (void)logViewDidLoad {
    
    NSString *className = NSStringFromClass([self class]);
    
    //在这里，你可以进行过滤操作，指定哪些viewController需要打印，哪些不需要打印
    if ([className hasPrefix:@"UI"] == NO) {
        NSLog(@"%@ 已经加载出来了！！！",className);
    }
    
    
    //下面方法的调用，其实是调用viewDidLoad
    [self logViewDidLoad];
}


@end
