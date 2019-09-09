//
//  FHCollectListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/8.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCollectListCell : UITableViewCell
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 距离label */
@property (nonatomic, strong) UILabel *distanceLabel;
/** 内容label */
@property (nonatomic, strong) UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
