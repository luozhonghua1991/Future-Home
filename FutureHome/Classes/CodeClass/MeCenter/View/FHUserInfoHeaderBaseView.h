//
//  FHUserInfoHeaderBaseView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHUserInfoHeaderBaseView : UIView
/** 上面的label */
@property (nonatomic, strong) UILabel *topLogLabel;
/** 下面的label */
@property (nonatomic, strong) UILabel *bottomLogLabel;

@end

NS_ASSUME_NONNULL_END
