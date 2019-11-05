//
//  ZJHavePhotoCell.h
//  ZJKitTool
//
//  Created by 同熙传媒 on 2019/11/1.
//  Copyright © 2019 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZJCommit;

@protocol ZJNoHavePhotoCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法

- (void)fh_ZJNoHavePhotoCellSelectModel:(ZJCommit *)model;

@end

@interface ZJNoHavePhotoCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;

@property(nonatomic, weak) id<ZJNoHavePhotoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
