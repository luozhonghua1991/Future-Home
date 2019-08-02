//
//  FHPrivacySettingsCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHPrivacySettingsCell : UITableViewCell
/** 名字 */
@property (nonatomic, strong) UILabel *logoLabel;
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
