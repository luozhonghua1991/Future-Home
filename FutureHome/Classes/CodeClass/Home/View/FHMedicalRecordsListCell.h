//
//  FHMedicalRecordsListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/22.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end

NS_ASSUME_NONNULL_END
