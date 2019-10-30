//
//  ZJCommit.m
//  ZJCommitListDemo
//
//  Created by 邓志坚 on 2017/12/10.
//  Copyright © 2017年 邓志坚. All rights reserved.
//
/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下。😆
 */
#import "ZJCommit.h"
#import "NSArray+JSON.h"

@implementation ZJCommit

-(NSArray *)pic_urls {
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

-(id)initWithDict:(NSDictionary *)dict {
    if (self == [super init]) {
        self.avatar  = dict[@"avatar"];
        self.nickname = dict[@"nickname"];
        self.content = dict[@"content"];
        self.img_data = [dict[@"img_ids"] toReadableJSONString];
        self.ID = dict[@"id"];
//        self.like_count = dict[@"like_count"];
//        self.unlike_count = dict[@"unlike_count"];
        self.add_time = dict[@"create_time"];
//        self.rating = dict[@"rating"];
        self.view_num = [dict[@"view_num"] integerValue];
        self.comment_num = [dict[@"comment_num"] integerValue];
        self.user_id = dict[@"user_id"];
        _identifier = [self uniqueIdentifier];
    }
    return self;
}

-(id)initWithDongTaiDict:(NSDictionary *)dict {
    if (self == [super init]) {
        NSArray *arr = dict[@"medias"];
        NSMutableArray *imageArrs = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arr) {
            [imageArrs addObject:dic[@"path"]];
        }
        self.avatar  = dict[@"avatar"];
        self.nickname = dict[@"nickname"];
        self.content = dict[@"content"];
        self.img_data = [imageArrs toReadableJSONString];
//        self.like_id = dict[@"like_id"];
        self.like_count = dict[@"like_num"];
//        self.unlike_count = dict[@"unlike_count"];
        self.add_time = dict[@"create_time"];
        self.view_num = [dict[@"view_num"] integerValue];
        self.comment_num = [dict[@"comment_num"] integerValue];
        self.user_id = dict[@"user_id"];
//        self.rating = dict[@"rating"];
        
        _identifier = [self uniqueIdentifier];
    }
    return self;
}

+(instancetype)commitWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+(instancetype)commitWithDongtaiDict:(NSDictionary *)dict {
    return [[self alloc] initWithDongTaiDict:dict];
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}

@end
