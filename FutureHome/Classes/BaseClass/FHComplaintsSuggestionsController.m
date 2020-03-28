//
//  FHComplaintsSuggestionsController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  投诉建议

#import "FHComplaintsSuggestionsController.h"
#import "BRPlaceholderTextView.h"

@interface FHComplaintsSuggestionsController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 投诉建议textView */
@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** 服务器返回的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrays;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

@end

@implementation FHComplaintsSuggestionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.suggestionsTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    [self.view addSubview:self.suggestionsTextView];
    [self fh_creatUI];
    [self fh_creatBottomBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

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
    bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50) - MainSizeHeight - 35, SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
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

/** 提交投诉建议 */
- (void)addInvoiceBtnClick {
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf updateImageRequest];
        }
    }];
}

/** 上传图片 */
- (void)updateImageRequest {
    if (self.suggestionsTextView.text.length <= 0) {
        [self.view makeToast:@"请输入投诉或意见内容"];
        return;
    }
    /** 提交发布信息 */
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
    [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    if (self.imgSelectArrs.count <= 0) {
        [self commitInfo];
    } else {
        NSString *path;
        if (self.type == 1) {
            path = @"property";
        } else if (self.type == 2) {
            path = @"owner";
        }
        self.selectImgArrays = [[NSMutableArray alloc] init];
        /** 先上传多张图片*/
        Account *account = [AccountStorage readAccount];
        NSString *string = [self getCurrentTimes];
        NSArray *arr = @[string];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   path,@"path",
                                   arr,@"file[]",
                                   nil];
        
        for (int i = 0; i< self.imgSelectArrs.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.imgSelectArrs[i],1);
            [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
                NSString *imgID = [responseObj[@"data"] objectAtIndex:0];
                [self.selectImgArrays addObject:imgID];
                if (self.selectImgArrays.count == self.imgSelectArrs.count) {
                    /** 图片获取完毕 */
                    [self commitInfo];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

/** 提交信息 */
- (void)commitInfo {
    NSLog(@"我进来了-----------");
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *imgArrsString = [self.selectImgArrays componentsJoinedByString:@","];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(weakSelf.property_id),@"property_id",
                               self.suggestionsTextView.text,@"content",
                               @(self.type),@"type",
                               imgArrsString,@"img_ids",
                               nil];
    
    [AFNetWorkTool post:@"public/complaint" params:paramsDic success:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1) {
            [weakSelf.lodingHud hideAnimated:YES];
            weakSelf.lodingHud = nil;
            [weakSelf.view makeToast:@"发布投诉建议成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.lodingHud hideAnimated:YES];
            weakSelf.lodingHud = nil;
            [self.view makeToast:@"所填信息有误"];
        }
    } failure:^(NSError *error) {
        [weakSelf.lodingHud hideAnimated:YES];
        weakSelf.lodingHud = nil;
        [self.view makeToast:@"所填信息有误"];
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
        _suggestionsTextView.PlaceholderLabel.textColor = [UIColor lightGrayColor];
        NSString *titleString = @"请输入投诉或意见内容......";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _suggestionsTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _suggestionsTextView;
}

- (MBProgressHUD *)lodingHud{
    if (_lodingHud == nil) {
        _lodingHud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _lodingHud.mode = MBProgressHUDModeIndeterminate;
        _lodingHud.removeFromSuperViewOnHide = YES;
        _lodingHud.label.text = @"投诉建议提交中...";
        [_lodingHud showAnimated:YES];
    }
    return _lodingHud;
}

@end
