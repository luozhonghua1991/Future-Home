//
//  GNRShoppingBar.h
//  外卖
//
//  Created by LvYuan on 2017/5/3.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNRCartDefine.h"
#import "GNRShoppingBarView.h"

@class GNRGoodsListModel;

@protocol GNRShoppingBarDelegate <NSObject>

@optional // 可选实现的方法
//支付的事件
- (void)GNRShoppingBarDelegatePayAction;

@end



@interface GNRShoppingBar : UIView

@property (nonatomic, assign)GNRShoppingBarStyle style;
@property (nonatomic, strong)GNRGoodsListModel * goodsList;
@property (nonatomic, strong)GNRShoppingCartView * cartView;
@property (nonatomic, strong)GNRShoppingBarView * shoppingBarView;

@property(nonatomic, weak) id<GNRShoppingBarDelegate> delegate;

+ (CGFloat)defaultHeight;

+ (instancetype)barWithStyle:(GNRShoppingBarStyle)style showInView:(UIView *)view;

- (void)refreshCartBar;
- (void)reloadData;

@end
