//
//  FHDetailAddressView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/19.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHDetailAddressView : UIView
/** 省市区数据 */
@property (nonatomic, strong) UILabel *leftProvinceDataLabel;
/** 省市区数据 */
@property (nonatomic, strong) UILabel *centerProvinceDataLabel;
/** 省市区数据 */
@property (nonatomic, strong) UILabel *rightProvinceDataLabel;

@end

NS_ASSUME_NONNULL_END
