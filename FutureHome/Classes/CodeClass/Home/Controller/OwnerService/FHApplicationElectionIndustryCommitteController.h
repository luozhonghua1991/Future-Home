//
//  FHApplicationElectionIndustryCommitteController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "FHCandidateListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHApplicationElectionIndustryCommitteController : BaseViewController
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger property_id;
/** 第几届的物业大会 */
@property (nonatomic, copy) NSString *pid;
/** 标题 */
@property (nonatomic, copy) NSString *titleString;
/** 用户的model数据 */
@property (nonatomic, strong) FHCandidateListModel *personModel;


@end

NS_ASSUME_NONNULL_END
