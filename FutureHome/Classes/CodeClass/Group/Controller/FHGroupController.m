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

@interface FHGroupController () <UIScrollViewDelegate>
{
    UIScrollView *mainScrollView;
}
/** 我的社群 */
@property (nonatomic, strong) FHMyGroupController *myGroup;
/** 我的视界 */
@property (nonatomic, strong) FHMyVideoController  *myVideo;
/** 商业服务 */
@property (nonatomic, strong) FHBusinessServicesController *businssService;
/** 公共服务 */
@property (nonatomic, strong) FHPublicServiceController *puclicService;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

@end

@implementation FHGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNav = NO;
    [self fh_setMainScrollView];
}


#pragma mark — privite
- (void)fh_setMainScrollView {
    CGFloat tabbarH = [self getTabbarHeight];
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH)];
    mainScrollView.delegate = self;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    [self.view insertSubview:mainScrollView belowSubview:self.view];
    NSArray *views = @[self.myGroup.view, self.myVideo.view,self.businssService.view,self.puclicService.view];
    self.viewControllers = @[self.myGroup,self.myVideo,self.businssService,self.puclicService];
    for (int i = 0; i < self.viewControllers.count; i++){
        //添加背景，把三个VC的view贴到mainScrollView上面
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    send=YES;
//    double index_ = scrollView.contentOffset.x / SCREEN_WIDTH;
////    [self sliderAnimationWithTag:(int)(index_+0.5)+1];
//    if (mainScrollView.contentOffset.x == SCREEN_WIDTH *2 ) {
//
//        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOADRANKLIST" object:nil];
//    }
//
//}


#pragma mark — setter && getter#pragma mark - 懒加载
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
