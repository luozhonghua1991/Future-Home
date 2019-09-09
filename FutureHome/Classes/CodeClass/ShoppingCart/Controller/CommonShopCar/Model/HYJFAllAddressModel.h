//
//  HYJFAllAddressModel.h
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/22.
//  Copyright © 2017年 HYJF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYJFAllAddressModel : NSObject
/**数据库记录的id*/
@property (nonatomic, assign) int id;
/**收货人手机号*/
@property (nonatomic, copy) NSString *phone;
/**省份*/
@property (nonatomic, copy) NSString *province;
/**是否是默认地址 0不是 1是*/
@property (nonatomic, assign) int isDefault;
/**省编号*/
@property (nonatomic, copy) NSString *provinceCode;
/**市编号*/
@property (nonatomic, copy) NSString *cityCode;
/**用户ID*/
@property (nonatomic, assign) int userId;
/**详细地址*/
@property (nonatomic, copy) NSString *address;
/**创建时间*/
@property (nonatomic, copy) NSString *createTime;
/**市*/
@property (nonatomic, copy) NSString *city;
/**区编号*/
@property (nonatomic, copy) NSString *districtCode;
/**区*/
@property (nonatomic, copy) NSString *district;
/**收货人姓名*/
@property (nonatomic, copy) NSString *name;
/**更新时间*/
@property (nonatomic, copy) NSString *updateTime;
/**cell高度*/
@property (nonatomic,assign) CGFloat rowHight;
@end
