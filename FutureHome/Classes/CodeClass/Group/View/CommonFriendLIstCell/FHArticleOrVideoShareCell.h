//
//  FHArticleOrVideoShareCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2020/1/10.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZJCommit;
@protocol FHArticleOrVideoShareCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
/** 点赞 */
- (void)artileOrVideoShareLikeClickWithModel:(ZJCommit *)model
                                     withBtn:(UIButton *)btn;
/** 点击头像 */
- (void)artileOrVideoShareAvaterClickWithModel:(ZJCommit *)model;
/** 点击查看详情 */
- (void)artileOrVideoShareInfoDetailCLickWithModel:(ZJCommit *)model
                                              type:(NSInteger )type;

@end

@interface FHArticleOrVideoShareCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;

@property(nonatomic, weak) id<FHArticleOrVideoShareCellDelegate> delegate;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL isNoUpdateBtn;

@end

NS_ASSUME_NONNULL_END
