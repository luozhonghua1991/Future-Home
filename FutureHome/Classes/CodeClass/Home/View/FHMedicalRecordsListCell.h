//
//  FHMedicalRecordsListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHHealthMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMedicalRecordsListCell : UITableViewCell
/** 名字label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 手机号码label */
@property (nonatomic, strong) UILabel *phoneNumberLabel;
/** 身份证号label */
@property (nonatomic, strong) UILabel *personCodeLabel;
/** 社保 */
@property (nonatomic, strong) UILabel *codeLabel;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHHealthMemberModel *model;

@end

NS_ASSUME_NONNULL_END
