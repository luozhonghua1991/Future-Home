//
//  FHAddressAdministrationController.h
//  宏亚金融OC版
//
//  Created by FH on 2017/12/22.
//  Copyright © 2017年 FH. All rights reserved.
//

#import "BaseViewController.h"
#import "HYJFAllAddressModel.h"

@interface HYJFAddressAdministrationController : BaseViewController
// 属性block
@property (nonatomic, copy) void(^selectResultBlock)(HYJFAllAddressModel *addressModel);

/** 是否有导航栏 */
@property (nonatomic, assign) BOOL isHaveNavBar;

@end
