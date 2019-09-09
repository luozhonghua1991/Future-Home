
//
//  NetWork.m
//  SayU
//
//  Created by www.xys.ren on 15/9/23.
//  Copyright (c) 2015年 xys. All rights reserved.
//

#import "AFNetWorkTool.h"
#import "AFNetworking.h"
//#import "NSString+MD5.h"
//#import "GTMBase64.h"

#import "FHAppDelegate.h"

@implementation AFNetWorkTool

//    //get请求 用户登录
//    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"15088665843",@"account",
//                               @"11111111",@"password", nil];
//    [AFNetWorkTool get:@"User/signIn" params:paramsDic success:^(id responseObj) {
//        ZHLog(@"%@",responseObj);
//
//    } failure:^(NSError * error) {
//
//    }];
//       // post请求 成功了。。。。
//        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"13849132460",@"phone",
//                                   @"SIGN_UP",@"type",nil];
//        [AFNetWorkTool post:@"User/sendVerificationCode" params:paramsDic success:^(id responseObj) {
//            ZHLog(@"%@",responseObj);
//
//        } failure:^(NSError * error) {
//
//        }];

//    // put请求  成功
//    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"13849132460",@"phone",
//                               @"11111111",@"newVerificationCode",
//                               @"11",@"newPhone",
//                               @"8396",@"verificationCode",nil];
//
//    [AFNetWorkTool put:@"User/resetPhone" params:paramsDic success:^(id responseObj) {
//        ZHLog(@"%@",responseObj);
//
//    } failure:^(NSError * error) {
//        NSDictionary *dic = error.userInfo;
//        NSData *data = dic[@"com.alamofire.serialization.response.error.data"];
//        if (data) {
//            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"jsonDict = %@",jsonDict);
//        }
//    }];

//delete请求 成功 不需要传入parmars
//    [AFNetWorkTool deleteRequest:@"http://testpc.hongyajinrong.com/allApi/Address/3" params:nil success:^(id responseObj) {
//        ZHLog(@"%@",responseObj);
//
//    } failure:^(NSError * error) {
//
//    }];



#pragma mark get请求
+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    if ([[self new] getProxyStatus]){
        failure(NULL);
        return;
    }
    //获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [session setResponseSerializer:serializer];

    [session.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"myCookie"]forHTTPHeaderField:@"Cookie"];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    //发送get请求
    [session GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];

        if (success) {

            NSString *fields= [((NSURLResponse *)task.response) valueForKey:@"allHeaderFields"][@"Set-Cookie"];
            if (fields.length) {
                [[NSUserDefaults standardUserDefaults] setObject:fields forKey:@"myCookie"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

            int code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 3303) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PERSONLOGIN"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PERSONPHONE"];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark post请求
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    if ([[self new] getProxyStatus]){
        failure(NULL);
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    if (params) {
        if ([params[@"gateway"] isEqualToString:@"true"]) {
            AFHTTPResponseSerializer *serial = [AFHTTPResponseSerializer serializer];
            session.responseSerializer = serial;
        }
    }
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [session.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"myCookie"]forHTTPHeaderField:@"Cookie"];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    [session POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        NSString *fields= [((NSURLResponse *)task.response) valueForKey:@"allHeaderFields"][@"Set-Cookie"];
        if (fields.length) {
            [[NSUserDefaults standardUserDefaults] setObject:fields forKey:@"myCookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        failure(error);
    }];
}
#pragma mark put网络请求
+ (void)put:(NSString *)url
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure
{
    if ([[self new] getProxyStatus]){
        failure(NULL);
        return;
    }
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    //  申明请求的数据是json类型
//    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//    [serializer setRemovesKeysWithNullValues:YES];
//    //如果接受类型不一致请替换一致text/html或别的
//    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    [session setResponseSerializer:serializer];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"myCookie"]forHTTPHeaderField:@"Cookie"];
    [session PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (success) {
            NSString *fields= [((NSURLResponse *)task.response) valueForKey:@"allHeaderFields"][@"Set-Cookie"];
            if (fields.length) {
                [[NSUserDefaults standardUserDefaults] setObject:fields forKey:@"myCookie"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

            int code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 3303) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PERSONLOGIN"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PERSONPHONE"];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark delete  删除请求
+ (void)deleteRequest:(NSString *)url
               params:(NSDictionary *)params
              success:(successBlock)success
              failure:(failureBlock)failure
{
    if ([[self new] getProxyStatus]){
        failure(NULL);
        return;
    }
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"myCookie"]forHTTPHeaderField:@"Cookie"];
    [session DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (success) {
            if (success) {
                NSString *fields= [((NSURLResponse *)task.response) valueForKey:@"allHeaderFields"][@"Set-Cookie"];
                if (fields.length) {
                    [[NSUserDefaults standardUserDefaults] setObject:fields forKey:@"myCookie"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }

                int code = [[responseObject objectForKey:@"code"] intValue];
                if (code == 3303) {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PERSONLOGIN"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PERSONPHONE"];
                }
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure(error);
        }
    }];
}


-(BOOL)getProxyStatus {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    if (![[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        return YES;
    }else{
        return NO;
    }
}

//#pragma mark 上传图片
//+ (void)updateImageWithUrl:(NSString *)url parameter:(NSDictionary *)parameter imageData:(NSData *)imageData success:(successBlock)success failure:(failureBlock)failure
//{
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    //  申明请求的数据是json类型
//    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//    [serializer setRemovesKeysWithNullValues:YES];
//    //如果接受类型不一致请替换一致text/html或别的
//    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [session setResponseSerializer:serializer];
//
//    [session POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"xys_image" mimeType:@"image/jpeg"];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}
//
//#pragma mark 上传声音
//+ (void)updateImageWithUrl:(NSString *)url parameter:(NSDictionary *)parameter voiceData:(NSData *)imageData voiceName:(NSString *)voiceName voiceType:(NSString *)voiceType success:(successBlock)success failure:(failureBlock)failure
//{
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    //  申明请求的数据是json类型
//    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//    [serializer setRemovesKeysWithNullValues:YES];
//    //如果接受类型不一致请替换一致text/html或别的
//    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [session setResponseSerializer:serializer];
//    
//    [session POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"file" fileName:voiceName mimeType:voiceType];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

@end