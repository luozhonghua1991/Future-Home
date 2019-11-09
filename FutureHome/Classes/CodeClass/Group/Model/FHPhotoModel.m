//
//  FHPhotoModel.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/1.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHPhotoModel.h"
#import "NSArray+JSON.h"

@implementation FHPhotoModel

-(NSArray *)pic_urls{
    if (self.img_data.length > 5) {
        NSData *jsonData = [self.img_data dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *error = nil;
        NSArray  *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
        
        if (jsonObject != nil && error == nil){
            _pic_urls = jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    return _pic_urls;
    
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self == [super init]) {
        self.create_time  = dict[@"create_time"];
        self.img_data = [dict[@"path"] toReadableJSONString];
        
        _identifier = [self uniqueIdentifier];
    }
    return self;
}

+ (instancetype)commitWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}

@end
