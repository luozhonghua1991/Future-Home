//
//  FHCommonPaySelectView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoneyButton;

NS_ASSUME_NONNULL_BEGIN

@protocol FHCommonPaySelectViewDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法

/** 1selectType微信 2支付宝 */
- (void)fh_selectPayTypeWIthTag:(NSInteger )selectType;

@end




@interface FHCommonPaySelectView : UIView

@property (nonatomic, strong) UIView *backgroungView;
/*
 * 支付弹窗展示控件
 */
@property (nonatomic, strong) UILabel * headTitleLabel;  // 标题

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) MoneyButton *walltBtn;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *topLogoImgView;
/** 上面的选择按钮 */
@property (nonatomic, strong) MoneyButton *topSelectBtn;

@property (nonatomic, strong) MoneyButton *creditBtn;
@property (nonatomic, strong) UIImageView *bottomLogoImgView;
/** 下面的选择按钮 */
@property (nonatomic, strong) MoneyButton *bottomSelectBtn;

@property (nonatomic, strong) UIButton *online;

@property(nonatomic, weak) id<FHCommonPaySelectViewDelegate> delegate;

/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectType;
/** 展示类型 商店类型的只需要一行文字 */
@property (nonatomic, copy) NSString *showType;


-(UIView *)initWithFrame:(CGRect )frame
                nowPrice:(NSString *)nowPrice
                oldPrice:(NSString *)oldPrice
              discounted:(NSString *)discounted;

@end

NS_ASSUME_NONNULL_END
