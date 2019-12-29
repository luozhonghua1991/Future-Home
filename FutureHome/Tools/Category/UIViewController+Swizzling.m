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
    
    // 两方法进行交换
    Method hhviewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
    //需要替换成 能够输出日志的viewDidLoad
    Method hhlogViewDidLoad = class_getInstanceMethod(self, @selector(hhview));
    
    // 两方法进行交换
    Method hhviewDidLoad1 = class_getInstanceMethod(self, @selector(viewDidAppear:));
    //需要替换成 能够输出日志的viewDidLoad
    Method hhlogViewDidLoad1 = class_getInstanceMethod(self, @selector(hhview1:));
    
    
    method_exchangeImplementations(hhviewDidLoad, hhlogViewDidLoad);
    method_exchangeImplementations(hhviewDidLoad1, hhlogViewDidLoad1);
    
    //原本的willAppear方法
    Method willAppearOriginal = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    //我们的willAppear方法
    Method willAppearNew = class_getInstanceMethod([self class], @selector(swizzlingViewWillAppear:));
    //交换
    if (!class_addMethod([self class], @selector(viewWillAppear:), method_getImplementation(willAppearNew), method_getTypeEncoding(willAppearNew))) {
        method_exchangeImplementations(willAppearOriginal, willAppearNew);
    }
}

//- (void)logViewDidLoad {
//
//    NSString *className = NSStringFromClass([self class]);
//    //在这里，你可以进行过滤操作，指定哪些viewController需要打印，哪些不需要打印
//    if ([className hasPrefix:@"UI"] == NO) {
//        NSLog(@"%@ 已经加载出来了！！！",className);
//    }
//
//
//    //下面方法的调用，其实是调用viewDidLoad
//    [self logViewDidLoad];
//}


- (void)hhview {
    NSString *className = NSStringFromClass([self class]);
    //    RCAlumListTableViewController
    NSLog(@"%@ 名字",className);
    if ([className hasPrefix:@"UI"] == NO) {
        NSLog(@"%@ 已经加载出来了！！！",className);
    }
    [self hhview];
}


- (void)hhview1:(BOOL)animated{
    NSString *className = NSStringFromClass([self class]);
    if([className isEqualToString:@"RCAlumListTableViewController"]) {
        UITableView *vc =  ( UITableView*)self.view ;
        vc.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) ;
    }
//    if([className isEqualToString:@"TZAlbumPickerController"]) {
//        UITableView *vc =  ( UITableView*)self.view ;
//        vc.frame = CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainStatusBarHeight) ;
//    }
    [self hhview1:animated];
}

- (void)swizzlingViewWillAppear:(BOOL)animated {
    [self swizzlingViewWillAppear:animated];
    if ([self isMemberOfClass:NSClassFromString(@"RCPhotosPickerController")]) {
        UICollectionView *collectionView = self.view.subviews.firstObject;
        collectionView.contentInset = UIEdgeInsetsMake(MainSizeHeight, 0, 0, 0);
    }
//    if ([self isMemberOfClass:NSClassFromString(@"TZPhotoPickerController")]) {
//        UICollectionView *collectionView = self.view.subviews.firstObject;
//        collectionView.contentInset = UIEdgeInsetsMake(MainStatusBarHeight, 0, 0, 0);
//    }
}

@end
