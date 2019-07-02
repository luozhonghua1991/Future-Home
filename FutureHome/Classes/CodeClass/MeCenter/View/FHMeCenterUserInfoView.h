//
//  FHMeCenterUserInfoView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHMeCenterUserInfoView : UIView
/** 用户头像 */
@property (nonatomic, strong) UIImageView *userHeaderImgView;
/** 用户名字label */
@property (nonatomic, strong) UILabel *userNameLabel;
/** 二维码图标 */
@property (nonatomic, strong) UIImageView *codeImgView;

@end

NS_ASSUME_NONNULL_END
