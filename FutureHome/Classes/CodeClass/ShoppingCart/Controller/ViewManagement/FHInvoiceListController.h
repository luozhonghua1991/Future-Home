//
//  FHInvoiceListController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHInvoiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FHInvoiceListController : BaseViewController
// <#属性block#>
@property (nonatomic, copy) void(^selectResultBlock)(FHInvoiceModel *invoiceModel);

/** 是否有导航栏 */
@property (nonatomic, assign) BOOL isHaveNavBar;

@end

NS_ASSUME_NONNULL_END
