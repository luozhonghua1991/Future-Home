//
//  HWImagePickerSheet.m
//  PhotoSelector
//
//  Created by 洪雯 on 2017/1/12.
//  Copyright © 2017年 洪雯. All rights reserved.
//

#import "HWImagePickerSheet.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface HWImagePickerSheet ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) MBProgressHUD *videoHud;

/** <#copy属性注释#> */
@property (nonatomic, strong) UIImage *videoImage;


@end

@implementation HWImagePickerSheet
-(instancetype)init {
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
    }
    return self;
}

//显示选择照片提示Sheet
-(void)showImgPickerActionSheetInView:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择上传类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self->imaPic) {
            self->imaPic = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self->imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            self->imaPic.delegate = self;
            [self->viewController presentViewController:self->imaPic animated:NO completion:nil];
        }
        
    }];
    
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImgDataAndShowAllGroup];
    }];
    
    if (![SingleManager shareManager].isComplaintsSuggestions) {
        /** 拍摄视频 */
        UIAlertAction *actionVideo = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"录制视频"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /** 拍摄视频 */
            [self addTakeVideo];
        }];
        [alertController addAction:actionVideo];
    }
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    
    
    viewController = controller;
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

//调用系统录像
- (void)addTakeVideo
{
    _imagePickerVc = [[UIImagePickerController alloc] init];
    _imagePickerVc.delegate = self;
    _imagePickerVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerVc.allowsEditing = YES;
    _imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerVc.videoMaximumDuration = 10.0;
    _imagePickerVc.modalPresentationStyle=UIModalPresentationOverFullScreen;
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerVc.mediaTypes = @[(NSString *)kUTTypeMovie];
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    
    _imagePickerVc.videoQuality = UIImagePickerControllerQualityTypeHigh;
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerVc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self->viewController presentViewController:self.imagePickerVc animated:NO completion:nil];
}

- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL completeHandler:(void (^)(AVAssetExportSession*))handler {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
             {
                 NSLog(@"我录制的视频时长为:%@",[NSString stringWithFormat:@"%.2f s", [self getVideoLength:outputURL]]);
                 NSLog(@"我压缩后的视频大小为:%@", [NSString stringWithFormat:@"%.2f mb", [self getFileSize:[outputURL path]]]);
                 
                 UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, @selector(videoSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);//这个是保存到手机相册
                 
                 break;
             }
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
}


//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat)getVideoLength:(NSURL *)URL
{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

- (CGFloat)getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = - 1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

#pragma mark - 加载照片数据
- (void)loadImgDataAndShowAllGroup{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (self->_arrSelected) {
                    svc.arrSeleted = self->_arrSelected;
                    svc.mvc.arrSelected = self->_arrSelected;
                }
                svc.maxCout = self->_maxCount;
                [self->viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        /** 图片相关的 */
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]) {
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (theImage) {
            //保存图片到相册中
            MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
            [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                } else {
                    
                    //获取图片路径
                    [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        if (asset) {
                            
                            [self->_arrSelected addObject:asset];
                            [self finishSelectImg];
                            [picker dismissViewControllerAnimated:NO completion:nil];
                        }
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }
            }];
        }
    } else {
        /** 视频的相关操作 */
        NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"我获取到的未压缩前的视频大小是:%@", [NSString stringWithFormat:@"%.2f mb", [self getFileSize:[sourceURL path]]]);
        if ([[NSString stringWithFormat:@"%.2f", [self getFileSize:[sourceURL path]]] integerValue]>=1024) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            MBProgressHUD *Hud = [[MBProgressHUD alloc] initWithView:window];
            [window addSubview:Hud];
            Hud.mode = MBProgressHUDModeText;
            Hud.label.text = @"视频过大";
            Hud.userInteractionEnabled = NO;
            Hud.removeFromSuperViewOnHide = YES;
            [Hud showAnimated:YES];
            [Hud hideAnimated:YES afterDelay:2];
            return;
        }
        
        //显示加载视图
        [[UIApplication sharedApplication].keyWindow addSubview:self.videoHud];
        
        NSURL *newVideoUrl ; //一般.mp4
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]]];//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
        [SingleManager shareManager].videoPath = [newVideoUrl absoluteString];
        //视频压缩
        [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    }
}

// 视频保存回调
- (void)videoSavedToPhotosAlbum:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [SingleManager shareManager].isSelectVideo = YES;
        //获取视频缩略图
        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
        moviePlayer.shouldAutoplay = NO;
        UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        self.videoImage = thumbnail;
        [self finishSelectImg];
        //隐藏加载视图
        [self.videoHud hideAnimated:YES];
        self.videoHud = nil;
    }else{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"视频保存失败";
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:2];
    }
}


#pragma mark - 完成选择后返回的图片Array(ALAsset*)
- (void)finishSelectImg{
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    if ([SingleManager shareManager].isSelectVideo) {
        [thumbnailImgArr addObject:self.videoImage];
    } else {
        for (ALAsset *set in _arrSelected) {
            //        CGImageRef cgImg = [set thumbnail];
            CGImageRef cgImg = [set aspectRatioThumbnail];
            UIImage* image = [UIImage imageWithCGImage: cgImg];
            [thumbnailImgArr addObject:image];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
        [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
    }
}

- (MBProgressHUD *)videoHud{
    if (_videoHud == nil) {
        _videoHud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _videoHud.mode = MBProgressHUDModeIndeterminate;
        _videoHud.removeFromSuperViewOnHide = YES;
        _videoHud.label.text = @"视频处理中...";
        [_videoHud showAnimated:YES];
    }
    return _videoHud;
}

@end
