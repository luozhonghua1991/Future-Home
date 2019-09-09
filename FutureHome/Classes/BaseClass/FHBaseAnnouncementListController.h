//
//  FHBaseAnnouncementListController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHBaseAnnouncementListController : BaseViewController
/** 通用公告 */
@property (nonatomic, copy) NSString *titleString;
/** 是否有selectView */
@property (nonatomic, assign) BOOL isHaveSelectView;
/** 是否有HeaderView   默认有的*/
@property (nonatomic, assign) BOOL isNoHaveHeaderView;
/** 是否有区头   默认没有*/
@property (nonatomic, assign) BOOL isHaveSectionView;

@end

NS_ASSUME_NONNULL_END
