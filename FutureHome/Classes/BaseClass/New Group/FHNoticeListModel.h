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
@property (nonatomic, assign) NSInteger notice_id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 跳转的URL */
@property (nonatomic, copy) NSString *url;
/** 观看册数 */
@property (nonatomic, assign) NSInteger view_num;
/** 创建时间 */
@property (nonatomic, copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
