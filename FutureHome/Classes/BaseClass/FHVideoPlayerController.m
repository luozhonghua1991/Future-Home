//
//  FHVideoPlayerController.m
//  SayU
//
//  Created by 性用社 on 16/11/16.
//  Copyright © 2016年 xys. All rights reserved.
//

#import "FHVideoPlayerController.h"
#import "WMPlayer.h"
#import "SingleManager.h"
#define TheUserDefaults [NSUserDefaults standardUserDefaults]
#define kHistoryTime @"HistoryTime"
#import <AVFoundation/AVFoundation.h>
@interface FHVideoPlayerController ()<AVAudioSessionDelegate,WMPlayerDelegate>
{
    UIView *navigationView;//导航栏
    
     CGRect     playerFrame;
}
@property (strong, nonatomic) WMPlayer *wmPlayer;//视频播放器
@property(nonatomic,assign)WMPlayerState nowStatue; //播放状态

@end

@implementation FHVideoPlayerController
//视图控制器实现的方法
-(BOOL)shouldAutorotate{       //iOS6.0之后,要想让状态条可以旋转,必须设置视图不能自动旋转
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
    self.view.backgroundColor = [UIColor blackColor];
    _wmPlayer =[[WMPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _wmPlayer.center = self.view.center;
    _wmPlayer.delegate =self;
//    [self.wmPlayer setURLString:self.URLString];
    [self.wmPlayer setURLString:@"http://xys-app-file.oss-cn-hangzhou.aliyuncs.com/video/2017/6/9/149694206055269.mp4"];
    [self.wmPlayer setTitleStr:self.titleStr];
    self.wmPlayer.closeBtn.hidden = NO;
//    self.wmPlayer.player.automaticallyWaitsToMinimizeStalling = NO;
    [self.view addSubview:self.wmPlayer];
    [self.view addSubview:navigationView];
    [self.wmPlayer play];
    

// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [self toolbarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self toolbarHidden:NO];
    //暂停
    [self.wmPlayer pause];
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark  -- 释放播放器
- (void)releaseWMPlayer
{
    //堵塞主线程
    //    [self.wmPlayer.player.currentItem cancelPendingSeeks];
    //    [self.wmPlayer.player.currentItem.asset cancelLoading];
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    self.wmPlayer.player = nil;
    self.wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.wmPlayer.autoDismissTimer invalidate];
    self.wmPlayer.autoDismissTimer = nil;
    self.wmPlayer.playOrPauseBtn = nil;
    self.wmPlayer.playerLayer = nil;
    self.wmPlayer = nil;
}

- (void)dealloc{
//    double time = [self.wmPlayer currentTime];
//    [TheUserDefaults setDouble:time forKey:kHistoryTime];
//    NSLog(@"TestViewController dealloc");
    [self releaseWMPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
//    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

#pragma mark  -- WMPlayerDelegate
//全屏按钮
-(void)wmplayer:(WMPlayer *)wmplayer1 clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (_wmPlayer.isFullscreen==YES) {//全屏
       [self toOrientation:UIInterfaceOrientationPortrait];
        _wmPlayer.isFullscreen = NO;
//        self.enablePanGesture = YES;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    } else{//非全屏
      [self toOrientation:UIInterfaceOrientationLandscapeRight];
        _wmPlayer.isFullscreen = YES;
//        self.enablePanGesture = NO;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
    
}
#pragma mark  -- 点击返回
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    if (wmplayer.isFullscreen) {
        [self toOrientation:UIInterfaceOrientationPortrait];
        self.wmPlayer.isFullscreen = NO;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
//        self.enablePanGesture = YES;
    } else{
        [self releaseWMPlayer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerFinishedPlay");
    
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    //获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    //判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) {
        return;
    }
    
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation ==UIInterfaceOrientationPortrait) {//
        [_wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.bottom.top.equalTo(self.view).offset(0);
//            make.height.equalTo(@200);
//            make.center.equalTo(self.view);
        }];
    }else{
        //这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation ==UIInterfaceOrientationPortrait) {
            [_wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(SCREEN_HEIGHT));
                make.height.equalTo(@(SCREEN_WIDTH));
                make.center.equalTo(_wmPlayer.superview);
            }];
        }
    }
    //iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    //也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
//    [self shouldAutorotate];
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    //获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    //更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    //给你的播放视频的view视图设置旋转
    _wmPlayer.transform = CGAffineTransformIdentity;
    _wmPlayer.transform = [WMPlayer getCurrentDeviceOrientation];
    [UIView setAnimationDuration:2.0];
    //开始旋转
    [UIView commitAnimations];
}



- (void)applicationWillResignActive:(NSNotification *)notification
{
    printf("触发home按下\n");
    //暂停
    [self.wmPlayer pause];
    
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    printf("重新进来后响应\n");
    //播放
    [self.wmPlayer play];
}
#pragma mark  -- 监听耳机的插拔事件
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            ZHLog(@"耳机插入");
            //播放
            [self.wmPlayer play];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            ZHLog(@"耳机拔出，停止播放操作");
            //暂停
            [self.wmPlayer pause];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            ZHLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

@end


