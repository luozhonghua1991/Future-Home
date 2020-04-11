//
//  FHZJHaveMoveCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZJCommit;

@protocol FHZJHaveMoveCellDelagate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
- (void)fh_ZJHaveMoveCellDelagateSelectModel:(ZJCommit *)Model;
/** 选择视频的点击方法 */
- (void)fh_ZJHaveMoveCellDelagateSelectMovieModel:(ZJCommit *)Model;
/** 点赞 */
- (void)fh_ZJHaveMoveCellDelagateSelectLikeWithModel:(ZJCommit *)Model
                                             withBtn:(UIButton *)btn;

@end


@interface FHZJHaveMoveCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;

@property(nonatomic, weak) id<FHZJHaveMoveCellDelagate> delegate;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL isNoUpdateBtn;

@end

NS_ASSUME_NONNULL_END
