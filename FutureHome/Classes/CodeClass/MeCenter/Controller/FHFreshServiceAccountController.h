//
//  FHFreshServiceAccountController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "HWPublishBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHFreshServiceAccountController : HWPublishBaseController
/** 里面的注释 */
@property (nonatomic, copy) NSString *tips2;
/** 跳转的链接 */
@property (nonatomic, copy) NSString *protocol;
/** 折扣率 */
@property (nonatomic, copy) NSString *discount;
/** 开通物业费价格 */
@property (nonatomic, copy) NSString *open;
/** 折扣价 */
@property (nonatomic, copy) NSString *price;

@end

NS_ASSUME_NONNULL_END
