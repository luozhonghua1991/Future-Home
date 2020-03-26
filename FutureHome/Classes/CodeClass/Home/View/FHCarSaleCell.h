//
//  FHCarSaleCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHListDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHCarSaleCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHListDetailModel *detailModel;
/** 0房屋出售 1房屋出租 2车位出售 3车位出租 */
@property (nonatomic, assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END
