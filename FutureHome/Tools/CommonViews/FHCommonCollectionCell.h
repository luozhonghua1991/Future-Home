//
//  FHCommonCollectionCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCommonCollectionCell : UICollectionViewCell
/** 图标 */
@property (nonatomic, strong) UIImageView *logoImgView;
/** 名字 */
@property (nonatomic, strong) UILabel *listNameLabel;

@end

NS_ASSUME_NONNULL_END
