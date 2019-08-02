//
//  FHScanTool.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/1.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  调用扫描二维码事件

#import "FHScanTool.h"
#import "AnalyzPermisViewController.h"
#import "FHLBXScanViewController.h"
#import "LBXScanView.h"

@implementation FHScanTool

+ (void)fh_makeScanClick {
    ZHLog(@"二维码点击事件");
    [AnalyzPermisViewController checkServiceEnable:1 :^(BOOL finished) {
        if (finished == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //设置扫码区域参数设置
            
            //创建参数对象
            LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
            
            //矩形区域中心上移，默认中心点为屏幕中心点
            style.centerUpOffset = 44;
            
            //扫码框周围4个角的类型,设置为外挂式
            style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
            
            //扫码框周围4个角绘制的线条宽度
            style.photoframeLineW = 6;
            
            //扫码框周围4个角的宽度
            style.photoframeAngleW = 24;
            
            //扫码框周围4个角的高度
            style.photoframeAngleH = 24;
            
            //扫码框内 动画类型 --线条上下移动
            style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
            
            //线条上下移动图片
            style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
            
            //SubLBXScanViewController继承自LBXScanViewController
            //添加一些扫码或相册结果处理
            FHLBXScanViewController *vc = [FHLBXScanViewController new];
            vc.style = style;
            vc.isQQSimulator = YES;
            vc.isVideoZoom = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [[CurrentViewController topViewController].navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
