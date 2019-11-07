//
//  FHHealthMemberModel.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHHealthMemberModel.h"

@implementation FHHealthMemberModel

- (NSString *)getSex {
    if (self.sex == 1) {
        return @"男";
    } else if (self.sex == 2) {
        return @"女";
    }
    return @"";
}

@end
