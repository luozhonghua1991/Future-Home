//
//  NetWork.h
//  SayU
//
//  Created by www.xys.ren on 15/9/23.
//  Copyright (c) 2015年 xys. All rights reserved.
//  封装AFNworking 负责整个项目的所有http网络封装

#import <Foundation/Foundation.h>

/**
 *  请求成功的block
 */
typedef void (^successBlock)(id responseObj);
/**
 *  请求失败后的block
 */
typedef void (^failureBlock)(NSError *error);


@interface AFNetWorkTool : NSObject

/**
 *  发送一个get请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调(请将请求成功后想做的事情放入这个block内)
 *  @param failure 请求失败后的回调(请将请求失败后想做的事情放入这个block内)
 */
+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure;

/**
 *  发送一个post请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调(请将请求成功后想做的事情放入这个block内)
 *  @param failure 请求失败后的回调(请将请求失败后想做的事情放入这个block内)
 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure;
/**
 *  增加一个数据
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后回调
 *  @param failure 请求失败后回调
 */
+ (void)put:(NSString *)url
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure;

/**
 *  删除一个数据
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后回调
 *  @param failure 请求失败后回调
 */
+ (void)deleteRequest:(NSString *)url
               params:(NSDictionary *)params
              success:(successBlock)success
              failure:(failureBlock)failure;

/**
 *  上传post请求
 *
 *  @param url          请求路径
 *  @param parameter    请求参数
 *  @param image        请求图片数据
 *  @param success      请求成功后回调
 *  @param failure      请求失败后回调
 */
+ (void)updateImageWithUrl:(NSString *)url
                 parameter:(NSDictionary *)parameter
                 imageData:(NSData *)imageData
                   success:(successBlock)success
                   failure:(failureBlock)failure;

//+ (void)updateImageWithUrl:(NSString *)url
//                 parameter:(NSDictionary *)parameter
//                 voiceData:(NSData *)imageData
//                 voiceName:(NSString *)voiceName
//                 voiceType:(NSString *)voiceType
//                   success:(successBlock)success
//                   failure:(failureBlock)failure;

#pragma mark 上传用户头像
+ (void)updateHeaderImageWithUrl:(NSString *)url
                       parameter:(NSDictionary *)parameter
                       imageData:(NSData *)imageData
                         success:(successBlock)success
                         failure:(failureBlock)failure;


#pragma mark 上传用户朋友圈背景图
+ (void)updatePersonPYQBgImageWithUrl:(NSString *)url
                            parameter:(NSDictionary *)parameter
                            imageData:(NSData *)imageData
                              success:(successBlock)success
                              failure:(failureBlock)failure;


#pragma mark 多图上传
+ (void)uploadImagesWithUrl:(NSString *)url
                 parameters:(NSDictionary *)parameters
                      image:(NSArray *)imageArray
                    success:(successBlock)success
                    failure:(failureBlock)failure;


#pragma mark — 开通账户多图上传
+ (void)uploadImagesWithUrl:(NSString *)url
                 parameters:(NSDictionary *)parameters
                      image:(NSArray *)imageArray
                 otherImage:(NSArray *)otherImageArray
                    success:(successBlock)success
                    failure:(failureBlock)failure;


#pragma mark — 开通商务合作多图上传
+ (void)openBussinessUploadImagesWithUrl:(NSString *)url
                              parameters:(NSDictionary *)parameters
                                   image:(NSArray *)imageArray
                              otherImage:(NSArray *)otherImageArray
                                 success:(successBlock)success
                                 failure:(failureBlock)failure;


#pragma mark — 上传视频
+ (void)updateVideoWithUrl:(NSString *)url
                 parameter:(NSDictionary *)parameter
                 videoData:(NSData *)videoData
                   success:(successBlock)success
                   failure:(failureBlock)failure;




@end
