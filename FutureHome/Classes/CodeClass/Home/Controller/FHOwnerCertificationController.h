//
//  FHOwnerCertificationController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/4.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHOwnerCertificationController : BaseViewController
/**  */
@property (nonatomic, assign) NSInteger property_id;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHAuthModel *authModel;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END
