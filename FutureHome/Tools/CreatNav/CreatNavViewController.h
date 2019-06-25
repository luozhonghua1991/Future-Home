//
//  CreatNavViewController.h
//  SayU
//
//  Created by 杭州任性贸易有限公司 on 16/5/14.
//  Copyright © 2016年 xys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myButton.h"
typedef void(^knowButtonBlock) ();
typedef void(^rightButtonBlock) ();

@interface CreatNavViewController : UIViewController

@property (nonatomic,copy)knowButtonBlock blockKnow;
@property (nonatomic,copy)rightButtonBlock blockRight;

/** navigationView */
@property (nonatomic,strong)UIView *navigationView;
/** tiitleLab */
@property (nonatomic,strong)UILabel *tiitleLab;
/**lineView */
@property (nonatomic,strong) UIView *lineView;


/**
 *  通用导航栏
 */
+ (UIView *)creatResultNavigationBarView:(NSString *)strNavTitle frame
                                        :(CGRect)frame KnowBlock:(knowButtonBlock)knowBlock;

/**
 *  带有右按钮的导航栏
 */
+ (UIView *)creatRightNavigationBarView:(NSString *)strNavTitle
                             rightTitle:(NSString *)strRightTitle
                                  frame:(CGRect)frame
                              KnowBlock:(knowButtonBlock)knowBlock
                             RightBlock:(rightButtonBlock)rightBlock;
/**
 自定义导航栏颜色 左边按钮的文字样式

 @param strNavTitle 标题
 @param mainTitleColor 字体颜色
 @param strLeftTitle 左边按钮，如果后缀为.png .jpg .jpeg则为设置图片
 @param strRightTitle 右边按钮，如果后缀为.png .jpg .jpeg则为设置图片
  */
+(UIView *)creatSelfRightNavigationBarView:(NSString *)strNavTitle
                            mainTitleColor:(UIColor *)mainTitleColor
                                 leftTitle:(NSString *)strLeftTitle
                                rightTitle:(NSString *)strRightTitle
                                     frame:(CGRect)frame
                                 KnowBlock:(knowButtonBlock)knowBlock
                                RightBlock:(rightButtonBlock)rightBlock
                                     color:(UIColor *)color;
//获取导航栏标题label
+ (UILabel *)getNavLabel;
@end
