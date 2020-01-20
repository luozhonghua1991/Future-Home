//
//  FHPersonCommitsMainController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHPersonCommitsMainController.h"
#import "FHPersonCommitsListController.h"

@interface FHPersonCommitsMainController ()
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *leftTitle;
/** copy属性注释 */
@property (nonatomic, copy) NSString *centerTitle;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *rightTitle;

@end

@implementation FHPersonCommitsMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    [AFNetWorkTool get:@"shop/getCommentVillegas" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *arr = responseObj[@"data"];
            weakSelf.leftTitle = arr[0];
            weakSelf.centerTitle = arr[1];
            weakSelf.rightTitle = arr[2];
            [weakSelf initViewControllers];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)initViewControllers {
    FHPersonCommitsListController *messageVC = [[FHPersonCommitsListController alloc] init];
    messageVC.yp_tabItemTitle = [NSString stringWithFormat:@"满意%@",self.leftTitle];
    messageVC.shopID = self.shopID;
    messageVC.experience = @"1";
    
    FHPersonCommitsListController *groupVC = [[FHPersonCommitsListController alloc] init];
    groupVC.yp_tabItemTitle = [NSString stringWithFormat:@"一般%@",self.centerTitle];
    groupVC.shopID = self.shopID;
    groupVC.experience = @"2";
    
    FHPersonCommitsListController *hotVC = [[FHPersonCommitsListController alloc] init];
    hotVC.yp_tabItemTitle = [NSString stringWithFormat:@"不满意%@",self.rightTitle];
    hotVC.shopID = self.shopID;
    hotVC.experience = @"3";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC, nil];
}

@end
