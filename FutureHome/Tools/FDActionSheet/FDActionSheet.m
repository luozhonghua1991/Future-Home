//
//  FDActionSheet.m
//  FDActionSheetDemp
//
//  Created by fergusding on 15/5/28.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDActionSheet.h"

#define MARGIN_LEFT 20
#define MARGIN_RIGHT 20
#define SPACE_SMALL 5
#define TITLE_FONT_SIZE 15
#define BUTTON_FONT_SIZE 14

@interface FDActionSheet ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end

CGFloat contentViewWidth;
CGFloat contentViewHeight;

@implementation FDActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [_buttonTitleArray addObject:otherButtonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_backgroundView];
        
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    contentViewWidth =SCREEN_WIDTH/375 *340;
    contentViewHeight = 0;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _buttonView = [[UIView alloc] init];
    _buttonView.backgroundColor = [UIColor whiteColor];
    
    [self initTitle];
    [self initButtons];
    [self initCancelButton];
    
    _contentView.frame = CGRectMake((SCREEN_WIDTH - contentViewWidth ) / 2, self.frame.size.height, contentViewWidth, contentViewHeight);
    [self addSubview:_contentView];
}

- (void)initTitle {
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375 *12, 0, contentViewWidth - SCREEN_WIDTH/375*24, SCREEN_HEIGHT/667 *50)];
        _titleLabel.text = _title;
        _titleLabel.numberOfLines = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0f];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.text length])];
        _titleLabel.attributedText = attributedString;
//        [_titleLabel sizeToFit];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:SCREEN_HEIGHT/667 *12];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonView addSubview:_titleLabel];
        contentViewHeight +=SCREEN_HEIGHT/667 *50;
    }
}

- (void)initButtons {
    if (_buttonTitleArray.count > 0) {
        NSInteger count = _buttonTitleArray.count;
        for (int i = 0; i < count; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewHeight, contentViewWidth, SCREEN_HEIGHT/667 *1/2)];
            lineView.backgroundColor = COLOR_24;
            [_buttonView addSubview:lineView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, contentViewHeight + 1, contentViewWidth,SCREEN_HEIGHT/667 *50)];
            [button addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_buttonView addSubview:button];
            contentViewHeight += lineView.frame.size.height + button.frame.size.height;
        }
        _buttonView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
        _buttonView.layer.cornerRadius = 5.0;
        _buttonView.layer.masksToBounds = YES;
        [_contentView addSubview:_buttonView];
    }
}

- (void)initCancelButton {
    if (_cancelButtonTitle != nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, contentViewHeight + SPACE_SMALL, contentViewWidth, 44)];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelButton.layer.cornerRadius = 5.0;
        [_cancelButton addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [_cancelButton addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelButton];
        contentViewHeight += SPACE_SMALL + _cancelButton.frame.size.height + SPACE_SMALL;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initContentView];
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = cancelButtonTitle;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)show {
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self addAnimation];
}

- (void)hide {
    [self removeAnimation];
}

- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size atIndex:(int)index {
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [button setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:SCREEN_HEIGHT/667 *15];
    }
}

- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size {
    if (color != nil) {
        [_cancelButton setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [_cancelButton setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        _cancelButton.titleLabel.font =[UIFont fontWithName:@"Helvetica-Oblique" size:SCREEN_HEIGHT/667 *15];
    }
}

- (void)addAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height - _contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0.7;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation {
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonPressed:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonIndex:)]) {
        for (int i = 0; i < _buttonArray.count; i++) {
            if (button == _buttonArray[i]) {
                [_delegate actionSheet:self clickedButtonIndex:i];
                break;
            }
        }
    }
    [self hide];
}

- (void)cancelButtonPressed:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self hide];
}
//  button1普通状态下的背景色
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor =COLOR_8;
}

//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = COLOR_16;
}
@end

