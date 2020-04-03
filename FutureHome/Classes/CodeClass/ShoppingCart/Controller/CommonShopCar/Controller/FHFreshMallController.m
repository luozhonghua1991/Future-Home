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
#import "FHScanDetailAlertView.h"
#import "FHCustomerServiceCommitController.h"

@interface FHFreshMallController () <UIScrollViewDelegate>
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
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat lat;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat lng;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHScanDetailAlertView *codeDetailView;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *username;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCustomerServiceCommitController *conversationVC;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *shopMobie;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIButton *followBtn;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger is_collect;
/** <#assign属性注释#> */
@property (nonatomic, assign) CGFloat send_cost;


@end

@implementation FHFreshMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatUI];
    [self getRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)getRequest {
//    WS(weakSelf);
//    Account *account = [AccountStorage readAccount];
//    /** 判断商铺是否打烊 */
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @(account.user_id),@"user_id",
//                            self.shopID,@"shop_id",
//                            nil];
//
//    [AFNetWorkTool post:@"shop/isclose" params:params success:^(id responseObj) {
//        if ([responseObj[@"code"] integerValue] == 1) {
//
//        } else {
//            [weakSelf.view makeToast:responseObj[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//
//    }];
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
}

#pragma mark — privite
- (void)fh_creatNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
//    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.navgationView addSubview:shareBtn];
    
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.frame = CGRectMake(SCREEN_WIDTH - 28 * 2  - 20, MainStatusBarHeight +3, 28, 28);
    if ([self.isCollect isEqualToString:@"0"]) {
        [self.followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
    } else if ([self.isCollect isEqualToString:@"1"]) {
        [self.followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
    } else {
        [self.followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
    }
    
    [self.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:self.followBtn];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(SCREEN_WIDTH - 33, MainStatusBarHeight +5, 28, 28);
    [menuBtn setImage:[UIImage imageNamed:@"chazhaobiaodanliebiao"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:menuBtn];
}

/** 标题View */
- (void)fh_creatTitleView {
    if ([self.titleString isEqualToString:@"生鲜商城"]) {
        [SingleManager shareManager].ordertype = @"3";
    } else if ([self.titleString isEqualToString:@"商业商城"]) {
        [SingleManager shareManager].ordertype = @"4";
    } else if ([self.titleString isEqualToString:@"医药商城"]) {
        [SingleManager shareManager].ordertype = @"5";
    }
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 42)];
    titleView.userInteractionEnabled = YES;
    
    self.locationLabel.frame = CGRectMake(0, 12, SCREEN_WIDTH, 16);
    self.locationLabel.centerY = titleView.height / 2;
    self.locationLabel.userInteractionEnabled = YES;
    
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    
    [AFNetWorkTool get:@"shop/getSingShopInfo" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObj[@"data"];
            self.is_collect = [dic[@"iscollection"] integerValue];
            if (self.is_collect == 0) {
                [self.followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
            } else {
                [self.followBtn setImage:[UIImage imageNamed:@"06商家收藏右上角64*64"] forState:UIControlStateNormal];
            }
            [SingleManager shareManager].send_cost = [dic[@"send_cost"] floatValue];
            weakSelf.locationLabel.text = dic[@"shopname"];
            weakSelf.username = dic[@"username"];
            weakSelf.lat = [dic[@"lat"] floatValue];
            weakSelf.lng = [dic[@"lng"] floatValue];
            weakSelf.shopMobie = dic[@"shopmobile"];
            [SingleManager shareManager].shopName = dic[@"shopname"];
            [self initViewControllers];
            
            if ([dic[@"Ispass"] integerValue] == 3) {
                /** 店铺冻结 */
                NSArray *buttonTitleColorArray = @[[UIColor blueColor]] ;
                [UIAlertController ba_alertShowInViewController:self
                                                          title:@"温馨提示"
                                                        message:@"该商户已被冻结,如有需要请与平台客服联系"
                                               buttonTitleArray:@[@"确 定"]
                                          buttonTitleColorArray:buttonTitleColorArray
                                                          block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                              if (buttonIndex == 0) {
                                                                  [self menuBtnClick];
                                                              }
                                                              
                                                          }];
            }
            if ([dic[@"status"] integerValue] == 1) {
                /** 店铺打样 */
                NSArray *buttonTitleColorArray = @[[UIColor blueColor]] ;
                [UIAlertController ba_alertShowInViewController:self
                                                          title:@"温馨提示"
                                                        message:@"本店已经打烊休息了,暂停线上实时配送接单"
                                               buttonTitleArray:@[@"确 定"]
                                          buttonTitleColorArray:buttonTitleColorArray
                                                          block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                          }];
            }
            
        } else {
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
//    /** 获取商家详情 */
 
    [titleView addSubview:self.locationLabel];
    
    if (!self.codeImgView) {
        self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH * 0.116 - 20, SCREEN_WIDTH * 0.116 - 20)];
        self.codeImgView.contentMode = UIViewContentModeScaleToFill;
        self.codeImgView.image = [UIImage imageNamed:@"black_erweima"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImgViewClick)];
        self.codeImgView.userInteractionEnabled = YES;
        [self.codeImgView addGestureRecognizer:tap];
        
        [titleView addSubview:self.codeImgView];
    }
    
    self.navigationLabel.frame = CGRectMake(SCREEN_WIDTH - 40, 12, 30, 12);
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
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)followBtnClick:(UIButton *)sender {
    /** <#属性注释#> */
    if ([self.isCollect isEqualToString:@"0"] || self.is_collect == 0) {
        WS(weakSelf);
        Account *account = [AccountStorage readAccount];
        NSString *urlString;
        NSDictionary *paramsDic;
        urlString = @"public/collect";
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     self.shopID,@"id",
                     [SingleManager shareManager].ordertype,@"type",nil];
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
    } else if ([self.isCollect isEqualToString:@"1"] || self.is_collect == 1) {
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
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)codeImgViewClick {
    /** 二维码地图点击放大 */
    self.codeDetailView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
    [UIView animateWithDuration:0.3 animations:^{
        self.codeDetailView.alpha = 1;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
}

- (void)navigationLabelClick {
    /** y导航事件 */
    [CQRouteManager presentRouteNaviMenuOnController:self withCoordate:CLLocationCoordinate2DMake(self.lat, self.lng) destination:self.locationLabel.text];
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
    if ([self.titleString isEqualToString:@"生鲜商城"]) {
        messageVC.type = @"3";
    } else if ([self.titleString isEqualToString:@"商业商城"]) {
        messageVC.type = @"4";
    } else if ([self.titleString isEqualToString:@"医药商城"]) {
        messageVC.type = @"5";
    }
    messageVC.send_cost = self.send_cost;
    messageVC.yp_tabItemTitle = @"商品列表";
    messageVC.shopID = self.shopID;
    
    FHInformationController *groupVC = [[FHInformationController alloc] init];
    groupVC.yp_tabItemTitle = @"信息发布";
    groupVC.shopID = self.shopID;
    
    FHVideosPublishingController *hotVC = [[FHVideosPublishingController alloc] init];
    hotVC.yp_tabItemTitle = @"视频发布";
    hotVC.shopID = self.shopID;
    hotVC.videoListDataArrs = self.videosListArrs;
    
    self.conversationVC = [[FHCustomerServiceCommitController alloc] init];
    self.conversationVC.conversationType = ConversationType_PRIVATE;
    self.conversationVC.targetId = self.username;
    self.conversationVC.yp_tabItemTitle = @"对话记录";
    self.conversationVC.shopMobieString = self.shopMobie;
    self.conversationVC.type = @"custom";
    self.viewControllers = [NSMutableArray arrayWithObjects:messageVC, groupVC,hotVC,self.conversationVC, nil];
    
//    Account *account = [AccountStorage readAccount];
//    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @(account.user_id),@"user_id",
//                               @"3",@"type", nil];
//    [AFNetWorkTool get:@"service/index" params:paramsDic success:^(id responseObj) {
//        if ([responseObj[@"code"] integerValue] == 1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
                
//                RCUserInfo *userInfo = [[RCUserInfo alloc] init];
//                userInfo.userId = responseObj[@"data"][@"username"];
//                userInfo.name = responseObj[@"data"][@"nickname"];
//                userInfo.portraitUri = responseObj[@"data"][@"avatar"];
//                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
//            });
//        } else {
//            [self.view makeToast:responseObj[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//
//    }];
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

- (UILabel  *)locationLabel {
    if (!_locationLabel) {
        _locationLabel =  [[UILabel alloc] init];
        _locationLabel.text = @"";
        _locationLabel.textColor = [UIColor blueColor];
        _locationLabel.font = [UIFont boldSystemFontOfSize:16];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _locationLabel;
}

- (UILabel  *)navigationLabel{
    if (!_navigationLabel) {
        _navigationLabel =  [[UILabel alloc] init];
        _navigationLabel.text = @"导航";
        _navigationLabel.textColor = [UIColor blueColor];
        _navigationLabel.font = [UIFont systemFontOfSize:14];
        _navigationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabel;
}

- (FHScanDetailAlertView *)codeDetailView {
    if (!_codeDetailView) {
        _codeDetailView = [[FHScanDetailAlertView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        NSString *type;
        if ([self.titleString isEqualToString:@"生鲜商城"]) {
            type = @"3";
        } else if ([self.titleString isEqualToString:@"商业商城"]) {
            type = @"4";
        } else if ([self.titleString isEqualToString:@"医药商城"]) {
            type = @"5";
        }
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"com.sheyun",@"app_key",
                                   self.shopID,@"id",
                                   self.locationLabel.text,@"name",
                                   self.username,@"username",
                                   type,@"type",
                                   nil];
//        NSDictionary *codeDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"com.sheyun",@"app_key",
//                                   self.shopID,@"id",
//                                   type,@"type",
//                                   nil];
        _codeDetailView.dataDetaildic = paramsDic;
        //_codeDetailView.scanCodeDic = codeDic;
    }
    return _codeDetailView;
}

@end
