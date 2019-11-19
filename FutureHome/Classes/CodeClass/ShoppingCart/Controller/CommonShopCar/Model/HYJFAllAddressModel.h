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
@property (nonatomic, copy) NSString *mobile;
/**省编号*/
@property (nonatomic, copy) NSString *province_id;
/**市编号*/
@property (nonatomic, copy) NSString *city_id;
/**区编号*/
@property (nonatomic, copy) NSString *area_id;
/**省*/
@property (nonatomic, copy) NSString *provincename;
/**市*/
@property (nonatomic, copy) NSString *cityname;
/**区*/
@property (nonatomic, copy) NSString *areaname;
/**详细地址*/
@property (nonatomic, copy) NSString *address;
/**创建时间*/
@property (nonatomic, copy) NSString *createTime;
/**收货人姓名*/
@property (nonatomic, copy) NSString *name;
/**更新时间*/
@property (nonatomic, copy) NSString *updateTime;
/**cell高度*/
@property (nonatomic,assign) CGFloat rowHight;

@end
