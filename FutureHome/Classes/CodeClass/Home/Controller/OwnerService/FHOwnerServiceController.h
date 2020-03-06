//
//  FHOwnerServiceController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/28.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHCommonFollowModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FHOwnerServiceController : BaseViewController

/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommonFollowModel *model;

- (void)setHomeSeverID:(NSInteger )HomeSeverID
        homeServerName:(NSString *)homeServerName;

/** 是否收藏 */
@property (nonatomic, assign) BOOL isFollow;

@end

NS_ASSUME_NONNULL_END
