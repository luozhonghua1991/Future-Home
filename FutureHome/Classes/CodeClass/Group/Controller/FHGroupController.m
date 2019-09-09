//
//  FHGroupController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/6/24.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHGroupController.h"
#import "FHMyGroupController.h"
#import "FHMyVideoController.h"
#import "FHBusinessServicesController.h"
#import "FHPublicServiceController.h"
#import "FHCreatRrendsController.h"

@interface FHGroupController () <UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
    UIButton *myGroupBtn;
    UIButton *myVideoBtn;
    UIButton *businssServiceBtn;
    UIButton *publickServiceBtn;
}
/** 创建动态 */
@property (nonatomic, strong) UIButton *creatRrendsBtn;
/** 我的社群 */
@property (nonatomic, strong) FHMyGroupController *myGroup;
/** 我的视界 */
@property (nonatomic, strong) FHMyVideoController  *myVideo;
/** 商业服务 */
@property (nonatomic, strong) FHBusinessServicesController *businssService;
/** 公共服务 */
@property (nonatomic, strong) FHPublicServiceController *puclicService;
/** 选择导航View */
@property (nonatomic, strong) UIView *selectNavView;


@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

@end

@implementation FHGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_setSelectNavView];
    [self fh_creatSelectBtn];
    [self fh_setMainScrollView];
    if (self.isSelectBuiness) {
        mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
    } else {
        mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 0, 0);
    }
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    if (self.isSelectBuiness) {
        titleLabel.text = @"商家服务";
    } else {
//        titleLabel.text = @"社群";
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(60, MainStatusBarHeight, SCREEN_WIDTH - 130, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 15;
    searchView.clipsToBounds = YES;
    searchView.layer.masksToBounds = YES;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 50, 15);
    searchBtn.centerX = searchView.width / 2;
    searchBtn.centerY = searchView.height / 2;
    [searchBtn setTitle:@" 搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setImage:[UIImage imageNamed:@"xingtaiduICON_sousuo--"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    [self.navgationView addSubview:searchView];
    
//    self.creatRrendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.creatRrendsBtn.frame = CGRectMake(SCREEN_WIDTH - MainNavgationBarHeight - 15 , MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
//    [self.creatRrendsBtn setTitle:@"+" forState:UIControlStateNormal];
//    [self.creatRrendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.creatRrendsBtn.titleLabel.font = [UIFont systemFontOfSize:30];
//    [self.creatRrendsBtn addTarget:self action:@selector(creatRrendsBtnClick) forControlEvents:UIControlEventTouchUpInside];
//     [self.navgationView addSubview:self.creatRrendsBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/** 发布动态 */
- (void)creatRrendsBtnClick {
    FHCreatRrendsController *creat = [[FHCreatRrendsController alloc] init];
    creat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creat animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveToGroup) name:@"GoGroupController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveToBuiness) name:@"GoBuinessServiceController" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GoGroupController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GoBuinessServiceController" object:nil];
    
}

- (void)moveToGroup {
    mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 0, 0);
}

- (void)moveToBuiness {
    mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
}


#pragma mark — privite
- (void)fh_setSelectNavView {
    [self.view addSubview:self.selectNavView];
}

- (void)fh_creatSelectBtn {
    //我的社群 我的视界 商业服务 公共服务
    CGSize size1 = [UIlabelTool sizeWithString:@"我的社群" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    
    myGroupBtn = [self creatBtnWithFrame:CGRectMake(ZH_SCALE_SCREEN_Width(7),3, size1.width, self.selectNavView.frame.size.height)title:@"我的社群" tag:1];
    [myGroupBtn setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
    
    CGSize size2 = [UIlabelTool sizeWithString:@"我的视界" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    myVideoBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(myGroupBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size2.width, self.selectNavView.frame.size.height)title:@"我的视界" tag:2];
    
    CGSize size3 = [UIlabelTool sizeWithString:@"商家服务" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    businssServiceBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(myVideoBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size3.width, self.selectNavView.frame.size.height)title:@"商家服务" tag:3];
    
    CGSize size4 = [UIlabelTool sizeWithString:@"公共服务" font:[UIFont systemFontOfSize:16] width:SCREEN_WIDTH];
    publickServiceBtn = [self creatBtnWithFrame:CGRectMake(CGRectGetMaxX(businssServiceBtn.frame) + ZH_SCALE_SCREEN_Width(35),3, size4.width, self.selectNavView.frame.size.height)title:@"公共服务" tag:4];
}

- (void)fh_setMainScrollView {
    CGFloat tabbarH = [self getTabbarHeight];
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,MainSizeHeight + 35, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH - 35)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    [self.view insertSubview:mainScrollView belowSubview:self.selectNavView];
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

- (void)setViewControllers:(NSArray *)viewControllers {
    
    for (UIViewController *controller in self.viewControllers) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    _viewControllers = [viewControllers copy];
    [_viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:obj];
    }];
    
    // 更新scrollView的content size
    if (mainScrollView) {
        mainScrollView.contentSize =  CGSizeMake(SCREEN_WIDTH * (self.viewControllers.count), 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double index_ = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self sliderAnimationWithTag:(int)(index_ + 0.5) + 1];

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

#pragma mark — setter && getter#pragma mark - 懒加载
- (UIView *)selectNavView {
    if (!_selectNavView) {
        _selectNavView = [[UIView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, 35)];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [_selectNavView addSubview:bottomLine];
    }
    return _selectNavView;
}

- (FHMyGroupController *)myGroup {
    if (!_myGroup) {
        _myGroup = [[FHMyGroupController alloc ] init];
    }
    return _myGroup;
}

- (FHMyVideoController *)myVideo {
    if (!_myVideo) {
        _myVideo = [[FHMyVideoController alloc] init];
    }
    return _myVideo;
}

- (FHBusinessServicesController *)businssService {
    if (!_businssService) {
        _businssService = [[FHBusinessServicesController alloc] init];
    }
    return _businssService;
}

- (FHPublicServiceController *)puclicService{
    if (!_puclicService) {
        _puclicService =  [[FHPublicServiceController alloc] init];
    }
    return _puclicService;
}

@end
