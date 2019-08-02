//
//  ClearCaChe.m
//  SayU
//
//  Created by 杭州任性贸易有限公司 on 16/3/4.
//  Copyright © 2016年 xys. All rights reserved.
//

#import "ClearCaChe.h"
#import "SDImageCache.h"

@implementation ClearCaChe

//计算有大的内存
+ (float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

+ (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [ClearCaChe fileSizeAtPath:absolutePath];
        }
//         //*SDWebImage框架自身计算缓存的实现
//        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
            return folderSize;
        
    }
    return 0;
}

+ (void)clearCache:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//    GJLog(@"清理成功");
}

+ (void)clearCachSuccess
{
//    GJLog(@"清理成功");
    UIAlertView * alertView = [[ UIAlertView alloc ] initWithTitle:@"提示" message : @"缓存清理完毕" delegate :nil cancelButtonTitle:@"确定" otherButtonTitles:nil ];
    [alertView show ];
}

@end
