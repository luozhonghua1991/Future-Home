
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
@interface AFNetWorkTool ()

@end

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
    failure:(void (^)(NSError *))failure {
    Account *account = [AccountStorage readAccount];
    //获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session setResponseSerializer:serializer];
    
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    //发送get请求
    [session GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark post请求
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure {
    Account *account = [AccountStorage readAccount];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    if (params) {
        if ([params[@"gateway"] isEqualToString:@"true"]) {
            AFHTTPResponseSerializer *serial = [AFHTTPResponseSerializer serializer];
            session.responseSerializer = serial;
        }
    }
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    [session POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark put网络请求
+ (void)put:(NSString *)url
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    [session PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (success) {
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
              failure:(failureBlock)failure {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    [session DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        if (success) {
            if (success) {
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

#pragma mark 上传图片
+ (void)updateImageWithUrl:(NSString *)url
                 parameter:(NSDictionary *)parameter
                 imageData:(NSData *)imageData
                   success:(successBlock)success
                   failure:(failureBlock)failure {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        [formData appendPartWithFileData:imageData name:@"file[]" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



#pragma mark 上传用户头像
+ (void)updateHeaderImageWithUrl:(NSString *)url
                 parameter:(NSDictionary *)parameter
                 imageData:(NSData *)imageData
                   success:(successBlock)success
                   failure:(failureBlock)failure {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark 上传用户朋友圈背景图
+ (void)updatePersonPYQBgImageWithUrl:(NSString *)url
                            parameter:(NSDictionary *)parameter
                            imageData:(NSData *)imageData
                              success:(successBlock)success
                              failure:(failureBlock)failure {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        [formData appendPartWithFileData:imageData name:@"cover" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark — 多图上传
+ (void)uploadImagesWithUrl:(NSString *)url
                 parameters:(NSDictionary *)parameters
                      image:(NSArray *)imageArray
                    success:(successBlock)success
                    failure:(failureBlock)failure  {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        for (int i = 0; i < imageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1);
            [formData appendPartWithFileData:imageData name:@"file[]" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark — 开通账户多图上传
+ (void)uploadImagesWithUrl:(NSString *)url
                 parameters:(NSDictionary *)parameters
                      image:(NSArray *)imageArray
                 otherImage:(NSArray *)otherImageArray
                    success:(successBlock)success
                    failure:(failureBlock)failure  {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        for (int i = 0; i < imageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1);
            [formData appendPartWithFileData:imageData name:@"file[]" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
        }
        for (int i = 0; i < otherImageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(otherImageArray[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"idCardFile[]" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark — 开通商务合作多图上传
+ (void)openBussinessUploadImagesWithUrl:(NSString *)url
                              parameters:(NSDictionary *)parameters
                                   image:(NSArray *)imageArray
                              otherImage:(NSArray *)otherImageArray
                                 success:(successBlock)success
                                 failure:(failureBlock)failure  {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIView hideHud:[UIApplication sharedApplication].keyWindow];
        for (int i = 0; i < imageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1);
            [formData appendPartWithFileData:imageData name:@"businesslicense[]" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
        }
        for (int i = 0; i < otherImageArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(otherImageArray[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"idCardFile[]" fileName:@"futureHome.png" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark — 上传视频
+ (void)updateVideoWithUrl:(NSString *)url
                 parameter:(NSDictionary *)parameter
                 videoData:(NSData *)videoData
                   success:(successBlock)success
                   failure:(failureBlock)failure {
    Account *account = [AccountStorage readAccount];
    [UIView showLoadingHud:@"" inView:[UIApplication sharedApplication].keyWindow];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //  申明请求的数据是json类型
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //如果接受类型不一致请替换一致text/html或别的
    serializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session setResponseSerializer:serializer];
    [session.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    [session POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:videoData name:@"file[]" fileName:@"futureHome.mp4" mimeType:@"     video/mp4"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
