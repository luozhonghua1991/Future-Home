//
//  FHElectionListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHCandidateListModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol FHElectionListCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
- (void)fh_FHElectionListCellDelegateSelectModel:(FHCandidateListModel *)model;

@end


@interface FHElectionListCell : UITableViewCell
/** 选择 */
@property (nonatomic, strong) UILabel *selectLabel;
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 选举列表数据 */
@property (nonatomic, strong) FHCandidateListModel *candidateListModel;

@property(nonatomic, weak) id<FHElectionListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
