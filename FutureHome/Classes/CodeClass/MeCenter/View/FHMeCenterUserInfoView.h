//
//  FHMeCenterUserInfoView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHUserInfoHeaderBaseView.h"
#import "FHScanDetailAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FHMeCenterUserInfoViewDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
- (void)fh_personCodeTapCLick;

@end

@interface FHMeCenterUserInfoView : UIView
/** 用户头像 */
@property (nonatomic, strong) UIImageView *userHeaderImgView;
/** 实名认证图片 */
@property (nonatomic, strong) UIImageView *realNameImg;
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
/** <#strong属性注释#> */
@property (nonatomic, strong) FHScanDetailAlertView *codeDetailView;

@property(nonatomic, weak) id<FHMeCenterUserInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
