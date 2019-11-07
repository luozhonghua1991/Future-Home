//
//  FHCandidateListModel.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHCandidateListModel.h"

@implementation FHCandidateListModel

- (NSString *)getFull {
    if (self.is_full == 1) {
        return @"兼职";
    } else if (self.is_full == 2) {
        return @"全职";
    }
    return @"";
}

- (NSString *)getSex {
    if (self.sex == 1) {
        return @"男";
    } else if (self.sex == 2) {
        return @"女";
    }
    return @"";
}

@end
