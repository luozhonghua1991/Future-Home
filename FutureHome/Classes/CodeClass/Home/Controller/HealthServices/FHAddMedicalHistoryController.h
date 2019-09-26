//
//  FHAddMedicalHistoryController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "HWPublishBaseController.h"
#import "FHHealthHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHAddMedicalHistoryController : HWPublishBaseController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *titleString;
/** 用户PID */
@property (nonatomic, copy) NSString *pid;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHHealthHistoryModel *model;

@end

NS_ASSUME_NONNULL_END
