//
//  FHReleaseDynamicsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  发布动态
#import "FHReleaseDynamicsController.h"
#import "BRPlaceholderTextView.h"

@interface FHReleaseDynamicsController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 投诉建议textView */
@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** 服务器返回的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrays;
/** 是否选择了 */
@property (nonatomic, assign) BOOL isSelect;


@end

@implementation FHReleaseDynamicsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    self.suggestionsTextView.frame = CGRectMake(0, MainSizeHeight + 10, SCREEN_WIDTH, 150);
    [self.view addSubview:self.suggestionsTextView];
    [self fh_creatUI];
    [self fh_creatBottomBtn];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"发布动态";
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
    [SingleManager shareManager].isSelectVideo = NO;
    [SingleManager shareManager].isSelectPhoto = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark — creatUI
- (void)fh_creatUI {
    self.scrollView.frame = CGRectMake(0, MaxY(self.suggestionsTextView), SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
}

- (void)fh_creatBottomBtn {
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    bottomBtn.backgroundColor = HEX_COLOR(0x1296db);
    [bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    scrollView.contentOffset = point;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/** 发布动态 */
- (void)addInvoiceBtnClick {
    if (self.isSelect) {
        return;
    } else {
        self.isSelect = YES;
    }
    if (self.suggestionsTextView.text.length <= 0||[self.suggestionsTextView.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写内容"];
        return;
    }
    /*发布动态*/
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
//    self.selectImgArrays = [[NSMutableArray alloc] init];
    if ([SingleManager shareManager].isSelectVideo) {
        /** 选择了视频 */
        [self updateVideoWithRequest];
    } else {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   /** 图片1 视频2 */
                                   @"1",@"type",
                                   self.imgSelectArrs,@"file[]",
                                   self.suggestionsTextView.text,@"content",
                                   nil];
        
        [AFNetWorkTool uploadImagesWithUrl:@"sheyun/publishDynamic" parameters:paramsDic image:self.imgSelectArrs success:^(id responseObj) {
            [weakSelf.view makeToast:responseObj[@"上传中请稍后..."]];
            NSInteger code = [responseObj[@"code"] integerValue];
            if (code == 1) {
                [weakSelf.view makeToast:responseObj[@"msg"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SingleManager shareManager].isSelectPhoto = NO;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)updateVideoWithRequest {
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[SingleManager shareManager].videoPath]];
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               /**视频2 */
                               @"2",@"type",
                               @[videoData],@"file[]",
                               self.suggestionsTextView.text,@"content",
                               nil];

    [AFNetWorkTool updateVideoWithUrl:@"sheyun/publishDynamic" parameter:paramsDic videoData:videoData success:^(id responseObj) {
        [weakSelf.view makeToast:responseObj[@"上传中请稍后..."]];
            NSInteger code = [responseObj[@"code"] integerValue];
            if (code == 1) {
                [weakSelf.view makeToast:responseObj[@"msg"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SingleManager shareManager].isSelectVideo = NO;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {

        }];
}


//获取当前的时间

- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    [self updatePickerViewFrameY:MaxY(self.suggestionsTextView)];
    self.scrollView.contentSize = CGSizeMake(0, [self getPickerViewFrame].size.height + MainSizeHeight + 20);
}

- (BRPlaceholderTextView *)suggestionsTextView {
    if (!_suggestionsTextView) {
        _suggestionsTextView = [[BRPlaceholderTextView alloc] init];
        _suggestionsTextView.layer.borderWidth = 1;
        _suggestionsTextView.font = [UIFont systemFontOfSize:15];
        _suggestionsTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _suggestionsTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _suggestionsTextView.PlaceholderLabel.textColor = [UIColor blackColor];
        NSString *titleString = @"请输入投诉或意见内容......";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _suggestionsTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _suggestionsTextView;
}


@end
