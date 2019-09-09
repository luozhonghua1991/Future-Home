//
//  FHOtherFollowCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHOtherFollowCell : UITableViewCell
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 收藏时间label */
@property (nonatomic, strong) UILabel *timeLabel;
/** 内容label */
@property (nonatomic, strong) UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
