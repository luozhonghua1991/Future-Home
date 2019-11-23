//
//  FHDialogueRecordController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  对话记录

#import "FHDialogueRecordController.h"

@interface FHDialogueRecordController ()
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *phone;

@end

@implementation FHDialogueRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phone = @"13849132460";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, MainSizeHeight + 80, SCREEN_WIDTH, 15);
    [button setTitle:[NSString stringWithFormat:@"商家电话: %@",self.phone] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)buttonClick {
    /** 拨打电话 */
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self.view addSubview:callWebview];
}


@end
