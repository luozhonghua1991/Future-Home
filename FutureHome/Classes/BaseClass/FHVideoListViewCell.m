//
//  FHVideoListViewCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/11.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHVideoListViewCell.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVFoundation/AVFoundation.h>

@implementation FHVideoListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.logoImgView.centerX = self.contentView.width / 2;
    [self.contentView addSubview:self.logoImgView];
    self.listNameLabel.y = CGRectGetMaxY(self.logoImgView.frame) + 1;
    [self.contentView addSubview:self.listNameLabel];
}


- (void)setVideoListModel:(FHVideosListModel *)videoListModel {
    _videoListModel = videoListModel;
//    self.logoImgView.image = [self thumbnailImageForVideo:[NSURL URLWithString:_videoListModel.path] atTime:1];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:_videoListModel.cover]];
    self.listNameLabel.text = _videoListModel.videoname;
}

- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.contentView.width - 10, self.contentView.width)];
        _logoImgView.image = [UIImage imageNamed:@"头像"];
    }
    return _logoImgView;
}

- (UILabel *)listNameLabel {
    if (!_listNameLabel) {
        _listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.contentView.width - 10, 44)];
        _listNameLabel.textAlignment = NSTextAlignmentLeft;
        _listNameLabel.font = [UIFont systemFontOfSize:12];
        _listNameLabel.textColor = [UIColor blackColor];
        _listNameLabel.numberOfLines = 2;
#warning message
        _listNameLabel.text = @"标题内容展示区域标题内容展示区域标题内容展示区域标题内容展示区域标题内容展示区域";
    }
    return _listNameLabel;
}

@end
