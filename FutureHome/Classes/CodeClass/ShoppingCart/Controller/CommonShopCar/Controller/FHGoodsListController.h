//
//  FHGoodsListController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHGoodsListController : BaseViewController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *shopID;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *type;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat send_cost;

@end

NS_ASSUME_NONNULL_END
