//
//  FHFollowListViewCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHFollowListViewCell : UITableViewCell
/** 标题图片 */
@property (nonatomic, strong) UIImageView *logoImgView;
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 来源 */
@property (nonatomic, strong) UILabel *comeFromLabel;
/** 时间label */
@property (nonatomic, strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
