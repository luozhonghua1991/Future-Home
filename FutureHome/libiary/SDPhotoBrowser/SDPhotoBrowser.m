//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import "FDActionSheet.h"
//#import "TranspondViewController.h"

 
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"
#import "CurrentViewController.h"
//  =============================================
@interface SDPhotoBrowser ()<FDActionSheetDelegate>
@end
@implementation SDPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIView *bottomView;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.hidden =NO;
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }else{
         indexLabel.hidden =YES;
//        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
    // 灰色背景view
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = COLOR_18;
    bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    bottomView = bgView;
    [self addSubview:bgView];
    
//    // 2.保存按钮
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setImage:[UIImage imageNamed:@"personal_my_photo_forward"] forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
//    saveButton.layer.cornerRadius = 5;
//    saveButton.clipsToBounds = YES;
//    [saveButton addTarget:self action:@selector(ShowActionSheet) forControlEvents:UIControlEventTouchUpInside];
//    _saveButton = saveButton;
//    [bottomView addSubview:saveButton];
    
}
-(void)ShowActionSheet {
    if (self.pageType == GeneralView) {
        FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"转发", nil];
        [actionSheet setTitleColor:COLOR_3 fontSize:SCREEN_HEIGHT/667 *12];
        //    [actionSheet setButtonTitleColor:COLOR_3 bgColor:nil fontSize:SCREEN_HEIGHT/667 *12 atIndex:0];
        [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
        [actionSheet addAnimation];
        [actionSheet show];
    }else{
        FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"转发",@"保存到手机", nil];
        [actionSheet setTitleColor:COLOR_3 fontSize:SCREEN_HEIGHT/667 *12];
        //    [actionSheet setButtonTitleColor:COLOR_3 bgColor:nil fontSize:SCREEN_HEIGHT/667 *12 atIndex:0];
        [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
        [actionSheet addAnimation];
        [actionSheet show];
    }
}
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    if (self.pageType == GeneralView) {
        if (buttonIndex==0) {
            [self photoClick:nil];
            int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
            UIImageView *currentImageView = _scrollView.subviews[index];
//            TranspondViewController *transpond = [[TranspondViewController alloc]init];
//            transpond.image = currentImageView.image;
//            [[CurrentViewController topViewController].navigationController pushViewController:transpond animated:YES];
        }
    }else{
        if (buttonIndex==0) {
            [self photoClick:nil];
            int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
            UIImageView *currentImageView = _scrollView.subviews[index];
//            TranspondViewController *transpond = [[TranspondViewController alloc]init];
//            transpond.image = currentImageView.image;
//            [[CurrentViewController topViewController].navigationController pushViewController:transpond animated:YES];
        } else if(buttonIndex==1){
            [self saveImage];
        }
    }
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;

        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView sd_setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer {
    
    [UIApplication sharedApplication].statusBarHidden =NO;
    
    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    _saveButton.hidden = YES;
    bottomView.hidden = YES;
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;

    [view doubleTapToZommWithScale:scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
    _saveButton.frame = CGRectMake(SCREEN_WIDTH/375  *652/2, SCREEN_HEIGHT/667 *9, SCREEN_WIDTH/375 *24, SCREEN_HEIGHT/667 *22);
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT/667 *1246/2, SCREEN_WIDTH, SCREEN_HEIGHT/667 *44);
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    //--------自己修改-----------
    UIView *sourceView;
    if (self.pageType == ChatView) {
        sourceView = self.sourceImagesContainerView.subviews[0];
    }else{
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    }
    //--end--UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
}



@end
