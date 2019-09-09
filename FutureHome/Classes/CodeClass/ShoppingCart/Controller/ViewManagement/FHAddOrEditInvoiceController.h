//
//  FHAddOrEditInvoiceController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHAddOrEditInvoiceController : BaseViewController
/**标题名称*/
@property (nonatomic,copy) NSString *titleName;
/**公司名字*/
@property (nonatomic,copy) NSString *companyName;
/**公司税号*/
@property (nonatomic,copy) NSString *companyCode;

@end

NS_ASSUME_NONNULL_END
