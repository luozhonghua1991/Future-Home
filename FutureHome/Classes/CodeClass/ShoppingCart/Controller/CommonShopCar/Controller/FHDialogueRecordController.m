//
//  FHDialogueRecordController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  对话记录

#import "FHDialogueRecordController.h"

@interface FHDialogueRecordController ()

@end

@implementation FHDialogueRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([SingleManager shareManager].shoppingBar) {
        [[SingleManager shareManager].shoppingBar removeFromSuperview];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
