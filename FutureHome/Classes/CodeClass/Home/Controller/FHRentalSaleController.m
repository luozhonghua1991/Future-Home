//
//  FHRentalSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/5.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHRentalSaleController.h"
#import "FHHousingRentOrSaleController.h"
#import "FHCarRentOrSaleController.h"

@interface FHRentalSaleController ()

@end

@implementation FHRentalSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ZH_SCALE_SCREEN_Height(120), ScreenWidth, 50)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"认证业主信息完成后\n方可发布出售出租信息";
    label.textColor = HEX_COLOR(0x1296db);
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    CGFloat btnHeight = 50;
    UIButton *btn1 = [self creatButtonWithFrame:CGRectMake(10, MaxY(label) + 20, SCREEN_WIDTH / 2 - 25, btnHeight) name:@"前往发布房屋出售信息" tag:1];
    UIButton *btn2 = [self creatButtonWithFrame:CGRectMake(MaxX(btn1) + 30, MaxY(label) + 20, SCREEN_WIDTH / 2 - 25, btnHeight) name:@"前往发布房屋出租信息" tag:2];
    UIButton *btn3 = [self creatButtonWithFrame:CGRectMake(10, MaxY(btn1) + 40, SCREEN_WIDTH / 2 - 25, btnHeight) name:@"前往发布车位出售信息" tag:3];
    UIButton *btn4 = [self creatButtonWithFrame:CGRectMake(MaxX(btn3) + 30, MaxY(btn1) + 40, SCREEN_WIDTH / 2 - 25, btnHeight) name:@"前往发布车位出租信息" tag:4];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
}

- (void)setAuthModel:(FHAuthModel *)authModel {
    _authModel = authModel;
}

- (UIButton *)creatButtonWithFrame:(CGRect )frame
                              name:(NSString *)title
                               tag:(NSInteger )tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = tag;
    
    if (!(self.authModel.audit_status == 2)) {
        button.enabled = NO;
        button.backgroundColor = [UIColor lightGrayColor];
    } else {
        button.enabled = YES;
        button.backgroundColor = HEX_COLOR(0x1296db);
    }
    
    return button;
}


- (void)buttonClick:(UIButton *)sender {
    /** 判断用户是否登录过 没登录去登录 */
    if (![AccountStorage isExistsToKen]) {
        [FHLoginTool fh_makePersonToLoging];
        return;
    }
    if (sender.tag == 1) {
        FHHousingRentOrSaleController *vc = [[FHHousingRentOrSaleController alloc] init];
        vc.titleString = @"发布房屋出售信息";
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = 1;
        vc.property_id = self.property_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 2) {
        FHHousingRentOrSaleController *vc = [[FHHousingRentOrSaleController alloc] init];
        vc.titleString = @"发布房屋出租信息";
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = 2;
        vc.property_id = self.property_id;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if (sender.tag == 3) {
        FHCarRentOrSaleController *vc = [[FHCarRentOrSaleController alloc] init];
        vc.titleString = @"发布车位出售信息";
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = 1;
        vc.property_id = self.property_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 4) {
        FHCarRentOrSaleController *vc = [[FHCarRentOrSaleController alloc] init];
        vc.titleString = @"发布车位出租信息";
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = 2;
        vc.property_id = self.property_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
