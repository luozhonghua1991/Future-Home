//
//  AccountStorage.h
//  Reading
//
//  Created by liuchao on 16/7/27.
//  Copyright © 2016年 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountStorage : NSObject

/** 保存账户 */
+ (BOOL)saveAccount:(Account *)account;
/** 读取数据 */
+ (Account *)readAccount;
/** 读取账户 token */
+ (NSString *)readAccountToken;
/** 读取账户  电话 */
+ (NSString *)readAccountPhone;
/** 删除账户 */
+ (BOOL)removeAccount;
/** ToKen 是否存在 */
+ (BOOL)isExistsToKen;
/** 删除 token，需重新登录获取 */
+ (BOOL)removeToken;
/** 文件是否存在 */
+ (BOOL)isFileExistsAtPath;
/** 获取文档路径 */
+ (NSString *)documentsDirectory;
/** 获取文件路径 */
+ (NSString* )dataFilePath;

/** 分析师还是普通用户 */
+ (BOOL)isAnalyzer;

@end
