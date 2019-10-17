//
//  FHServiceCommonHeaderView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHServiceCommonHeaderView : UIView
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 商店名字 */
@property (nonatomic, strong) UILabel *shopNameLabel;
/** 编号label */
@property (nonatomic, strong) UILabel *codeLabel;
/** 粉丝label */
@property (nonatomic, strong) UILabel *fansLabel;
/** 数量label */
@property (nonatomic, strong) UILabel *countLabel;
/** 点赞数量 */
@property (nonatomic, strong) UILabel *upCountLabel;
/** 用户评分按钮 */
@property (nonatomic, strong) UIButton *personCountBtn;
/** 底部线 */
@property (nonatomic, strong) UIView *bottomLineView;


@end

NS_ASSUME_NONNULL_END
