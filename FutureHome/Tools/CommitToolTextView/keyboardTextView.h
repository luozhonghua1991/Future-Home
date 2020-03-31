//
//  keyboardTextView.h
//  11111111
//
//  Created by Laomeng on 16/11/20.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"

@interface keyboardTextView : UIView
/** <#strong属性注释#> */
@property (nonatomic, strong) GrowingTextView *textView;;

- (instancetype)initWithTextViewFrame:(CGRect)frame;

@property (nonatomic, copy) void (^SendMesButtonClickedBlock)(NSString *text);

@end
