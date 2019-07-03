//
//  TTPasswordView.m
//  TTPassword
//
//  Created by ttcloud on 16/6/20.
//  Copyright © 2016年 ttcloud. All rights reserved.
//

#import "RWPasswordView.h"
@interface RWPasswordView ()

@end


@implementation RWPasswordView

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:self.elementCount];
    }
    return _dataSource;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc] initWithFrame:self.bounds];
        textField.hidden = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:textField];
        self.textField = textField;
        self.textField.tag = 20;
        [self.textField becomeFirstResponder];
    }
    return self;
}

- (void)setElementCount:(NSUInteger)elementCount {
    _elementCount = elementCount;
    for (int i = 0; i < self.elementCount; i++)
    {
        UITextField *pwdTextField = [[UITextField alloc] init];
        pwdTextField.enabled = NO;
        pwdTextField.tag = i + 1;
        pwdTextField.textColor = HEX_COLOR(0x333333);
        pwdTextField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        pwdTextField.backgroundColor = [UIColor whiteColor];
        pwdTextField.textAlignment = NSTextAlignmentCenter;
        pwdTextField.userInteractionEnabled = NO;
        pwdTextField.layer.borderWidth = 0.5;
        pwdTextField.layer.borderColor = _elementColor.CGColor;
        pwdTextField.layer.cornerRadius = 5;
        pwdTextField.layer.masksToBounds = YES;
        [self insertSubview:pwdTextField belowSubview:self.textField];
        [self.dataSource addObject:pwdTextField];
        
        if (i == 0) {
            pwdTextField.text = @"";
        }
    }
}

-(void)setNoSecure
{
    for (UITextField *text in self.subviews) {
        /**
         *  除了父输入框，其余输入框键盘全部设置明文
         */
        if (text.tag!=20) {
            text.secureTextEntry=NO;
        }
    }
}
- (void)setElementColor:(UIColor *)elementColor {
    _elementColor = elementColor;
}
- (void)setElementMargin:(NSUInteger)elementMargin {
    _elementMargin = elementMargin;
    [self setNeedsLayout];
}

- (void)clearText {
    self.textField.text = nil;
    [self textChange:self.textField];
}

#pragma mark - 文本框内容改变
- (void)textChange:(UITextField *)textField {
    NSString *password = textField.text;
    if (password.length > self.elementCount) {
        return;
    }
    
    for (int i = 0; i < _dataSource.count; i++) {
        UITextField *pwdTextField= [_dataSource objectAtIndex:i];
        if (i < password.length) {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdTextField.text = pwd;
        } else {
            pwdTextField.text = nil;
        }
    }
    
    if (password.length < self.elementCount) {
        UITextField *pwdTextField= [_dataSource objectAtIndex:password.length];
        pwdTextField.text = @"";
    }
    
    if (password.length == _dataSource.count)
    {
        [textField resignFirstResponder];//隐藏键盘
    }
    
    !self.passwordBlock ? : self.passwordBlock(textField.text);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.bounds.size.width - (self.elementCount - 1) * self.elementMargin) / self.elementCount;
    CGFloat h = self.bounds.size.height;
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        UITextField *pwdTextField = [_dataSource objectAtIndex:i];
        x = i * (w + self.elementMargin);
        pwdTextField.frame = CGRectMake(x, y, w, h);
        
//        UIView *lineView = [[UIView alloc]init];
//        lineView.backgroundColor = HEX_COLOR(0xC0C0C0);
//        lineView.frame = CGRectMake(0, pwdTextField.width, pwdTextField.width, 1);
//        [pwdTextField addSubview:lineView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField becomeFirstResponder];
}



@end
