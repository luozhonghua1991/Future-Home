//
//  FHNewWatiingOrderCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FHGoodsListModel;

NS_ASSUME_NONNULL_BEGIN

@interface FHNewWatiingOrderCell : UITableViewCell
/** strong属性注释 */
@property (nonatomic, strong) FHGoodsListModel *listModel;
/** 图片 */
@property (nonatomic, copy) NSArray *goodsImgArrs;
/** 类型状态按钮 */
@property (nonatomic, strong) UIButton *statueBtn;
/** 类型按钮 */
@property (nonatomic, strong) UIButton *typeBtn;

@end

NS_ASSUME_NONNULL_END
