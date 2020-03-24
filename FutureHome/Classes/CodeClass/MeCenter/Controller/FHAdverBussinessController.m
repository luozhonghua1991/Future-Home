//
//  FHAdverBussinessController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/9.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHAdverBussinessController.h"
#import "FHLosProtocolModel.h"
#import "FHAdvertisingCooperationController.h"
#import "FHServiceProviderCooperationController.h"

@interface FHAdverBussinessController ()
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 提示label */
@property (nonatomic, strong) UILabel *logLabel;
/** 提交成功的提示 */
@property (nonatomic, strong) UILabel *successLabel;
/** 成功提交按钮 */
@property (nonatomic, strong) UIButton *successBtn;
/** 提示数组 */
@property (nonatomic, strong) NSMutableArray *tipsArrs;

/** 里面的注释 */
@property (nonatomic, copy) NSString *tips2;
/** 跳转的链接 */
@property (nonatomic, copy) NSString *protocol;
/** 折扣率 */
@property (nonatomic, copy) NSString *discount;
/** 开通物业费价格 */
@property (nonatomic, copy) NSString *open;
/** 折扣价 */
@property (nonatomic, copy) NSString *price;

@end

@implementation FHAdverBussinessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAgreementTip];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buySuccess) name:@"BUYSUCCESS" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSuccess) name:@"UPDATESUCCESS" object:nil];
    
}

- (void)getAgreementTip {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",nil];
    
    [AFNetWorkTool get:@"future/getIosAdvent" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 广告合作 和 商务服务 */
            weakSelf.tipsArrs = [[NSMutableArray alloc] init];
            weakSelf.tipsArrs = [FHLosProtocolModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            [weakSelf setDataWithArr:self.tipsArrs];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)setDataWithArr:(NSArray *)arr {
    FHLosProtocolModel *protocolModel;
    if (self.type == 1) {
        [self.selectBtn setTitle:@"开始广告合作" forState:UIControlStateNormal];
        protocolModel = arr[0];
        [self setDataWithModel:protocolModel];
    } else {
        [self.selectBtn setTitle:@"申请服务商合作" forState:UIControlStateNormal];
        protocolModel = arr[1];
        [self setDataWithModel:protocolModel];
    }
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.logLabel];
}

- (void)setDataWithModel:(FHLosProtocolModel *)protocolModel {
    self.logLabel.attributedText = [UIlabelTool willChangeHtmlString:protocolModel.tip1];
    self.tips2 = protocolModel.tip2;
    self.protocol = protocolModel.protocol;
    self.discount = protocolModel.discount;
    self.open = protocolModel.open;
    self.price = protocolModel.price;
}


- (void)selectBtnClick:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"开始广告合作"]) {
        //开始广告合作
//        [self viewControllerPushOther:@"FHAdvertisingCooperationController"];
        FHAdvertisingCooperationController *vc = [[FHAdvertisingCooperationController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //开始商务合作
//        [self viewControllerPushOther:@"FHServiceProviderCooperationController"];
        FHServiceProviderCooperationController *vc = [[FHServiceProviderCooperationController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tips2 = self.tips2;
        vc.protocol = self.protocol;
        vc.discount = self.discount;
        vc.open = self.open;
        vc.price = self.price;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)buySuccess {
    if (self.type == 1) {
        self.selectBtn.hidden = YES;
        self.logLabel.hidden = YES;
        [self.view addSubview:self.successLabel];
        [self.view addSubview:self.successBtn];
    }
}

- (void)updateSuccess {
    if (self.type == 2) {
        self.selectBtn.hidden = YES;
        self.logLabel.hidden = YES;
        [self.view addSubview:self.successLabel];
        [self.view addSubview:self.successBtn];
    }
}

- (void)successBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark — setter && getter
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2 - 100, 200, 50);
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_selectBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        _selectBtn.layer.cornerRadius = 5;
//        _selectBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _selectBtn.clipsToBounds = YES;
        _selectBtn.layer.masksToBounds = YES;
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UILabel *)logLabel {
    if (!_logLabel) {
        _logLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, MaxY(_selectBtn) + 200, SCREEN_WIDTH - 80, 90)];
        _logLabel.font = [UIFont systemFontOfSize:13];
        _logLabel.textColor = [UIColor blackColor];
        _logLabel.textAlignment = NSTextAlignmentLeft;
        _logLabel.backgroundColor = [UIColor whiteColor];
//        _logLabel.layer.borderColor = [UIColor blackColor].CGColor;
//        _logLabel.layer.borderWidth = 1;
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
        _successLabel.backgroundColor = HEX_COLOR(0x1296db);
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
        [_successBtn setBackgroundColor:HEX_COLOR(0x1296db)];
        [_successBtn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successBtn;
}

@end
