//
//  GNRCartGoodsCell.h
//  外卖
//
//  Created by LvYuan on 2017/5/3.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNRCartDefine.h"

@interface GNRCartGoodsCell : UITableViewCell
@property (weak, nonatomic) id<GNRGoodsNumberChangedDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//@property (weak, nonatomic) IBOutlet UIView *stepperSuperView;
@property (strong, nonatomic) UIView *stepperSuperView;
@property (nonatomic, strong)GNRCountStepper * stepper;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL isClosed;

- (void)config:(GNRGoodsModel *)goods;

@end
