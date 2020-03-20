//
//  AccountStorage.m
//  Reading
//
//  Created by liuchao on 16/7/27.
//  Copyright © 2016年 liuchao. All rights reserved.
//

#import "AccountStorage.h"
#import "FHTabbarController.h"

#define kAccountPath    @"/account.data"

@implementation AccountStorage

/** 保存账户 */
+ (BOOL)saveAccount:(Account *)account {
//    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    
    [SingleManager shareManager].isFirstPushLogin = NO;
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    if (![self isFileExistsAtPath]) {
        if(![mgr createFileAtPath:[self dataFilePath] contents:nil attributes:nil])
            return NO;
    };
    // 用户留存
//    [MobClick profileSignInWithPUID:account->_phone];
//    [UMessage setAlias:account.phone type:@"risewinterIOS" response:^(id responseObject, NSError *error) {
//    }];
    return [NSKeyedArchiver archiveRootObject:account toFile:[self dataFilePath]];
}

/** 读取数据 */
+ (Account *)readAccount {
    
    if (![self isFileExistsAtPath]) return nil;
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self dataFilePath]];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/** 读取账户 token */
+ (NSString *)readAccountToken
{
    Account *account = [self readAccount];

    return account.token;
//#warning 暂时写死 上线记得去掉
//    //暂时写死 上线记得去掉
//    return @"XM7RQNx3-VynczPe265FETIldpA";
}

/** 读取账户  电话 */
+ (NSString *)readAccountPhone
{
    Account *account = [self readAccount];
    
    return account.mobile;
}

/** 删除账户 */
+ (BOOL)removeAccount {
    
    Account *account = [self readAccount];
    if (account) {
//        [UMessage removeAlias:account->_phone type:@"risewinterIOS" response:^(id responseObject, NSError *error) {
//        }];
    }
    
    NSError *error = nil;
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:&error];
    if (!isSuccess) {
        return NO;
    };
    
//    [MobClick profileSignOff];
    
    return YES;
}

/** ToKen 是否存在 */
+ (BOOL)isExistsToKen {
    
    Account *account = [self readAccount];
    return  ((account.token != nil) ? YES : NO);
}

/** 删除 token，需重新登录获取 */
+ (BOOL)removeToken {
    
    Account *account = [self readAccount];
    account.token    = nil;
    
    return  [self saveAccount:account];
}

/** 文件是否存在 */
+ (BOOL)isFileExistsAtPath {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]];
}

/** 获取文档路径 */
+ (NSString *)documentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    
    return documentsDirectory;
}

/** 获取文件路径 */
+ (NSString* )dataFilePath {
    
    return [[self documentsDirectory] stringByAppendingPathComponent:kAccountPath];
}

@end
