//
//  FHElectionListController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHElectionListController : BaseViewController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *titleString;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *owner_id;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *pid;
/** 海选人最大数量 */
@property (nonatomic, assign) NSInteger candidate_number;
/** 岗位选举人最大数量 */
@property (nonatomic, assign) NSInteger election_number;


@end

NS_ASSUME_NONNULL_END
