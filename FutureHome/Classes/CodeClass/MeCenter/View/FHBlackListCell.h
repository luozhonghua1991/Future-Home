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
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *headerImg;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteBtn;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger numberCount;

@end

NS_ASSUME_NONNULL_END
