//
//  FHNoticeListModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHNoticeListModel : NSObject
/** 公告ID */
@property (nonatomic, copy) NSString *id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 跳转的URL */
@property (nonatomic, copy) NSString *singpage;
/** 观看次数 */
@property (nonatomic, assign) NSInteger show;
/** 更新时间 */
@property (nonatomic, copy) NSString *updatetime;
/** 封面图 */
@property (nonatomic, copy) NSString *coverthumb;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END
