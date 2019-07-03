//
//  RWTextField.m
//  RWGame
//
//  Created by luozhonghua on 2018/7/19.
//  Copyright © 2018年 chao.liu. All rights reserved.
//

#import "RWTextField.h"

@implementation RWTextField

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [self valueForKey:@"_clearButton"];
        [button setImage:[UIImage imageNamed:@"icon_blueclear"] forState:UIControlStateNormal];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

@end
