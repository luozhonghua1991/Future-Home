//
//  FHWatingOrderCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FHOrderListModel;

NS_ASSUME_NONNULL_BEGIN

@interface FHWatingOrderCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *topLineView;
/** 商品图片 */
@property (nonatomic, strong) UIImageView *shopImgView;
/** 商品名字 */
@property (nonatomic, strong) UILabel *shopNameLabel;
/** 价格和数量label */
@property (nonatomic, strong) UILabel *contentLabel;
/** 同一物品总价 */
@property (nonatomic, strong) UILabel *allPriceLabel;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIView *bottomLineView;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHOrderListModel *orderModel;


@end

NS_ASSUME_NONNULL_END
