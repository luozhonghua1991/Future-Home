//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "FHLBXScanViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanVideoZoomView.h"
#import "FHHomeServicesController.h"
#import "FHOwnerServiceController.h"
#import "FHPersonTrendsController.h"
#import "FHFreshMallController.h"

@interface FHLBXScanViewController ()
@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommonFollowModel *model;

@end

@implementation FHLBXScanViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"二维码扫描";
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isQQSimulator) {
        [self drawBottomItems];
        [self drawTitle];
        [self.view bringSubviewToFront:_topTitle];
    }else{
        _topTitle.hidden = YES;
    }
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/667*60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码\n即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }    
}

- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
      
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        _zoomView.hidden = YES;
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {            
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
                
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
   
}

- (void)tap
{
//    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/3*2, CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/3, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
//    self.btnMyQR = [[UIButton alloc]init];
//    _btnMyQR.bounds = _btnFlash.bounds;
//    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
//    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
//    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
}


- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        //点击完，继续扫码
        [weakSelf reStartDevice];
    } buttonsStatement:@"知道了",nil];
}

#pragma mark — 二维码扫描结果处理
/** 扫描的结果的相关处理 */
- (void)showNextVCWithScanResult:(LBXScanResult*)strResult {
    ZHLog(@"扫描出来的二维码内容:%@",strResult.strScanned);
    NSDictionary *resultDic = [self dictionaryWithJsonString:strResult.strScanned];
    if ([resultDic[@"app_key"] isEqualToString:@"com.sheyun"]) {
        /** 社云相关的二维码 */
        NSInteger type = [resultDic[@"type"] integerValue];
        if (type == 0) {
            /** 用户 */
            FHPersonTrendsController *vc = [[FHPersonTrendsController alloc] init];
            vc.titleString = resultDic[@"name"];
            [SingleManager shareManager].isSelectPerson = YES;
            vc.hidesBottomBarWhenPushed = YES;
            vc.user_id = resultDic[@"id"];
            vc.personType = 0;
            [[CurrentViewController topViewController].navigationController pushViewController:vc animated:YES];
        } else if (type == 1) {
            /** 物业 */
            FHHomeServicesController *home = [[FHHomeServicesController alloc]init];
            home.model = [FHCommonFollowModel new];
            [home setHomeSeverID:[resultDic[@"id"] integerValue] homeServerName:resultDic[@"name"]];
            home.hidesBottomBarWhenPushed = NO;
            [self.navigationController pushViewController:home animated:YES];
        } else if (type == 2) {
            /** 业委 */
            
        } else if (type == 3) {
            FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
            goodList.hidesBottomBarWhenPushed = YES;
            goodList.titleString = @"生鲜商城";
            goodList.shopID = resultDic[@"id"];
            [[CurrentViewController topViewController].navigationController pushViewController:goodList animated:YES];
        } else if (type == 4) {
            FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
            goodList.hidesBottomBarWhenPushed = YES;
            goodList.titleString = @"商业商城";
            goodList.shopID = resultDic[@"id"];
            [[CurrentViewController topViewController].navigationController pushViewController:goodList animated:YES];
        } else if (type == 5) {
            FHFreshMallController *goodList = [[FHFreshMallController alloc] init];
            goodList.hidesBottomBarWhenPushed = YES;
            goodList.titleString = @"医药商城";
            goodList.shopID = resultDic[@"id"];
            [[CurrentViewController topViewController].navigationController pushViewController:goodList animated:YES];
        }
    } else {
        [self.view makeToast:@"无法识别该二维码"];
//        [self.navigationController popViewControllerAnimated:YES];
    }
//    NSArray *array = [strResult.strScanned componentsSeparatedByString:@"goods-"];
//    if (array.count == 2) {
//        NSArray *array1 = [[array objectAtIndex:1] componentsSeparatedByString:@".html"];
//        ZHLog(@"扫描出来的产品ID:%@",[array1 objectAtIndex:0]);
//
////        [self.navigationController pushViewController:goodsDetailVC animated:YES];
//    }else{
//        NSURL * url = [NSURL URLWithString: strResult.strScanned];
//        if ([[UIApplication sharedApplication] canOpenURL: url]) {
//            [[UIApplication sharedApplication] openURL: url];
//        } else {
//
//        }
//    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        [self.view makeToast:@"无法识别该二维码"];
//        [self.navigationController popViewControllerAnimated:YES];
        return nil;
    }
    return dic;
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }else{
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
}


#pragma mark -底部功能项
- (void)myQRCode
{
//    MyQRViewController *vc = [MyQRViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}



@end
