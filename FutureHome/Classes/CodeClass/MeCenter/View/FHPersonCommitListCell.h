//
//  FHPersonCommitListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJCommit;
NS_ASSUME_NONNULL_BEGIN

@interface FHPersonCommitListCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;

@property(nonatomic ,weak) UIViewController      *weakSelf;

@end

NS_ASSUME_NONNULL_END
