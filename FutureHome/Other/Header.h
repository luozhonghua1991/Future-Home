//
//  Header.h
//  SchoolApp
//
//  Created by lyl on 16/7/7.
//  Copyright © 2016年 miruo. All rights reserved.
//

#ifndef Header_h
#define Header_h


//颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//随机颜色
#define ARC4RANDOM_COLOR [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];


//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

//判断iPhone4
#define IS_Iphone4 (([UIScreen mainScreen].bounds.size.height)>470)&&(([UIScreen mainScreen].bounds.size.height)<490)



//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#  define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#  define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#  define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#  define ULog(...)
#endif

// 整个项目统一色
#define Default_Blackcolor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.00f]
#define Default_Bluecolor [UIColor colorWithRed:48/255.0 green:165/255.0 blue:229/255.0 alpha:1.00f]

#define Default_CELL_Garycolor [UIColor colorWithRed:242/255.0 green:238/255.0 blue:236/255.0 alpha:1.00f]
#define Cell_Line_Garycolor [UIColor colorWithRed:209/255.0 green:209/255.0 blue:213/255.0 alpha:1.00f]

//weak self
#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define WEAK_SELF_OBJC(weakSelf,objc)  __weak __typeof(&*objc)weakSelf = objc;
//判断是否为 空
#define IS_EQUAL_TO_NULL(string) ( [string isKindOfClass:[NSNull class]] || !string || [string isEqualToString: @"<null>"] || [string isEqualToString: @"(null)"] || [[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]  isEqualToString: @""])
#define FontNeveLightWithSize(fontSize)     [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


//#import <NIMSDK/NIMSDK.h>

#define FontNeveLightWithSize(fontSize)     [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]
#define FaceBGColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define MAS_SHORTHAND           // 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND_GLOBALS   // 只要添加了这个宏，equalTo就等价于mas_equalTo

#define YUNXINAPPKEY  @"af056b05784527a0df488e04a9287a63" 



#endif /* Header_h */
