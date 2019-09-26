//
//  FHAddPersonController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHHealthMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHAddPersonController : BaseViewController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *titleString;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHHealthMemberModel *model;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
