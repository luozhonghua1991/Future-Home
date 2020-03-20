//
//  FHBaseTabbarController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/19.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHTabbarController.h"
#import "BaseNavigationController.h"

@interface FHTabbarController () <UITabBarDelegate,UITabBarControllerDelegate>
/**tabbarItems*/
@property (nonatomic,copy) NSArray *tabBarItems;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIViewController *selectControll;


@end

@implementation FHTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBarController.tabBar.delegate = self;
    
    [self setupAllChildViewController];
}


- (void)setupAllChildViewController
{
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBarItems = @[
                         @{@"title":@"首页",@"name":@"FHHomePage",@"index":@"1"},
                         @{@"title":@"社云",@"name":@"FHGroup",@"index":@"2"},
                         @{@"title":@"商家服务",@"name":@"FHGroup",@"index":@"3"},
                         @{@"title":@"购物车",@"name":@"FHShopingCart",@"index":@"4"},
                         @{@"title":@"个人中心",@"name":@"FHMeCenter",@"index":@"5"}
                         ];
    [self rw_setTabbarWithTabbarItems:self.tabBarItems];
}

- (void)rw_setTabbarWithTabbarItems:(NSArray *)tabBarItems {
    for (NSDictionary *dict in tabBarItems) {
        NSString *name   = dict[@"name"];
        NSString *image  = [NSString stringWithFormat:@"tabbar_icon_%@",name];
        NSString *sImage = [NSString stringWithFormat:@"tabbar_icon_%@_selected",name];
        
        // 创建控制器
        //NSString *className = [NSString stringWithFormat:@"%@Controller",[name capitalizedString]];
        
        NSString *className = [NSString stringWithFormat:@"%@Controller",name];
        Class cls = NSClassFromString(className);
        
        // 创建导航控制器
        UIViewController *vc  = [cls new];
        UIViewController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        
        vc.tabBarItem.title = dict[@"title"];
        
        nav.tabBarItem.tag = [dict[@"index"] integerValue];
        
        if (nav.tabBarItem.tag == 3) {
            vc.tabBarItem.image = [[UIImage imageNamed:@"tabbar_icon_bussiness"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_bussiness_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:sImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        NSDictionary *norDict = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:13.0f]};
        NSDictionary *highDict = @{NSForegroundColorAttributeName:HEX_COLOR(0x1296db), NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        
        [vc.tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:highDict forState:UIControlStateSelected];
        
        // 调整title的垂直位置
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
        
        [self addChildViewController:nav];
    }
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [SingleManager shareManager].currentSelectIndex = tabBar.tag;
    
//    if (item.tag == 1) {
//        /** 首页的tabbar选中 */
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoHomePageController" object:nil];
//    }
//    if (item.tag == 2) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoGroupController" object:nil];
//    }
//    if (item.tag == 3) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoBuinessServiceController" object:nil];
//    }
}

#pragma mark --  setter getter
- (NSArray *)tabBarItems {
    if (!_tabBarItems) {
        _tabBarItems = [[NSArray alloc]init];
    }
    return _tabBarItems;
}

@end
