//
//  FHBlackListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHBlackListCell : UITableViewCell
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;

@end

NS_ASSUME_NONNULL_END
