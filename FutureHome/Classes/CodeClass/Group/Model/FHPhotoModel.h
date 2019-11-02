//
//  FHPhotoModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/1.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHPhotoModel : NSObject

@property(nonatomic, copy) NSString     *create_time;

@property(nonatomic, copy) NSString     *img_data;

@property(nonatomic, strong) NSArray    *pic_urls;

@property(nonatomic ,copy) NSString     *identifier;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)commitWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
