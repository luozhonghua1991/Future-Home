//
//  LoginView.h
//  RWGame
//
//  Created by liuchao on 2017/6/28.
//  Copyright © 2017年 chao.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginView;

@protocol LoginViewDelegate <NSObject>
@optional

- (void)loginView:(LoginView *)view withName:(NSString *)name;

@end

@interface LoginView : UIView
/** 左标题 */
@property (nonatomic, strong) UILabel *leftTitle;
/** 右标题 */
@property (nonatomic, strong) UILabel *rightTitle;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *underButton;
/** 注册按钮 */
@property (nonatomic, strong) UIButton *rigisterBtn;

/** 代理 */
@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end
