//
//  UIlabelTool.m
//  SayU2.1.0
//
//  Created by www.xys.ren on 15/12/18.
//  Copyright (c) 2015年 xys. All rights reserved.
//

#import "UIlabelTool.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation UIlabelTool


- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/375*235, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;

}


+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    return [[[self alloc]init] sizeWithString:string font:font];
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    return [[[self alloc]init] sizeWithString:string font:font width:width];
}
+ (NSMutableAttributedString *)willChangeWordColorWithString :(NSString *)wordText
                                                       title :(NSString *)willChangeColorWord1{
    return [[[self alloc]init]willChangeWordColorWithString:wordText title:willChangeColorWord1];
}
+ (NSMutableAttributedString *)willChangeWordColorWithString :(NSString *)wordText
                                                       title :(NSString *)willChangeColorWord
                                                  normalColor:(UIColor *)normalColor
                                                  changeColor:(UIColor *)changeColor
                                                   normalFont:(UIFont  *)normalFont
                                                   changeFont:(UIFont *)changeFont{
    return [[[self alloc]init]willChangeWordColorWithString:wordText title:willChangeColorWord normalColor:normalColor changeColor:changeColor normalFont:normalFont changeFont:normalFont];
}
+ (NSAttributedString *)willChangeHtmlString:(NSString *)htmlString{
    return [[[self alloc]init]willChangeHtmlString:htmlString];
}
- (NSMutableAttributedString *)willChangeWordColorWithString :(NSString *)wordText
                                                       title :(NSString *)willChangeColorWord1
{
    NSString *initial = wordText;
    NSString *text = [initial stringByReplacingOccurrencesOfString:willChangeColorWord1 withString:willChangeColorWord1];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SCREEN_HEIGHT/667*12] range:NSMakeRange(0, initial.length)];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, initial.length)];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(%@)",willChangeColorWord1] options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,text.length);
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange1 = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:182/255.0 blue:55/255.0 alpha:1] range:subStringRange1];
    }];


    return mutableAttributedString;
}

- (NSMutableAttributedString *)willChangeWordColorWithString :(NSString *)wordText
                                                       title :(NSString *)willChangeColorWord
                                                  normalColor:(UIColor *)normalColor
                                                  changeColor:(UIColor *)changeColor
                                                   normalFont:(UIFont  *)normalFont
                                                   changeFont:(UIFont *)changeFont{
    NSString *initial = wordText;
    NSString *text = [initial stringByReplacingOccurrencesOfString:willChangeColorWord withString:willChangeColorWord];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableAttributedString addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, initial.length)];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:normalColor range:NSMakeRange(0, initial.length)];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(%@)",willChangeColorWord] options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,text.length);
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange1 = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:changeColor range:subStringRange1];
    }];
    return mutableAttributedString;
}

- (NSAttributedString *)willChangeHtmlString:(NSString *)htmlString{
    NSAttributedString * attributedStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    return attributedStr;
}

//调整Btn的label和imageView的间距
+ (void)adjustBtn:(UIButton *)btn
         btnImage:(NSString *)imageName
             font:(CGFloat )font
           margin:(CGFloat)margin{
    return[[self new] adjustBtn:btn btnImage:imageName font:font margin:margin];
}

//调整Btn的label和imageView的间距
- (void)adjustBtn:(UIButton *)btn
         btnImage:(NSString *)imageName
             font:(CGFloat )font
           margin:(CGFloat )margin{

    CGSize imageSize = [UIImage imageNamed:imageName].size;
    CGSize titleSize = [UIlabelTool sizeWithString:btn.titleLabel.text font:[UIFont systemFontOfSize:font] width:SCREEN_WIDTH];
    CGFloat totalHeight = (imageSize.height + titleSize.height + margin);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
