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

@end

@implementation FHFreshMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    [self fh_creatTitleView];
    
//    [self fh_setSelectNavView];
//    [self fh_creatSelectBtn];
//    [self fh_setMainScrollView];
    
    self.view.backgroundColor= [UIColor whiteColor];
    [self setTabBarFrame:CGRectMake(0, MainSizeHeight + 35 , SCREEN_WIDTH, 35)
        contentViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = HEX_COLOR(0x1296db);
    self.tabBar.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.tabBar.itemTitleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
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
    
    [self fh_setupFollowDropDownMenu];
}


#pragma mark — privite
- (void)fh_creatNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"生鲜服务";
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
    [self.navgationView addSubview:shareBtn];
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.frame = CGRectMake(SCREEN_WIDTH - 35 * 2  - 10, MainStatusBarHeight, 35, 35);
    [followBtn setImage:[UIImage imageNamed:@"shoucang-3"] forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:followBtn];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - 5, MainStatusBarHeight, 35, 35);
    [menuBtn setImage:[UIImage imageNamed:@"chazhaobiaodanliebiao"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:menuBtn];
}

/** 标题View */
- (void)fh_creatTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 35)];
    titleView.backgroundColor = [UIColor greenColor];
    titleView.userInteractionEnabled = YES;
    
    if (!self.codeImgView) {
        self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 35, 35)];
        self.codeImgView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImgViewClick)];
        self.codeImgView.userInteractionEnabled = YES;
        [self.codeImgView addGestureRecognizer:tap];
        [titleView addSubview:self.codeImgView];
    }
    self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.codeImgView.frame) + 10, 12, 300, 12);
    self.locationLabel.userInteractionEnabled = YES;
    [titleView addSubview:self.locationLabel];
    
    self.navigationLabel.frame = CGRectMake(SCREEN_WIDTH - 65, 12, 50, 12);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationLabelClick)];
    self.navigationLabel.userInteractionEnabled = YES;
    [self.navigationLabel addGestureRecognizer:tap];
    [titleView addSubview:self.navigationLabel];
    
    [self.view addSubview:titleView];
}

- (void)fh_setSelectNavView {
    [self.view addSubview:self.selectNavView];
}

- (void)fh_creatSelectBtn {
    //我的社群 我的视界 商业服务 公共服务
    CGSize size1 = [UIlabelTool sizeWithString:@"生鲜商城" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    
    myGroupBtn = [self creatBtnWithFrame:CGRectMake(ZH_SCALE_SCREEN_Width(7),3, size1.width, self.selectNavView.frame.size.height)title:@"生鲜商城" tag:1];
    [myGroupBtn setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
    
    CGSize size2 = [UIlabelTool sizeWithString:@"信息发布" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    myVideoBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(myGroupBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size2.width, self.selectNavView.frame.size.height)title:@"信息发布" tag:2];
    
    CGSize size3 = [UIlabelTool sizeWithString:@"视频发布" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    businssServiceBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(myVideoBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size3.width, self.selectNavView.frame.size.height)title:@"视频发布" tag:3];
    
    CGSize size4 = [UIlabelTool sizeWithString:@"对话记录" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    publickServiceBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(businssServiceBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size4.width, self.selectNavView.frame.size.height)title:@"对话记录" tag:4];
}

- (void)fh_setMainScrollView {
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    [self.view insertSubview:mainScrollView belowSubview:self.navgationView];
    NSArray *views = @[self.myGroup.view, self.myVideo.view,self.businssService.view,self.puclicService.view];
    self.viewControllers = @[self.myGroup,self.myVideo,self.businssService,self.puclicService];
    for (int i = 0; i < self.viewControllers.count; i++){
        //添加背景，把四个VC的view贴到mainScrollView上面
        UIView *pageView = views[i];
        pageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, mainScrollView.frame.size.width, mainScrollView.frame.size.height);
        [mainScrollView addSubview:pageView];
    }
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * (self.viewControllers.count), 0);
}

//- (void)setViewControllers:(NSArray *)viewControllers {
//
//    for (UIViewController *controller in self.viewControllers) {
//        [controller removeFromParentViewController];
//        [controller.view removeFromSuperview];
//    }
//
//    _viewControllers = [viewControllers copy];
//    [_viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [self addChildViewController:obj];
//    }];
//
//    // 更新scrollView的content size
//    if (mainScrollView) {
//        mainScrollView.contentSize =  CGSizeMake(SCREEN_WIDTH * (self.viewControllers.count), 0);
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double index_ = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self sliderAnimationWithTag:(int)(index_ + 0.5) + 1];
    
}

/** 初始化收藏菜单 */
- (void)fh_setupFollowDropDownMenu {
    NSArray *modelsArray = [self getFollowMenuModelsArray];
    self.followDownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:ZH_SCALE_SCREEN_Width(150) eachItemHeight:ZH_SCALE_SCREEN_Height(50) menuRightMargin:kScreenWidth - ZH_SCALE_SCREEN_Width(150) - 10 triangleRightMargin:20];
    self.followDownMenu.triangleColor = [UIColor clearColor];
}

/** 获取收藏菜单模型数组 */
- (NSArray *)getFollowMenuModelsArray {
    __weak typeof(self) weakSelf = self;
    //添加收藏该生鲜店
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加收藏该生鲜店" menuItemIconName:@""  menuItemMessageNum:0 menuBlock:^{
    }];
    //添加为生鲜商城收藏
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加为生鲜商城收藏" menuItemIconName:@""  menuItemMessageNum:0 menuBlock:^{
    }];
    
    //确认
    FFDropDownMenuModel *menuModel2 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"确认" menuItemIconName:@"" menuItemMessageNum:0 menuBlock:^{
        /** 添加到收藏列表 */

    }];
    NSArray *menuModelArr = @[menuModel0, menuModel1,menuModel2];
    return menuModelArr;
}

#pragma mark — event
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 分享按钮 */
- (void)shareBtnClick {
    return;
    JSShareView *shareView =[JSShareView showShareViewWithPublishContent:@{@"text"  :@"",
                                                                           @"image" :@"",
                                                                           @"tittle":@"",
                                                                           @"url"   :@""
                                                                           }
                                                               DataArray:@[@{@(0):@[@{@"朋友圈":@"community_share_friend"}
                                                                                    ,@{@"微信":@"community_share_wechat"}
                                                                                    ,@{@"QQ":@"community_share_qq"}
                                                                                    ,@{@"QQ空间":@"community_share_space"}
                                                                                    ,@{@"新浪微博":@"community_share_weibo"}]}
                                                                           
                                                                           ,@{@(1):@[@{@"举报":@"community_share_report"}]}]
                                                              TypeArray1:@[]
                                                              TypeArray2:@[]
                                                            IsShowReport:YES
                                                            isLocalImage:NO
                                                             addViewType:@""
                                                                  Result:^(ShareType type, BOOL isSuccess) {
                                                                      if (isSuccess) {
                                                                          MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                                                                          [self.view addSubview:hud];
                                                                          hud.mode = MBProgressHUDModeText;
                                                                          hud.labelText = @"分享成功";
                                                                          hud.userInteractionEnabled = NO;
                                                                          hud.removeFromSuperViewOnHide = YES;
                                                                          [hud show:YES];
                                                                          [hud hide:YES afterDelay:2];
                                                                      } else{
                                                                          MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                                                                          [self.view addSubview:hud];
                                                                          hud.mode = MBProgressHUDModeText;
                                                                          hud.labelText = @"分享失败";
                                                                          hud.userInteractionEnabled = NO;
                                                                          hud.removeFromSuperViewOnHide = YES;
                                                                          [hud show:YES];
                                                                          [hud hide:YES afterDelay:2];
                                                                      }
                                                                  }];
    shareView.delegate = self;
    [self.view addSubview:shareView];
}

/** 收藏按钮 */
- (void)followBtnClick {
//    [self.followDownMenu showMenu];
    [self.view makeToast:@"添加收藏成功"];
}

/** 搜索事件 */
- (void)searchBtnClick {
    
}

/** 菜单按钮 */
- (void)menuBtnClick {
    //显示收藏列表菜单
//    [self.followDownMenu showMenu];
    /** 去到收藏列表 */
    FHFreshMallFollowListController *listVC = [[FHFreshMallFollowListController alloc] init];
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
    messageVC.yp_tabItemTitle = @"生鲜商城";
    
    FHInformationController *groupVC = [[FHInformationController alloc] init];
    groupVC.yp_tabItemTitle = @"信息发布";
    
    FHVideosPublishingController *hotVC = [[FHVideosPublishingController alloc] init];
    hotVC.yp_tabItemTitle = @"视频发布";
    
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
        _locationLabel.text = @"未来生鲜-龙湖U城店 CQ20180916001";
        _locationLabel.textColor = [UIColor purpleColor];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _locationLabel;
}

- (UILabel  *)navigationLabel{
    if (!_navigationLabel) {
        _navigationLabel =  [[UILabel alloc] init];
        _navigationLabel.text = @"一键导航";
        _navigationLabel.textColor = [UIColor purpleColor];
        _navigationLabel.font = [UIFont systemFontOfSize:12];
        _navigationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabel;
}


@end
