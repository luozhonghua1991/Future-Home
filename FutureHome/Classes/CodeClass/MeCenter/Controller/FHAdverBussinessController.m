//
//  FHAdverBussinessController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/9.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHAdverBussinessController.h"

@interface FHAdverBussinessController ()
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *logLabel;
/** 提交成功的提示 */
@property (nonatomic, strong) UILabel *successLabel;
/** 成功提交按钮 */
@property (nonatomic, strong) UIButton *successBtn;

@end

@implementation FHAdverBussinessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buySuccess) name:@"BUYSUCCESS" object:nil];
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.logLabel];
    if (self.type == 1) {
        [self.selectBtn setTitle:@"开始广告合作" forState:UIControlStateNormal];
        self.logLabel.text = @"温馨提示:想了解更多广告信息，请访问http:/ /tongximedia.com";
        
    } else {
        [self.selectBtn setTitle:@"申请服务商合作" forState:UIControlStateNormal];
        self.logLabel.text = @"温馨提示:申请服务商平台合作，需要支付授权牌照制作及审核服务费Y2000元，此外无其他任何费用。未能成功签订服务商合作协议，费用将全部立即退还，";
    }
}


- (void)selectBtnClick:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"开始广告合作"]) {
        //开始广告合作
        [self viewControllerPushOther:@"FHAdvertisingCooperationController"];
    } else {
        //开始商务合作
        [self viewControllerPushOther:@"FHServiceProviderCooperationController"];
    }
}

- (void)buySuccess {
    self.selectBtn.hidden = YES;
    self.logLabel.hidden = YES;
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.successBtn];
}

- (void)successBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark — setter && getter
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2 - 100, 200, 50);
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_selectBtn setBackgroundColor:[UIColor lightGrayColor]];
        _selectBtn.layer.borderWidth = 1;
        _selectBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _selectBtn.clipsToBounds = YES;
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)logLabel {
    if (!_logLabel) {
        _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, MaxY(_selectBtn) + 100, SCREEN_WIDTH - 80, 90)];
        _logLabel.font = [UIFont systemFontOfSize:13];
        _logLabel.textColor = [UIColor blackColor];
        _logLabel.textAlignment = NSTextAlignmentLeft;
        _logLabel.backgroundColor = [UIColor whiteColor];
        _logLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _logLabel.layer.borderWidth = 1;
        _logLabel.numberOfLines = 0;
    }
    return _logLabel;
}

- (UILabel *)successLabel {
    if (!_successLabel) {
        _successLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT / 2 - 200, SCREEN_WIDTH - 80, 90)];
        _successLabel.text = @"尊敬的⽤用户: \n      您的申请已经成功提交，平台会在3个⼯工作⽇日内完成审核，并将账号信息 发送到您的邮箱，请及时关注，谢谢!";
        _successLabel.font = [UIFont systemFontOfSize:15];
        _successLabel.textColor = [UIColor blackColor];
        _successLabel.textAlignment = NSTextAlignmentLeft;
        _successLabel.backgroundColor = [UIColor greenColor];
        _successLabel.layer.cornerRadius = 2;
        _successLabel.numberOfLines = 0;
    }
    return _successLabel;
}

- (UIButton *)successBtn {
    if (!_successBtn) {
        _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _successBtn.frame = CGRectMake(100, SCREEN_HEIGHT - 300, (SCREEN_WIDTH - 200), 80);
        [_successBtn setTitle:@"确认完成" forState:UIControlStateNormal];
        [_successBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _successBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [_successBtn setBackgroundColor:[UIColor greenColor]];
        [_successBtn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successBtn;
}

@end
