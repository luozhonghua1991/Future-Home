//
//  FHheadercCollectioCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHheadercCollectioCell : UICollectionViewCell
/** 个数 */
@property (nonatomic, assign) NSInteger numberCount;
/** 左边的label名字 */
@property (nonatomic, strong) UILabel *leftLabel;
/** 右边的label名字 */
@property (nonatomic, strong) UILabel *rightLabel;

@end

NS_ASSUME_NONNULL_END
