//
//  FHCommitDetaolCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHCommitModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FHCommitDetaolCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
- (void)fh_FHCommitDetaolCellDelegateSelectHeaderViewModel:(FHCommitModel *)model;

@end

@interface FHCommitDetaolCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommitModel *commitModel;

@property(nonatomic, weak) id<FHCommitDetaolCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
