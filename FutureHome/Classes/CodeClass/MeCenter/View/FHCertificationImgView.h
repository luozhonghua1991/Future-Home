//
//  FHCertificationImgView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/17.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FHCertificationImgView;
NS_ASSUME_NONNULL_BEGIN

@protocol FHCertificationImgViewDelegate <NSObject>
@required // 必须实现的方法 默认
@optional // 可选实现的方法
- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger )index;

- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger )index view:(UIView *)view;

@end

@interface FHCertificationImgView : UIView
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *leftImgView;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *centerImgView;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *rightImgView;

@property(nonatomic, weak) id<FHCertificationImgViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
