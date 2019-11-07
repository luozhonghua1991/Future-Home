//
//  FHSearchResultCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FHSearchResultModel;

@interface FHSearchResultCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHSearchResultModel *resultModel;
/** 右边的按钮 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 距离label */
@property (nonatomic, strong) UILabel *distanceLabel;


@end

NS_ASSUME_NONNULL_END
