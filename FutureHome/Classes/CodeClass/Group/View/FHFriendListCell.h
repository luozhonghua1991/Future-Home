//
//  FHFriendListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHFollowListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FHFriendListCell : UITableViewCell
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 是否关注的按钮 */
@property (nonatomic, strong) UIButton *followOrNoBtn;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHFollowListModel *followListModel;


@end

NS_ASSUME_NONNULL_END
