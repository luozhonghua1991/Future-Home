//
//  FHSharingDynamicsController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2020/1/8.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "ZFTableData.h"
NS_ASSUME_NONNULL_BEGIN

@interface FHSharingDynamicsController : BaseViewController
/** 设置数据 */
@property (nonatomic, copy) NSDictionary *dataDic;
/** 文章 和 视频  */
@property (nonatomic, copy) NSString *type;
/** <#strong属性注释#> */
@property (nonatomic, strong) ZFTableData *data;
/** 1生鲜 2朋友圈 */
@property (nonatomic, copy) NSString *video_type;


@end

NS_ASSUME_NONNULL_END
