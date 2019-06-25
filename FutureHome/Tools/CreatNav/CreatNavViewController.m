//
//  CreatNavViewController.m
//  SayU
//
//  Created by 杭州任性贸易有限公司 on 16/5/14.
//  Copyright © 2016年 xys. All rights reserved.
//  创建导航栏

#import "CreatNavViewController.h"
#import "myButton.h"

@interface CreatNavViewController ()
/**导航栏标题label*/
@property (nonatomic,strong) UILabel *titleLab;
@end

@implementation CreatNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (UIView *)creatResultNavigationBarView:(NSString *)strNavTitle frame:(CGRect)frame KnowBlock:(knowButtonBlock)knowBlock
{
    return [[[self alloc]init] setResultNavigationBarView:strNavTitle frame:frame KnowBlock:knowBlock];
}

/**
 *  设置含有标题/返回按钮的导航栏
 */
- (UIView *)setResultNavigationBarView:(NSString *)NavTitle frame:(CGRect)frame KnowBlock:(knowButtonBlock)knowBlock
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    _blockKnow = knowBlock;
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = [UIColor whiteColor];
    navigationView.frame = frame;
    
    //标题
    UILabel *tiitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, 44)];
    tiitleLab.text = NavTitle;
    tiitleLab.tag = 100;
    tiitleLab.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1];
    tiitleLab.font = [UIFont systemFontOfSize:17];
    tiitleLab.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:tiitleLab];
    
    //返回按钮
    myButton *backBtn = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, MainStatusBarHeight+5, ZH_SCALE_SCREEN_Width(35), 30) title:nil titleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] backgroundImage:nil andBlock:^{
        _blockKnow();
    }];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [navigationView addSubview:backBtn];
    
    _lineView= [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
    _lineView.frame = CGRectMake(0, navigationView.bounds.size.height - 0.5, SCREEN_WIDTH, 0.5);
    [navigationView addSubview:_lineView];
    
    return navigationView;
}

+ (UIView *)creatRightNavigationBarView:(NSString *)strNavTitle rightTitle:(NSString *)strRightTitle frame:(CGRect)frame KnowBlock:(knowButtonBlock)knowBlock RightBlock:(rightButtonBlock)rightBlock
{
    return [[[self alloc]init] setRightNavigationBarView:strNavTitle rightTitle:strRightTitle frame:frame KnowBlock:knowBlock RightBlock:rightBlock];
}

/**
 *  设置含有标题/返回按钮的导航栏
 */
- (UIView *)setRightNavigationBarView:(NSString *)NavTitle
                           rightTitle:(NSString *)strRightTitle
                                frame:(CGRect)frame
                            KnowBlock:(knowButtonBlock)knowBlock
                           RightBlock:(rightButtonBlock)rightBlock
{
    _blockKnow = knowBlock;
    _blockRight = rightBlock;
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = COLOR_7;
    navigationView.frame = frame;
    
    //标题
    UILabel *tiitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, 44)];
    tiitleLab.text = NavTitle;
    tiitleLab.textColor = COLOR_2;
    tiitleLab.font = [UIFont systemFontOfSize:17];
    tiitleLab.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:tiitleLab];
    
    //返回按钮
    myButton *backBtn = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, MainStatusBarHeight+5, ZH_SCALE_SCREEN_Width(35), 30) title:nil titleColor:COLOR_8 backgroundImage:nil andBlock:^{
        _blockKnow();
    }];
    [backBtn setImage:[UIImage imageNamed:@"icon_arrows"] forState:UIControlStateNormal];
    [navigationView addSubview:backBtn];
    
    //右边按钮
    CGSize size = [UIlabelTool sizeWithString:strRightTitle font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
    myButton *RightBtn = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/375*24 - size.width, MainStatusBarHeight, SCREEN_WIDTH/375*24 + size.width, 44) title:strRightTitle titleColor:COLOR_2 backgroundImage:nil andBlock:^{
        _blockRight();
    }];
    RightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navigationView addSubview:RightBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_5;
    lineView.frame = CGRectMake(0, navigationView.bounds.size.height - 0.5, SCREEN_WIDTH, 0.5);
    [navigationView addSubview:lineView];
    
    return navigationView;
}

//  自定义导航栏颜色 左边按钮 带文字样式
+(UIView *)creatSelfRightNavigationBarView:(NSString *)strNavTitle
                            mainTitleColor:(UIColor *)mainTitleColor
                                 leftTitle:(NSString *)strLeftTitle
                                 rightTitle:(NSString *)strRightTitle
                                 frame:(CGRect)frame
                                 KnowBlock:(knowButtonBlock)knowBlock
                                 RightBlock:(rightButtonBlock)rightBlock
                                 color:(UIColor *)color{
  
    return [[[self alloc]init] setSelfRightNavigationBarView:strNavTitle
                                              mainTitleColor:(UIColor *)mainTitleColor
                                                   leftTitle:strLeftTitle
                                                  rightTitle:strRightTitle
                                                       frame:frame
                                                   KnowBlock:knowBlock
                                                  RightBlock:rightBlock
                                                       navColor:color];

}
+ (UILabel *)getNavLabel{
    return[[[self alloc]init] getNavLabel];
}
- (UILabel *)getNavLabel{
    return self.titleLab;
}
- (UIView *)setSelfRightNavigationBarView:(NSString *)NavTitle
                           mainTitleColor:(UIColor *)mainTitleColor
                                leftTitle:(NSString *)strLeftTitle
                               rightTitle:(NSString *)strRightTitle
                                    frame:(CGRect)frame
                                KnowBlock:(knowButtonBlock)knowBlock
                               RightBlock:(rightButtonBlock)rightBlock
                                    navColor:(UIColor *)color{
    _blockKnow = knowBlock;
    _blockRight = rightBlock;
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = color;
    navigationView.frame = frame;
    
    //标题
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    self.titleLab.text = NavTitle;
    self.titleLab.font = [UIFont systemFontOfSize:17];
    self.titleLab.textColor = mainTitleColor;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:self.titleLab];
    
    //返回按钮
    myButton *backBtn = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, MainStatusBarHeight + 5, ZH_SCALE_SCREEN_Width(35), 30) title:nil titleColor:COLOR_2 backgroundImage:nil andBlock:^{
        _blockKnow();
    }];

    [navigationView addSubview:backBtn];
    //如果后缀为.png.jpg.jpeg则为设置图片
    if (strLeftTitle) {
        if ([strLeftTitle hasSuffix:@".png"] || [strLeftTitle hasSuffix:@".jpg"] || [strLeftTitle hasSuffix:@".jpeg"]) {
            [backBtn setImage:[UIImage imageNamed:strLeftTitle] forState:UIControlStateNormal];
        }else{
            [backBtn setTitle:strLeftTitle forState:UIControlStateNormal];
            backBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        }
    }
    
    //右边按钮
    myButton *RightBtn;
    if (strRightTitle) {
        if ([strRightTitle hasSuffix:@".png"] || [strRightTitle hasSuffix:@".jpg"] || [strRightTitle hasSuffix:@".jpeg"]) {
            RightBtn  = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/375*24  - ZH_SCALE_SCREEN_Width(21), MainStatusBarHeight, SCREEN_WIDTH/375*24 + ZH_SCALE_SCREEN_Width(20), MainNavgationBarHeight) title:nil titleColor:[UIColor whiteColor] backgroundImage:nil andBlock:^{
                _blockRight();
            }];
            [RightBtn setImage:[UIImage imageNamed:strRightTitle] forState:UIControlStateNormal];
        }else{
           CGSize size = [UIlabelTool sizeWithString:strRightTitle font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH];
           RightBtn = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/375*24  - size.width, MainStatusBarHeight, SCREEN_WIDTH/375*24 + size.width, MainNavgationBarHeight) title:nil titleColor:[UIColor blackColor] backgroundImage:nil andBlock:^{
                _blockRight();
            }];

            [RightBtn setTitle:strRightTitle forState:UIControlStateNormal];
            RightBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        }
    }
    [navigationView addSubview:RightBtn];
    
    return navigationView;
    
}



@end
