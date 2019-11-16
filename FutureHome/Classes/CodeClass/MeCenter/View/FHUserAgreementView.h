//
//  FHUserAgreementView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FHUserAgreementViewDelegate <NSObject>
@required // 必须实现的方法 默认
@optional //
/** 用户协议的点击方法 */
- (void)FHUserAgreementViewClick;

/** 确定协议的按钮 */
- (void)fh_fhuserAgreementWithBtn:(UIButton *)sender;

@end

@interface FHUserAgreementView : UIView

@property(nonatomic, weak) id<FHUserAgreementViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
