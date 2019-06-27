//
//  FHLittleMenuListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FHLittleMenuListCellDelegate <NSObject>

@optional // 可选实现的方法

- (void)FHLittleMenuListCellSelectIndex:(NSIndexPath *)selectIndex;

@end



@interface FHLittleMenuListCell : UITableViewCell

@property(nonatomic, weak) id<FHLittleMenuListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
