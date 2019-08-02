//
//  AnalyzPermisViewController.m
//  iphonetest
//
//  Created by 杭州任性贸易有限公司 on 16/4/8.
//  Copyright © 2016年 LWJ. All rights reserved.
//

#import "AnalyzPermisViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface AnalyzPermisViewController ()

@end

@implementation AnalyzPermisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Misc
+ (void)checkServiceEnable : (int)nType : (void(^)(BOOL))result{
    if (nType == 1) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            if (result) {
                result(NO);
            }
        }else if(authStatus == AVAuthorizationStatusAuthorized){
            //允许访问
            // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            NSLog(@"Authorized");
            if (result) {
                result(YES);
            }
        }else if(authStatus == AVAuthorizationStatusNotDetermined){
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    //点击允许访问时调用
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    NSLog(@"Granted access to %@", mediaType);
                    if (result) {
                        result(YES);
                    }
                }else {
                    NSLog(@"Not granted access to %@", mediaType);
                    if (result) {
                        result(NO);
                    }
                }
            }];
        }else {
            NSLog(@"Unknown authorization status");
            if (result) {
                result(NO);
            }
        }
    }else if (nType == 2) {
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    NSLog(@"允许使用麦克风！");
                    if (result) {
                        result(YES);
                    }
                }else {
                    NSLog(@"不允许使用麦克风！");
                    if (result) {
                        result(NO);
                    }
                }
            }];
        }
    }else if (nType == 3) {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
            //无权限
            if (result) {
                result(NO);
            }
        }else{
            if (result) {
                result(YES);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
