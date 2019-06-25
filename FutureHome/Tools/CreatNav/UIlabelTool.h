//
//  UIlabelTool.h
//  SayU2.1.0
//
//  Created by www.xys.ren on 15/12/18.
//  Copyright (c) 2015年 xys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIlabelTool : UILabel

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;
//富文本 改变一整段字体的部分颜色
//wordText:整段字体
//willChangeColorWord1:需要修改的字体
+ (NSMutableAttributedString *)willChangeWordColorWithString :(NSString *)wordText
                                                       title :(NSString *)willChangeColorWord1;
//富文本 改变一整段字体的部分颜色
//wordText:整段字体
//willChangeColorWord:需要修改的字体
//normalColor:不需要改变字体的颜色
//changeColor:需要改变的字体颜色
//normalFont:不需要改变的字体的大小
//changeFont:需要改变的字体的大小
+ (NSMutableAttributedString *)willChangeWordColorWithString :(NSString *)wordText
                                                       title :(NSString *)willChangeColorWord
                                                  normalColor:(UIColor *)normalColor
                                                  changeColor:(UIColor *)changeColor
                                                   normalFont:(UIFont  *)normalFont
                                                   changeFont:(UIFont *)changeFont;
//HTML转成NSAttributedString
+ (NSAttributedString *)willChangeHtmlString:(NSString *)htmlString;

//调整Btn的label和imageView的间距 只支持上下显示类型的button
+ (void)adjustBtn:(UIButton *)btn
         btnImage:(NSString *)imageName
             font:(CGFloat )font
           margin:(CGFloat )margin;
@end
