//
//  FHInformationModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHInformationModel : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *coverthumb;
/** id */
@property (nonatomic, copy) NSString *id;
/** 阅读量 */
@property (nonatomic, copy) NSString *show;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 更新时间 */
@property (nonatomic, copy) NSString *updatetime;
/** 跳转链接 */
@property (nonatomic, copy) NSString *singpage;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END
