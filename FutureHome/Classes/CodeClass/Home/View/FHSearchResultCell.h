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

@protocol FHSearchResultCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
- (void)fh_selectAvaterWithModel:(FHSearchResultModel *)model;

@end

@interface FHSearchResultCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHSearchResultModel *resultModel;
/** 右边的按钮 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 距离label */
@property (nonatomic, strong) UILabel *distanceLabel;

@property(nonatomic, weak) id<FHSearchResultCellDelegate> delegate;
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;

@end

NS_ASSUME_NONNULL_END
