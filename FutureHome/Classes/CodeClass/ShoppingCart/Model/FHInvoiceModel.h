//
//  FHInvoiceModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/18.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHInvoiceModel : NSObject
/** 公司单位 */
@property (nonatomic, copy) NSString *companyname;
/** 公司税号 */
@property (nonatomic, copy) NSString *taxpayercode;
/** 公司地址 */
@property (nonatomic, copy) NSString *companyaddress;
/** 公司电话 */
@property (nonatomic, copy) NSString *companytel;
/** 开户银行 */
@property (nonatomic, copy) NSString *openbank;
/** 开户账号 */
@property (nonatomic, copy) NSString *accountinfo;
/** id */
@property (nonatomic, copy) NSString *id;


@end

NS_ASSUME_NONNULL_END
