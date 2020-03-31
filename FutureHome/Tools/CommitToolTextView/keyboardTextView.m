//
//  keyboardTextView.m
//  11111111
//
//  Created by Laomeng on 16/11/20.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "keyboardTextView.h"

#import "Color.h"
#import "IQKeyboardManager.h"

@interface keyboardTextView () <GrowingTextViewDelegate>
{
    CGRect defaultRect;
    CGRect keyboardBounds;
    CGFloat textViewDefaultHeight;
    NSLayoutConstraint *bgViewBottomC;
    NSLayoutConstraint *bgViewHeightC;
}
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *textViewBgView;
@property (nonatomic, strong) UIButton *sendBtn;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat changeHeight;

@end

@implementation keyboardTextView

- (instancetype)initWithTextViewFrame:(CGRect)frame
{
    if (self = [super init]) {
        self.changeHeight = frame.size.height;
        self.frame = frame;
        [self setup];
        [self addKeyBoardNotification];
    }
    return self;
}

- (void)setup {
    self.textViewBgView = [[UIView alloc] initWithFrame:self.bounds];
//    self.textViewBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textViewBgView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    [self addSubview:self.textViewBgView];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(SCREEN_WIDTH - 61, self.height - 42, 47, 35);
    self.sendBtn.enabled = NO;
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendMesAcition:) forControlEvents:UIControlEventTouchUpInside];
    [self.textViewBgView addSubview:self.sendBtn];

    self.textView = [[GrowingTextView alloc] initWithFrame:CGRectMake(14, 7.5, SCREEN_WIDTH - 82, 34)];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.minNumberOfLines = 1;
    self.textView.maxHeight = 90.f;
    self.textView.animateHeightChange = NO;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.textColor = [Color colorWithHex:@"#2C2C2C"];
    self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = [Color colorWithHex:@"#2C2C2C"].CGColor;
    self.textView.layer.cornerRadius = 5.f;
    self.textView.layer.masksToBounds = YES;
    self.textView.internalTextView.tintColor = [UIColor blackColor];
    self.textView.placeholder = @"说点什么吧";
    [self.textViewBgView addSubview:self.textView];
}

- (void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];	
}

-(void)keyboardWillShow:(NSNotification *)note{
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    self.frame = CGRectMake(0, SCREEN_HEIGHT - self.changeHeight - keyboardBounds.size.height, SCREEN_WIDTH, self.changeHeight);
    self.textViewBgView.frame = self.bounds;
    self.sendBtn.frame =  CGRectMake(SCREEN_WIDTH - 61, self.textViewBgView.height - 42, 47, 35);
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    if (self.changeHeight > 59) {
    } else {
        self.changeHeight = 59;
    }
    self.frame = CGRectMake(0, SCREEN_HEIGHT - self.changeHeight, SCREEN_WIDTH, self.changeHeight);
    self.textViewBgView.frame = self.bounds;
    self.sendBtn.frame =  CGRectMake(SCREEN_WIDTH - 61, self.textViewBgView.height - 42, 47, 35);
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)growingTextView:(GrowingTextView *)growingTextView willChangeHeight:(float)height
{
    self.changeHeight = height + 15.0f;
    self.frame = CGRectMake(0, SCREEN_HEIGHT - self.changeHeight - keyboardBounds.size.height, SCREEN_WIDTH, self.changeHeight);
    self.textViewBgView.height = self.changeHeight;
    self.sendBtn.frame =  CGRectMake(SCREEN_WIDTH - 61, self.textViewBgView.height - 42, 47, 35);
    
    [self layoutIfNeeded];
}

- (BOOL)growingTextView:(GrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ((growingTextView.internalTextView.text.length > 1 && text.length == 0) ||( text.length != 0)) {
        [self.sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.sendBtn.enabled = YES;
    }else {
        [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sendBtn.enabled = NO;
    }
    return YES;
}

- (BOOL)growingTextViewShouldReturn:(GrowingTextView *)growingTextView
{
    if (self.textView.text.length > 0) {
        self.SendMesButtonClickedBlock(self.textView.text);
        self.textView.text = @"";
        [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sendBtn.enabled = NO;
    }
    if (self.textView.internalTextView.isFirstResponder) {
        [self.textView.internalTextView endEditing:YES];
    }
    return YES;
}


- (void)sendMesAcition:(UIButton *)sender
{
    if (self.textView.text.length > 0) {
        self.SendMesButtonClickedBlock(self.textView.text);
        self.textView.text = @"";
        [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.sendBtn.enabled = NO;
    }
    if (self.textView.internalTextView.isFirstResponder) {
        [self.textView.internalTextView endEditing:YES];
    }
}

@end
