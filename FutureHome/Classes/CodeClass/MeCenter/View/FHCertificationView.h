//
//  FHCertificationView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCertificationView : UIView
/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 内容TF */
@property (nonatomic, strong) UITextField *contentTF;
/** 底部的线 */
@property (nonatomic, strong) UIView *bottomLineView;


@end

NS_ASSUME_NONNULL_END
