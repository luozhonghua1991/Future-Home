//
//  FHHousingRentOrSaleController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "HWPublishBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHHousingRentOrSaleController : HWPublishBaseController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *titleString;
/** 1房屋出售 2房屋出租 */
@property (nonatomic, assign) NSInteger type;
/**  */
@property (nonatomic, assign) NSInteger property_id;

@end

NS_ASSUME_NONNULL_END
