//
//  FHMeCenterUserInfoView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/2.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  个人中心 个人信息View

#import "FHMeCenterUserInfoView.h"
#import "FHImageToolMethod.h"

@interface FHMeCenterUserInfoView ()
/** 上面的线 */
@property (nonatomic, strong) UIView *topLineView;
/** 上面部分的视图 */
@property (nonatomic, strong) UIView  *topContentView;
/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 下面部分的视图 */
@property (nonatomic, strong) UIView  *bottomContentView;
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;

/** 左面的线 */
@property (nonatomic, strong) UIView *leftLineView;
/** 中间的线 */
@property (nonatomic, strong) UIView *centerLineView;
/** 右边的线 */
@property (nonatomic, strong) UIView *rightLineView;

/** <#strong属性注释#> */
@property (nonatomic, strong) Account *account;


@end

@implementation FHMeCenterUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.account = [AccountStorage readAccount];
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.topContentView];
    [self.topContentView addSubview:self.topLineView];
    [self.topContentView addSubview:self.userHeaderImgView];
    [self.topContentView addSubview:self.userNameLabel];
    [self.topContentView addSubview:self.futureHomeCodeLabel];
    [self.topContentView addSubview:self.codeImgView];
    [self.topContentView addSubview:self.logoLabel];
}

#pragma mark - 得到jsonString
- (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)tapClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_personCodeTapCLick)]) {
        [_delegate fh_personCodeTapCLick];
    }
//    self.codeDetailView.alpha = 0;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.codeDetailView.alpha = 1;
//    }];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
}

- (void)headerImgClick {
    [FHImageToolMethod showImage:self.userHeaderImgView];
}

#pragma mark - 懒加载
- (UIView *)topContentView {
    if (!_topContentView) {
        _topContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85 + 20)];
//        _topContentView.backgroundColor = [UIColor redColor];
    }
    return _topContentView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 84.5 + 20, SCREEN_WIDTH, 0.5)];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UIImageView *)userHeaderImgView {
    if (!_userHeaderImgView) {
        _userHeaderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
//        _userHeaderImgView.image = ;
        [_userHeaderImgView sd_setImageWithURL:[NSURL URLWithString:self.account.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImgClick)];
        _userHeaderImgView.userInteractionEnabled = YES;
        [_userHeaderImgView addGestureRecognizer:tap];
    }
    return _userHeaderImgView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75 + 20, 20, 245, 15)];
        if (!IsStringEmpty(self.account.nickname)) {
            _userNameLabel.text = [NSString stringWithFormat:@"%@",self.account.nickname];
        }
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLabel;
}

- (UILabel *)futureHomeCodeLabel {
    if (!_futureHomeCodeLabel) {
        _futureHomeCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75 + 20, 50, 200, 16)];
        _futureHomeCodeLabel.text = [NSString stringWithFormat:@"社云号: %@",self.account.username];
        _futureHomeCodeLabel.textColor = [UIColor blackColor];
        _futureHomeCodeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _futureHomeCodeLabel;
}

- (UIImageView *)codeImgView {
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 5, 65, 65)];
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"",@"address",
                                   @"com.sheyun",@"app_key",
                                   @(account.user_id),@"id",
//                                   @"false",@"is_collect",
                                   account.nickname,@"name",
//                                   @"0",@"slat",
//                                   @"0",@"slng",
                                   @"1",@"type",
                                   nil];
        _codeImgView.image = [SGQRCodeObtain generateQRCodeWithData:[self DataTOjsonString:paramsDic] size:65.0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        _codeImgView.userInteractionEnabled = YES;
        [_codeImgView addGestureRecognizer:tap];
    }
    return _codeImgView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 72, 100, 10)];
        _logoLabel.text = @"我的二维码";
        _logoLabel.textColor = [UIColor blackColor];
        _logoLabel.textAlignment = NSTextAlignmentRight;
        _logoLabel.font = [UIFont systemFontOfSize:10];
    }
    return _logoLabel;
}

- (UIView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 65)];
//        _bottomContentView.backgroundColor = [UIColor greenColor];
    }
    return _bottomContentView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 149.5, SCREEN_WIDTH, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 10, 0.5, 45)];
        _leftLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _leftLineView;
}

- (UIView *)centerLineView {
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 2, 10, 0.5, 45)];
        _centerLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _centerLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 3, 10, 0.5, 45)];
        _rightLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _rightLineView;
}

- (FHUserInfoHeaderBaseView *)friendView {
    if (!_friendView) {
        _friendView = [[FHUserInfoHeaderBaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 4, 65)];
    }
    return _friendView;
}

- (FHUserInfoHeaderBaseView *)groupView {
    if (!_groupView) {
        _groupView = [[FHUserInfoHeaderBaseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 0, SCREEN_WIDTH / 4, 65)];
    }
    return _groupView;
}

- (FHUserInfoHeaderBaseView *)followView {
    if (!_followView) {
        _followView = [[FHUserInfoHeaderBaseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 2, 0, SCREEN_WIDTH / 4, 65)];
    }
    return _followView;
}

- (FHUserInfoHeaderBaseView *)myView {
    if (!_myView) {
        _myView = [[FHUserInfoHeaderBaseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 *3, 0, SCREEN_WIDTH / 4, 65)];
    }
    return _myView;
}

- (FHScanDetailAlertView *)codeDetailView {
    if (!_codeDetailView) {
        _codeDetailView = [[FHScanDetailAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"com.sheyun",@"app_key",
                                   @(account.user_id),@"id",
                                   account.nickname,@"name",
                                   account.username,@"username",
                                   @"0",@"type",
                                   nil];
//        NSDictionary *codeDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"com.sheyun",@"app_key",
//                                   @(account.user_id),@"id",
//                                   @"0",@"type",
//                                   nil];
        _codeDetailView.dataDetaildic = paramsDic;
        //_codeDetailView.scanCodeDic = codeDic;
    }
    return _codeDetailView;
}

@end
