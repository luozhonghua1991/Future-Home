//
//  FHSelectGroupMemberController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GroupMemberType) {
    GroupMemberType_creatGroup = 1,
    GroupMemberType_addMember = 2,
    GroupMemberType_subMember = 3,
    GroupMemberType_allMemberList = 4,
};

@interface FHSelectGroupMemberController : BaseViewController
/** 标题 */
@property (nonatomic, copy) NSString *titleString;
/** 1创建群选择成员 2添加成员 3删除成员 4全体成员列表*/
@property (nonatomic, assign) GroupMemberType groupMemberType;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSArray *oldSelectPersonArrs;
/** 群id */
@property (nonatomic, copy) NSString *groupId;
/** 群名字 */
@property (nonatomic, copy) NSString *groupName;

@end

NS_ASSUME_NONNULL_END
