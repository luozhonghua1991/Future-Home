//
//  FHMainSearchController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMainSearchController.h"
#import "FHSearchResultController.h"

@interface FHMainSearchController () <UITextFieldDelegate>
/** 搜索文本框 */
@property (nonatomic, strong) UITextField *searchTF;
/** 关键字 */
@property (nonatomic, copy) NSString *searchText;

@end

@implementation FHMainSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SingleManager shareManager].isSearchStatues = YES;
    self.titleLabel.hidden = YES;
    [self setUpUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SingleManager shareManager].isSearchStatues = NO;
}

- (void)setUpUI {
    /** 创建搜索View */
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(MainNavgationBarHeight + 25, MainStatusBarHeight, SCREEN_WIDTH - 100, 35)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 15;
    searchView.clipsToBounds = YES;
    searchView.layer.masksToBounds = YES;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 22, 15);
    searchBtn.centerY = searchView.height / 2;
    [searchBtn setImage:[UIImage imageNamed:@"xingtaiduICON_sousuo--"] forState:UIControlStateNormal];
    [searchView addSubview:searchBtn];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(MaxX(searchBtn), 0, SCREEN_WIDTH - 100 - MaxX(searchBtn) - 20, 35)];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [self.searchTF becomeFirstResponder];
    self.searchTF.delegate = self;
    [searchView addSubview:self.searchTF];
    [self.navgationView addSubview:searchView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.searchText = textField.text;
    if ([string isEqualToString:@"\n"]) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.searchText,@"searchText", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETSEARCHRESULT" object:nil userInfo:dict];
        [self.searchTF  resignFirstResponder];
        return NO;
    }
    return YES;

}

- (void)initViewControllers {
    FHSearchResultController *person = [[FHSearchResultController alloc] init];
    person.yp_tabItemTitle = @"用户";
//    person.type = @"1";
    person.type = @"0";
    
    FHSearchResultController *photoVC = [[FHSearchResultController alloc] init];
    photoVC.yp_tabItemTitle = @"物业";
//    photoVC.type = @"2";
    photoVC.type = @"1";
    
    FHSearchResultController *property = [[FHSearchResultController alloc] init];
    property.yp_tabItemTitle = @"业主";
//    property.type = @"3";
    property.type = @"2";
    
    FHSearchResultController *fish = [[FHSearchResultController alloc] init];
    fish.yp_tabItemTitle = @"生鲜";
//    fish.type = @"4";
    fish.type = @"3";
    
    FHSearchResultController *bussiness = [[FHSearchResultController alloc] init];
    bussiness.yp_tabItemTitle = @"商业";
//    bussiness.type = @"5";
    bussiness.type = @"4";
    
    FHSearchResultController *health = [[FHSearchResultController alloc] init];
    health.yp_tabItemTitle = @"医药";
//    health.type = @"6";
    health.type = @"5";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:person, photoVC,property,fish,bussiness,health, nil];
}

@end
