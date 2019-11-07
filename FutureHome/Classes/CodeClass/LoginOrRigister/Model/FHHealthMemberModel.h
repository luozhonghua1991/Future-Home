//
//  FHHealthMemberModel.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHHealthMemberModel : NSObject
/** 电话 */
@property (nonatomic, copy) NSString *mobile;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 身份证号 */
@property (nonatomic, copy) NSString *id_number;
/** datebirth出生日期 */
@property (nonatomic, copy) NSString *datebirth;
/** sex 1男  2女 */
@property (nonatomic, copy) NSString *getSex;
/** sex 1男  2女 */
@property (nonatomic, assign) NSInteger sex;
/** 社保卡号 */
@property (nonatomic, copy) NSString *social_number;
/** id */
@property (nonatomic, copy) NSString *id;

@end

NS_ASSUME_NONNULL_END
