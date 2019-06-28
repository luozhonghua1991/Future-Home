//
//  FHMenuListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/25.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FHMenuListCellDelegate <NSObject>

@optional // 可选实现的方法
- (void)FHMenuListCellSelectIndex:(NSIndexPath *)indexPath;

@end

@interface FHMenuListCell : UITableViewCell

@property(nonatomic, weak) id<FHMenuListCellDelegate> delegate;
/** 下面的logoName */
@property (nonatomic, copy) NSArray *bottomLogoNameArrs;

@end

NS_ASSUME_NONNULL_END
