//
//  FHFreshMallController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHFreshMallController.h"
#import "FHGoodsListController.h"
#import "FHInformationController.h"
#import "FHVideosPublishingController.h"
#import "FHDialogueRecordController.h"
#import "FFDropDownMenuView.h"
#import "FHFreshMallFollowListController.h"
#import "JSShareView.h"
#import "FHHomePageController.h"
#import "FHMeCenterController.h"
#import "FHGroupController.h"

@interface FHFreshMallController () <UIScrollViewDelegate,JSShareViewDelegate>
{
    UIScrollView *mainScrollView;
    UIButton *myGroupBtn;
    UIButton *myVideoBtn;
    UIButton *businssServiceBtn;
    UIButton *publickServiceBtn;
}
/** 生鲜商城 */
@property (nonatomic, strong) FHGoodsListController *myGroup;
/** 信息发布 */
@property (nonatomic, strong) FHInformationController  *myVideo;
/** 视频发布 */
@property (nonatomic, strong) FHVideosPublishingController *businssService;
/** 对话记录 */
@property (nonatomic, strong) FHDialogueRecordController *puclicService;
/** 选择导航View */
@property (nonatomic, strong) UIView *selectNavView;
/** 二维码imgView */
@property (nonatomic, strong) UIImageView *codeImgView;
/** 位置label */
@property (nonatomic, strong) UILabel *locationLabel;
/** 导航label */
@property (nonatomic, strong) UILabel *navigationLabel;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;
/** 下拉菜单 收藏列表 去收藏 */
@property (nonatomic, strong) FFDropDownMenuView     *followDownMenu;
/** 下拉菜单 收藏列表数据 */
@property (nonatomic, strong) FFDropDownMenuView     *followListMenu;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *videosListArrs;

@end

@implementation FHFreshMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)getRequest {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    self.videosListArrs = [[NSMutableArray alloc] init];
    /** 获取视频列表 */
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(account.user_id),@"user_id",
                                      self.shopID,@"shop_id",
                                      @"1",@"page",
                                      @"100000",@"limit",
                                      nil];
    
    [AFNetWorkTool get:@"shop/getUserVideo" params:paramsDictionary success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.videosListArrs = responseObj[@"data"][@"list"];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)fh_creatUI {
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    [self fh_creatTitleView];
    self.view.backgroundColor= [UIColor whiteColor];
    [self setTabBarFrame:CGRectMake(0, MainSizeHeight + 42 , SCREEN_WIDTH, 35)
        contentViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = HEX_COLOR(0x1296db);
    self.tabBar.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.tabBar.itemTitleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.tabBar.itemSelectedBgColor = HEX_COLOR(0x1296db);
    if (KIsiPhoneX) {
        [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(33, 33, 0, 33) tapSwitchAnimated:YES];
    } else {
        [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(33, 31, 0, 31) tapSwitchAnimated:YES];
    }
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.tabBar addSubview:bottomLine];
    [self initViewControllers];
}

#pragma mark — privite
- (void)fh_creatNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 35 * 3 - 15, MainStatusBarHeight, 35, 35);
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navgationView addSubview:shareBtn];
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(SCREEN_WIDTH - 35 * 2  - 10, MainStatusBarHeight, 35, 35);
    if ([self.isCollect isEqualToString:@"0"]) {
        [followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
    } else if ([self.isCollect isEqualToString:@"1"]) {
        [followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
    } else {
        [followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
    }
    
    [followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:followBtn];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - 5, MainStatusBarHeight, 35, 35);
    [menuBtn setImage:[UIImage imageNamed:@"chazhaobiaodanliebiao"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:menuBtn];
}

/** 标题View */
- (void)fh_creatTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 42)];
    titleView.userInteractionEnabled = YES;
    
    if (!self.codeImgView) {
        self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 42, 42)];
        self.codeImgView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImgViewClick)];
        self.codeImgView.userInteractionEnabled = YES;
        [self.codeImgView addGestureRecognizer:tap];
        [titleView addSubview:self.codeImgView];
    }
    self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.codeImgView.frame) + 10, 12, 300, 15);
    self.locationLabel.centerY = titleView.height / 2;
    self.locationLabel.userInteractionEnabled = YES;
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id", nil];
    [AFNetWorkTool get:@"shop/getSingShopInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            weakSelf.locationLabel.text = dic[@"shopname"];
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
//    /** 获取商家详情 */
 
    [titleView addSubview:self.locationLabel];
    
    self.navigationLabel.frame = CGRectMake(SCREEN_WIDTH - 65, 12, 50, 12);
    self.navigationLabel.centerY = titleView.height / 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationLabelClick)];
    self.navigationLabel.userInteractionEnabled = YES;
    [self.navigationLabel addGestureRecognizer:tap];
    [titleView addSubview:self.navigationLabel];
    
    [self.view addSubview:titleView];
}

- (void)fh_setSelectNavView {
    [self.view addSubview:self.selectNavView];
}

#pragma mark — event
- (void)backBtnClick {
    /** 回到homePageVC */
    if ([[SingleManager shareManager].selectType isEqualToString:@"HomePage"]) {
        __block FHHomePageController *meVC ;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *  obj, NSUInteger idx, BOOL *  stop) {
            if([obj isKindOfClass:[FHHomePageController class]]) {
                meVC = (FHHomePageController *)obj;
            }
        }];
        [self.navigationController popToViewController:meVC animated:YES];
    } else if ([[SingleManager shareManager].selectType isEqualToString:@"MeCenter"]) {
        __block FHMeCenterController *vc;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *  obj, NSUInteger idx, BOOL *  stop) {
            if([obj isKindOfClass:[FHMeCenterController class]]) {
                vc = (FHMeCenterController *)obj;
            }
        }];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToViewController:vc animated:YES];
    } else if ([[SingleManager shareManager].selectType isEqualToString:@"Group"]) {
        __block FHGroupController *vc;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController *  obj, NSUInteger idx, BOOL *  stop) {
            if([obj isKindOfClass:[FHGroupController class]]) {
                vc = (FHGroupController *)obj;
            }
        }];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToViewController:vc animated:YES];
    }
}


- (void)followBtnClick:(UIButton *)sender {
    /** <#属性注释#> */
    if ([self.isCollect isEqualToString:@"0"]) {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSString *urlString;
        NSDictionary *paramsDic;
        urlString = @"public/collect";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     self.shopID,@"id",
                     @"3",@"type",nil];
        [AFNetWorkTool post:urlString params:paramsDic success:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1) {
                [weakSelf.view makeToast:@"收藏成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [sender setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
                });
            } else {
                [weakSelf.view makeToast:responseObj[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    } else if ([self.isCollect isEqualToString:@"1"]) {
        [self.view makeToast:@"已经收藏过该店铺"];
        return;
    } else {
        [self.view makeToast:@"已经收藏过该店铺"];
        return;
    }
}

/** 菜单按钮 */
- (void)menuBtnClick {
    /** 去到收藏列表 */
    FHFreshMallFollowListController *listVC = [[FHFreshMallFollowListController alloc] init];
    if ([self.titleString isEqualToString:@"生鲜商城"]) {
        listVC.titleString = @"生鲜收藏";
        listVC.type = @"3";
    } else if ([self.titleString isEqualToString:@"商业商城"]) {
        listVC.titleString = @"商业收藏";
        listVC.type = @"4";
    } else if ([self.titleString isEqualToString:@"医药商城"]) {
        listVC.titleString = @"医药收藏";
        listVC.type = @"5";
    }
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)codeImgViewClick {
    /** 二维码地图点击放大 */
    
}

- (void)navigationLabelClick {
    /** y一键导航事件 */
}


#pragma mark -- 创建Btn
- (UIButton *)creatBtnWithFrame:(CGRect )frame title:(NSString *)title tag:(NSInteger ) tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = tag;
    btn.opaque = true;
    [self.selectNavView addSubview:btn];
    
    return btn;
}

//Btn的点击方法
-(void)sliderAction:(UIButton *)sender {
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        self->mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * (sender.tag - 1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (UIButton *)theSeletedBtn {
    if (myGroupBtn.selected) {
        return myGroupBtn;
    } else if (myVideoBtn.selected){
        return myVideoBtn;
    } else if (businssServiceBtn.selected){
        return businssServiceBtn;
    } else if (publickServiceBtn.selected){
        return publickServiceBtn;
    } else{
        return nil;
    }
}

-(UIButton *)buttonWithTag:(NSInteger)tag {
    if (tag == 1) {
        return myGroupBtn;
    } else if (tag == 2){
        return myVideoBtn;
    } else if (tag == 3){
        return businssServiceBtn;
    } else if (tag == 4){
        return publickServiceBtn;
    } else{
        return nil;
    }
}

- (void)sliderAnimationWithTag:(NSInteger)tag{
    myGroupBtn.selected = NO;
    myVideoBtn.selected = NO;
    businssServiceBtn.selected = NO;
    publickServiceBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        [self->myGroupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self->myVideoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self->businssServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self->publickServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
    }];
}

- (void)initViewControllers {
    FHGoodsListController *messageVC = [[FHGoodsListController alloc] init];
    messageVC.yp_tabItemTitle = @"商品列表";
    messageVC.shopID = self.shopID;
    
    FHInformationController *groupVC = [[FHInformationController alloc] init];
    groupVC.yp_tabItemTitle = @"信息发布";
    groupVC.shopID = self.shopID;
    
    FHVideosPublishingController *hotVC = [[FHVideosPublishingController alloc] init];
    hotVC.yp_tabItemTitle = @"视频发布";
    hotVC.shopID = self.shopID;
    hotVC.videoListDataArrs = self.videosListArrs;
    
    FHDialogueRecordController *friendVC = [[FHDialogueRecordController alloc] init];
    friendVC.yp_tabItemTitle = @"对话记录";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,friendVC, nil];
}


#pragma mark — setter && getter#pragma mark - 懒加载
- (UIView *)selectNavView {
    if (!_selectNavView) {
        _selectNavView = [[UIView alloc] initWithFrame:CGRectMake(0, MainSizeHeight + 35, SCREEN_WIDTH, 35)];
        _selectNavView.backgroundColor = COLOR_16F(0x7CCD7C, 1);
    }
    return _selectNavView;
}

- (FHGoodsListController *)myGroup {
    if (!_myGroup) {
        _myGroup = [[FHGoodsListController alloc ] init];
    }
    return _myGroup;
}

- (FHInformationController *)myVideo {
    if (!_myVideo) {
        _myVideo = [[FHInformationController alloc] init];
    }
    return _myVideo;
}

- (FHVideosPublishingController *)businssService {
    if (!_businssService) {
        _businssService = [[FHVideosPublishingController alloc] init];
    }
    return _businssService;
}

- (FHDialogueRecordController *)puclicService{
    if (!_puclicService) {
        _puclicService =  [[FHDialogueRecordController alloc] init];
    }
    return _puclicService;
}

- (UILabel  *)locationLabel{
    if (!_locationLabel) {
        _locationLabel =  [[UILabel alloc] init];
        _locationLabel.text = @"";
        _locationLabel.textColor = [UIColor blackColor];
        _locationLabel.font = [UIFont systemFontOfSize:15];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _locationLabel;
}

- (UILabel  *)navigationLabel{
    if (!_navigationLabel) {
        _navigationLabel =  [[UILabel alloc] init];
        _navigationLabel.text = @"一键导航";
        _navigationLabel.textColor = [UIColor blueColor];
        _navigationLabel.font = [UIFont systemFontOfSize:12];
        _navigationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabel;
}


@end
