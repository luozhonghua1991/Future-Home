//
//  FHMedicalHistoryCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHHealthHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMedicalHistoryCell : UITableViewCell
/** 名字label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 日期label */
@property (nonatomic, strong) UILabel *dateLabel;
/** 价格label */
@property (nonatomic, strong) UILabel *priceLabel;
/** 医院label */
@property (nonatomic, strong) UILabel *hospitalLabel;
/** 描述症状 */
@property (nonatomic, strong) UILabel *infoLabel;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHHealthHistoryModel *model;


@end

NS_ASSUME_NONNULL_END
