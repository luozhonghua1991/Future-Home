//
//  FHCustomerServiceCommitController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/25.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHCustomerServiceCommitController.h"

@interface FHCustomerServiceCommitController ()
/** <#strong属性注释#> */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FHCustomerServiceCommitController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    self.conversationMessageCollectionView.frame = CGRectMake(0, MainSizeHeight + 135, SCREEN_WIDTH, SCREEN_HEIGHT - 135 - MainSizeHeight);
}

////隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)phoneClick {
    /** 拨打电话 */
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.shopMobieString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self.view addSubview:callWebview];
}


#pragma mark — setter && getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainSizeHeight + 80, SCREEN_WIDTH, 45)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        NSString *titleString = [NSString stringWithFormat:@"商家客服电话: %@",self.shopMobieString] ;
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
//        if (self.shopMobieString.length <= 0) {
////            [attributedTitle changeColor:[UIColor blueColor] rang:[attributedTitle changeSystemFontFloat:15 from:8 legth:0]];
//            _titleLabel.attributedText = titleString;
//        } else {
            [attributedTitle changeColor:[UIColor blueColor] rang:[attributedTitle changeSystemFontFloat:15 from:8 legth:self.shopMobieString.length]];
            _titleLabel.attributedText = attributedTitle;
//        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneClick)];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}

@end
