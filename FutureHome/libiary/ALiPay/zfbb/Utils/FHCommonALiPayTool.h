//
//  FHCommonALiPayTool.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCommonALiPayTool : NSObject

+ (void)doAPPayWithAppsecertKey:(NSString *)keyString;

@end

NS_ASSUME_NONNULL_END
