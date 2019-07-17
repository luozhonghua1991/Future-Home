//
//  GNRGoodsListCell.h
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNRCartDefine.h"


@interface GNRGoodsListCell : UITableViewCell
@property (weak, nonatomic) id<GNRGoodsNumberChangedDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
//产地
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
//@property (weak, nonatomic) IBOutlet UIView *stepperSuperView;
@property (strong, nonatomic) UIView *stepperSuperView;
/** 规格 */
@property (nonatomic, strong) UILabel *specsLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 库存 */
@property (nonatomic, strong) UILabel *stockLabel;

@property (strong, nonatomic)GNRCountStepper * stepper;
@property (strong, nonatomic)GNRGoodsModel * goods;

@end
