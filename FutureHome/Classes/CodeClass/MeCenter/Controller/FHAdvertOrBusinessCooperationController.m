//
//  FHAdvertOrBusinessCooperationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/4.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  广告/上午合作界面

#import "FHAdvertOrBusinessCooperationController.h"

@interface FHAdvertOrBusinessCooperationController ()
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *logLabel;
/** 提交成功的提示 */
@property (nonatomic, strong) UILabel *successLabel;
/** 成功提交按钮 */
@property (nonatomic, strong) UIButton *successBtn;

@end

@implementation FHAdvertOrBusinessCooperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fh_creatNav];
    [self createSegmentControl];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"广告/商务合作";
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


#pragma mark - Create Segmented Control
- (void)createSegmentControl{
    //先生成存放标题的数据
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"广告合作", @"服务商合作", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    //设置frame
    segmentedControl.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 40);
    
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor blueColor];
    
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    [self.view addSubview:self.selectBtn];
    [self.selectBtn setTitle:@"开始广告合作" forState:UIControlStateNormal];
    [self.view addSubview:self.logLabel];
    self.logLabel.text = @"温馨提示:想了解更多广告信息，请访问http:/ /tongximedia.com";
    
    [self.view addSubview:self.successBtn];
}


#pragma mark — event
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            [self.selectBtn setTitle:@"开始广告合作" forState:UIControlStateNormal];
            self.logLabel.text = @"温馨提示:想了解更多广告信息，请访问http:/ /tongximedia.com";
            break;
            
        case 1:
            [self.selectBtn setTitle:@"申请服务商合作" forState:UIControlStateNormal];
            self.logLabel.text = @"温馨提示:申请服务商平台合作，需要支付授权牌照制作及审核服务费Y2000元，此外无其他任何费用。未能成功签订服务商合作协议，费用将全部立即退还，";
            break;
            
        default:
            break;
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

#pragma mark — setter && getter
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, 400, 200, 50);
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
        _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, SCREEN_HEIGHT - 120, SCREEN_WIDTH - 80, 90)];
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


- (UIButton *)successBtn {
    if (!_successBtn) {
        _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _successBtn.frame = CGRectMake(100, 600, (SCREEN_WIDTH - 200), 80);
        [_successBtn setTitle:@"确认完成" forState:UIControlStateNormal];
        [_successBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _successBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [_successBtn setBackgroundColor:[UIColor greenColor]];
//        [_successBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successBtn;
}

@end
