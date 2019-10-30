//
//  FHMyIndustryCommitteeController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  我的业委界面

#import "FHMyIndustryCommitteeController.h"
#import "FHOwnerCertificationViewController.h"

@interface FHMyIndustryCommitteeController ()
/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 提交资料 */
@property (nonatomic, strong) UIButton *compliteBtn;
/** 申请账号 */
@property (nonatomic, strong) UIButton *numerBtn;


@end

@implementation FHMyIndustryCommitteeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self fh_creatUI];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"我的业委";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fh_creatUI {
    [self.view addSubview:self.logoLabel];
    self.compliteBtn = [self creaBtnWithBtnTitle:@"提交业主资料料认证" frame:CGRectMake(10, MaxY(self.logoLabel) + 50, SCREEN_WIDTH - 20, 45) tag:0];
    [self.view addSubview:self.compliteBtn];
    self.numerBtn = [self creaBtnWithBtnTitle:@"申请业主服务账号" frame:CGRectMake(10, MaxY(self.compliteBtn) + 25, SCREEN_WIDTH - 20, 45) tag:1];
    [self.view addSubview:self.numerBtn];
}

- (UIButton *)creaBtnWithBtnTitle:(NSString *)title frame:(CGRect )frame tag:(NSInteger )tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:HEX_COLOR(0x1296db)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 22.5;
    button.layer.masksToBounds = YES;
    return button;
}

- (void)bottonClick:(UIButton *)sender {
    if (sender.tag == 0) {
        /** 业主资料认证 */
//        [self viewControllerPushOther:@"FHOwnerCertificationViewController"];
        FHOwnerCertificationViewController *vc = [[FHOwnerCertificationViewController alloc] init];
        vc.property_id = self.property_id;
        vc.hidesBottomBarWhenPushed = YES;
        vc.path = @"owner";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
         [self viewControllerPushOther:@"FHAccountApplyController"];
    }
}

#pragma mark —- setter && getter
- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, MainSizeHeight + 100, SCREEN_WIDTH - 10, 50)];
        _logoLabel.font = [UIFont systemFontOfSize:13];
        _logoLabel.text = @"您目目前没有添加任何业主认证信息，如果是业主，您可以提交业主资料料认证便便于享受更更多业主权利。";
        _logoLabel.textColor = [UIColor blackColor];
        _logoLabel.numberOfLines = 2;
        _logoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _logoLabel;
}

@end
