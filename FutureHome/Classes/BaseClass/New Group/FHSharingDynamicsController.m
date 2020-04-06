//
//  FHSharingDynamicsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/1/8.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  分享动态  转发

#import "FHSharingDynamicsController.h"
#import "BRPlaceholderTextView.h"

@interface FHSharingDynamicsController ()
/** <#strong属性注释#> */
@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;
/** 灰色背景View */
@property (nonatomic, strong) UIView *lightGrayView;
/**封面图 */
@property (nonatomic, strong) UIImageView *corverImg;
/** 上面的label */
@property (nonatomic, strong) UILabel *topLabel;
/** 下面的label */
@property (nonatomic, strong) UILabel *bottomLabel;
/** 视频图片 */
@property (nonatomic, strong) UIImageView   *videoPlayImageView;

@end

@implementation FHSharingDynamicsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    self.suggestionsTextView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 150);
    [self.view addSubview:self.suggestionsTextView];
    [self fh_creatBottomBtn];
    CGFloat oneheight = (SCREEN_WIDTH - 105) / 3 - 10;
    self.lightGrayView.frame = CGRectMake(0, MaxY(self.suggestionsTextView) + 10, SCREEN_WIDTH, oneheight + 18.6);
    [self.view addSubview:self.lightGrayView];
    
    self.corverImg.frame = CGRectMake(9.3, 9.3, oneheight, oneheight);
    if ([self.type isEqualToString:@"视频"]) {
        self.videoPlayImageView.frame = CGRectMake(0, 0, 48, 48);
        self.videoPlayImageView.centerX = self.corverImg.frame.size.width / 2;
        self.videoPlayImageView.centerY = self.corverImg.frame.size.height / 2;
        [self.corverImg addSubview:self.videoPlayImageView];
    }
    if ([self.type isEqualToString:@"文章"]) {
         [self.corverImg sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"cover"]]];
    } else if ([self.type isEqualToString:@"视频"]) {
         [self.corverImg sd_setImageWithURL:[NSURL URLWithString:self.data.cover]];
    }
    [self.lightGrayView addSubview:self.corverImg];
    
    NSString *topTitle;
    if ([self.type isEqualToString:@"文章"]) {
        topTitle = [NSString stringWithFormat:@"分享文章 @%@",self.dataDic[@"forwarder"]];
    } else if ([self.type isEqualToString:@"视频"]) {
        topTitle = [NSString stringWithFormat:@"分享视频 @%@",[SingleManager shareManager].shopName];
    }
    self.topLabel.frame = CGRectMake(MaxX(self.corverImg) + 15, 15 , SCREEN_WIDTH - MaxX(self.corverImg) - 30, 40);
    self.topLabel.text = topTitle;
    [self.lightGrayView addSubview:self.topLabel];
    
    NSString *bottomTitle;
    if ([self.type isEqualToString:@"文章"]) {
        bottomTitle = [NSString stringWithFormat:@"%@",self.dataDic[@"title"]];
    } else if ([self.type isEqualToString:@"视频"]) {
        bottomTitle = self.data.title;
    }
    self.bottomLabel.frame = CGRectMake(MaxX(self.corverImg) + 15, MaxY(self.topLabel) + 5 , SCREEN_WIDTH - MaxX(self.corverImg) - 30, 38);
    self.bottomLabel.text = bottomTitle;
    [self.lightGrayView addSubview:self.bottomLabel];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"分享动态";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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

#pragma mark — creatUI
- (void)fh_creatBottomBtn {
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    bottomBtn.backgroundColor = HEX_COLOR(0x1296db);
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}


/** 发布动态 */
- (void)addInvoiceBtnClick {
    if (self.suggestionsTextView.text.length <= 0||[self.suggestionsTextView.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写内容"];
        return;
    }
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf commitRequest];
        }
    }];
}

- (void)commitRequest {
    if ([self.type isEqualToString:@"文章"]) {
        /** 转发文章 */
        //显示加载视图
        [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHud];
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   @"3",@"type",
                                   self.dataDic[@"title"],@"title",
                                   self.dataDic[@"forwarder"],@"forwarder",
                                   self.dataDic[@"cover"],@"cover",
                                   self.suggestionsTextView.text,@"content",
                                   self.dataDic[@"path"],@"path",
                                   nil];
        
        [AFNetWorkTool uploadImagesWithUrl:@"sheyun/publishDynamic" parameters:paramsDic image:[NSArray array] success:^(id responseObj) {
            NSInteger code = [responseObj[@"code"] integerValue];
            if (code == 1) {
                [weakSelf.loadingHud hideAnimated:YES];
                weakSelf.loadingHud = nil;
                [weakSelf.view makeToast:@"动态消息转发成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.loadingHud hideAnimated:YES];
                weakSelf.loadingHud = nil;
                [weakSelf.view makeToast:@"动态转发失败请稍后再试"];
            }
        } failure:^(NSError *error) {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:@"动态转发失败请稍后再试"];
        }];
    } else if ([self.type isEqualToString:@"视频"]) {
        /** 转发视频 */
        //显示加载视图
        [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHud];
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   @"4",@"type",
                                   self.data.dataID,@"video_id",
                                   self.data.video_type,@"video_type",
                                   [SingleManager shareManager].shopName,@"forwarder",
                                   self.suggestionsTextView.text,@"content",
                                   nil];
        
        [AFNetWorkTool uploadImagesWithUrl:@"sheyun/publishDynamic" parameters:paramsDic image:[NSArray array] success:^(id responseObj) {
            NSInteger code = [responseObj[@"code"] integerValue];
            if (code == 1) {
                //隐藏加载视图
                [weakSelf.loadingHud hideAnimated:YES];
                weakSelf.loadingHud = nil;
                [weakSelf.view makeToast:@"转发动态成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.loadingHud hideAnimated:YES];
                weakSelf.loadingHud = nil;
                [weakSelf.view makeToast:@"转发动态失败请稍后再试"];
            }
        } failure:^(NSError *error) {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:@"转发动态失败请稍后再试"];
        }];
    }
}

#pragma mark —  setter && getter

- (UIView *)lightGrayView {
    if (!_lightGrayView) {
        _lightGrayView = [[UIView alloc] init];
        _lightGrayView.backgroundColor = HEX_COLOR(0xF2F2F2);
    }
    return _lightGrayView;
}
- (BRPlaceholderTextView *)suggestionsTextView {
    if (!_suggestionsTextView) {
        _suggestionsTextView = [[BRPlaceholderTextView alloc] init];
        _suggestionsTextView.layer.borderWidth = 1;
        _suggestionsTextView.font = [UIFont systemFontOfSize:15];
        _suggestionsTextView.layer.borderColor = HEX_COLOR(0xF2F2F2).CGColor;
        _suggestionsTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _suggestionsTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"这一刻的想法......";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _suggestionsTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _suggestionsTextView;
}

- (UIImageView *)corverImg {
    if (!_corverImg) {
        _corverImg = [[UIImageView alloc] init];
    }
    return _corverImg;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:15];
        _topLabel.numberOfLines = 2;
        _topLabel.textColor = HEX_COLOR(0x1296db);
        _topLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.numberOfLines = 2;
        _bottomLabel.textColor = [UIColor blackColor];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bottomLabel;
}

- (UIImageView *)videoPlayImageView {
    if (!_videoPlayImageView) {
        _videoPlayImageView = [[UIImageView alloc] init];
        _videoPlayImageView.image = [UIImage imageNamed:@"播放 (1)"];
    }
    return _videoPlayImageView;
}

@end
