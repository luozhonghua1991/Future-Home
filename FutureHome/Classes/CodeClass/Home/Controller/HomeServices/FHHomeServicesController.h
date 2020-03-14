//
//  FHHomeServicesController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHCommonFollowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHHomeServicesController : BaseViewController
///** 物业的ID */
@property (nonatomic, assign) NSInteger homeServices_ID;

/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommonFollowModel *model;
/** 是否收藏 */
@property (nonatomic, assign) BOOL isFollow;


- (void)setHomeSeverID:(NSInteger )HomeSeverID
        homeServerName:(NSString *)homeServerName;


@end

NS_ASSUME_NONNULL_END
