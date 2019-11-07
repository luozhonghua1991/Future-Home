//
//  FHSearchResultController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHSearchResultController : BaseViewController
/** 搜索关键字 */
@property (nonatomic, copy) NSString *searchText;
/** 类型 */
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
