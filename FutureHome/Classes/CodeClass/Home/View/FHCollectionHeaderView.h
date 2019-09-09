//
//  FHCollectionHeaderView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHCollectionHeaderView : UIView
/** <#strong属性注释#> */
@property (nonatomic, strong) NSArray *leftNameArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSArray *rightNameArrs;

- (instancetype)initWithFrame:(CGRect)frame numberCount:(NSInteger )numberCount;

@end

NS_ASSUME_NONNULL_END
