//
//  ClearCaChe.h
//  SayU
//
//  Created by 杭州任性贸易有限公司 on 16/3/4.
//  Copyright © 2016年 xys. All rights reserved.
//  清除缓存 计算缓存大小
#import <Foundation/Foundation.h>

@interface ClearCaChe : NSObject

/**
 *  计算缓存大小
 *
 *
 */
+ (float)folderSizeAtPath:(NSString *)path;
/**
 *  清除缓存
 *
 */
+ (void)clearCache:(NSString *)path;

+ (void)clearCachSuccess;
@end
