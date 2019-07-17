//
//  FHMyAccountCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHMyAccountCell : UITableViewCell
/** 标题label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImg;
/** 右边剪头图 */
@property (nonatomic, strong) UIImageView *rightArrowImg;
/** 内容label */
@property (nonatomic, strong) UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
