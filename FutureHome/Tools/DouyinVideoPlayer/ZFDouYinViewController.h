//
//  ZFDouYinViewController.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFDouYinViewController : UIViewController
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *shopID;
/** <#strong属性注释#> */
@property (nonatomic, copy) NSArray *videoListDataArrs;
/** 1生鲜 2朋友圈 */
@property (nonatomic, copy) NSString *type;


- (void)playTheIndex:(NSInteger)index;

@end
