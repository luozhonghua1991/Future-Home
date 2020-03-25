//
//  FHHouseSaleCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHHouseListModel.h"
#import "FHReleaseManagemengModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHHouseSaleCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHHouseListModel *houseListModel;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHReleaseManagemengModel *managementModel;
/** 价格label */
@property (nonatomic, strong) UILabel *priceLabel;
/** 房子名称 */
@property (nonatomic, strong) UILabel *houseNameLabel;
/** 房子类型 */
@property (nonatomic, strong) UILabel *houseTypeLabel;
/** 付款要求 */
@property (nonatomic, strong) UILabel *priceSugmentLabel;

@end

NS_ASSUME_NONNULL_END
