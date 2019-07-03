//
//  FHLoginTool.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/3.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHLoginTool.h"
#import "CurrentViewController.h"
#import "FHLoginController.h"

@implementation FHLoginTool

+ (void)fh_makePersonToLoging {
    //压栈方式 登录界面
    FHLoginController *login = [[FHLoginController alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    [[CurrentViewController topViewController].navigationController pushViewController:login animated:YES];
}

@end
