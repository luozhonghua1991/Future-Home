//
//  HYJFAddOrEditAddressController.h
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/22.
//  Copyright © 2017年 HYJF. All rights reserved.
//

#import "BaseViewController.h"

@interface HYJFAddOrEditAddressController : BaseViewController
/**标题名称*/
@property (nonatomic,copy) NSString *titleName;
/**收货人名字*/
@property (nonatomic,copy) NSString *strName;
/**收货人手机号*/
@property (nonatomic,copy) NSString *strPhoneNum;
/**地址*/
@property (nonatomic,copy) NSString *strAddress;
/**详细地址*/
@property (nonatomic,copy) NSString *strDetialAddress;


/**地址id*/
@property (nonatomic,assign) NSInteger addressID;
/**省*/
@property (nonatomic,copy) NSString *province;
/**市*/
@property (nonatomic,copy) NSString *city;
/**区*/
@property (nonatomic,copy) NSString *district;

@end
