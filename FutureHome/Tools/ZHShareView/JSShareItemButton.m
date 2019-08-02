//
//  JSShareItemButton.m
//  JSShareView
//
//  Created by 乔同新 on 16/6/7.
//  Copyright © 2016年 乔同新. All rights reserved.
//



#import "JSShareItemButton.h"
#import "UIView+YYAdd.h"

#define XNColor(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define XNWindowWidth        ([[UIScreen mainScreen] bounds].size.width)

#define XNWindowHeight       ([[UIScreen mainScreen] bounds].size.height)

#define XNFont(font)         [UIFont systemFontOfSize:(font)]

#define XNWidth_Scale        [UIScreen mainScreen].bounds.size.width/375.0f

@implementation JSShareItemButton

+ (instancetype)shareButton{
    
    return [self buttonWithType:UIButtonTypeCustom];
}

- (UIEdgeInsets)imageEdgeInsets{
    
    return UIEdgeInsetsMake(0,
                            15*XNWidth_Scale,
                            30*XNWidth_Scale,
                            15*XNWidth_Scale);
}

- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                     imageTag:(NSInteger)imageTAG
                        title:(NSString *)title
                    titleFont:(CGFloat)titleFont
                   titleColor:(UIColor *)titleColor

{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpShareButtonImageName:imageName
                               imageTag:imageTAG
                                  title:title
                              titleFont:titleFont
                             titleColor:titleColor];
    }
    return self;
}

- (void)setUpShareButtonImageName:(NSString *)imageName
                         imageTag:(NSInteger)imageTAG
                            title:(NSString *)title
                        titleFont:(CGFloat)titleFont
                       titleColor:(UIColor *)titleColor
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5,0,self.width-5,self.width-5)];
    imageView.tag = imageTAG;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+ 10, self.width +ZH_SCALE_SCREEN_Width(5) , 10)];
    label.textColor = titleColor;
    label.text = title;
    label.font = XNFont(titleFont);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
}


@end
