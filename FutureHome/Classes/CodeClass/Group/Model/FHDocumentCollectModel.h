//
//  FHDocumentCollectModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHDocumentCollectModel : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *coverthumb;
/** 收藏时间 */
@property (nonatomic, copy) NSString *updatetime;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *cid;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *id;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *singpage;
/** 阅读量 */
@property (nonatomic, copy) NSString *browse;



@end

NS_ASSUME_NONNULL_END
