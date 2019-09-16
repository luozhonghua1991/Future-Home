//
//  FHAdventModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHAdventModel : NSObject
/** 跳转的链接 */
@property (nonatomic, copy) NSString *path;
/** 图片URL地址 */
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
