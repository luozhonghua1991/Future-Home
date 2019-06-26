//
//  FHCommonNavView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/26.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FHCommonNavViewDelegate <NSObject>

@optional // 可选实现的方法
/** 搜索的代理事件 */
- (void)FHCommonNavViewDelegateSearchClick;
/** 收藏的代理事件 */
- (void)FHCommonNavViewDelegateCollectClick;

@end

//定义一个搜索的block
typedef void(^FHSearchBlock)(void);

//定义一个收藏的block
typedef void(^FHCollectBlock)(void);

@interface FHCommonNavView : UIView
/** 搜索的block */
@property (nonatomic, copy)FHSearchBlock searchBlock;
/** 搜索的block */
@property (nonatomic, copy)FHCollectBlock collectBlock;

@property(nonatomic, weak) id<FHCommonNavViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
