//
//  FHAccountApplicationTFView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/15.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHAccountApplicationTFView : UIView
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容文本框 */
@property (nonatomic, strong) UITextField *contentTF;

@end

NS_ASSUME_NONNULL_END
