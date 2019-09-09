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

@end

@implementation FHComplaintsSuggestionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.suggestionsTextView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 150);
    [self.view addSubview:self.suggestionsTextView];
    [self fh_creatUI];
    [self fh_creatBottomBtn];
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
    //    [completedBtn addTarget:self action:@selector(addInvoiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
