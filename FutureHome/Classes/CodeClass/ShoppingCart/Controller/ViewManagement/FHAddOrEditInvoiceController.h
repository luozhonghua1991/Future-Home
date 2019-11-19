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
/** 发票ID */
@property (nonatomic, copy) NSString *InvoiceID;
/**标题名称*/
@property (nonatomic,copy) NSString *titleName;
/**公司名字*/
@property (nonatomic,copy) NSString *companyName;
/**公司税号*/
@property (nonatomic,copy) NSString *companyCode;
/**公司地址*/
@property (nonatomic,copy) NSString *companyAddress;
/**公司电话*/
@property (nonatomic,copy) NSString *companyPhone;
/**开户银行*/
@property (nonatomic,copy) NSString *companyBank;
/**开户账号*/
@property (nonatomic,copy) NSString *companyAccount;
/**发票iID*/
@property (nonatomic,copy) NSString *companyID;

@end

NS_ASSUME_NONNULL_END
