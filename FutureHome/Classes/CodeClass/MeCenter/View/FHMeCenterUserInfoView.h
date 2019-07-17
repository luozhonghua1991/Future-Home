//
//  FHMeCenterUserInfoView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHUserInfoHeaderBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHMeCenterUserInfoView : UIView
/** 用户头像 */
@property (nonatomic, strong) UIImageView *userHeaderImgView;
/** 用户名字label */
@property (nonatomic, strong) UILabel *userNameLabel;
/** 未来家园账号label */
@property (nonatomic, strong) UILabel *futureHomeCodeLabel;
/** 二维码图标 */
@property (nonatomic, strong) UIImageView *codeImgView;
/** 好友 */
@property (nonatomic, strong) FHUserInfoHeaderBaseView *friendView;
/** 群组 */
@property (nonatomic, strong) FHUserInfoHeaderBaseView *groupView;
/** 商家关注 */
@property (nonatomic, strong) FHUserInfoHeaderBaseView *followView;
/** 我的动态 */
@property (nonatomic, strong) FHUserInfoHeaderBaseView *myView;

@end

NS_ASSUME_NONNULL_END
