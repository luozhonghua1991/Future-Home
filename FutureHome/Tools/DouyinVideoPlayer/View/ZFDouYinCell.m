//
//  ZFDouYinCell.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinCell.h"
#import "UIImageView+ZFCache.h"
#import "UIView+ZFFrame.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "ZFLoadingView.h"

@interface ZFDouYinCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *commentBtn;
/** 评论数 */
@property (nonatomic, strong) UILabel *commentCountLabel;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;
/** 头像logo */
@property (nonatomic, strong) UIImageView *headerImgView;


@end

@implementation ZFDouYinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.headerImgView];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.likeCountLabel];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.commentCountLabel];
        [self.contentView addSubview:self.followBtn];
        [self.contentView addSubview:self.shareBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
    self.bgImgView.frame = self.contentView.bounds;
    self.effectView.frame = self.bgImgView.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    CGFloat margin = 30;
    
    min_w = 40;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
    self.shareBtn.frame = CGRectMake(min_x, min_y - 120, min_w, min_h);
    
    min_w = 40;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
    self.followBtn.frame = CGRectMake(min_x, min_y - 180, min_w, min_h);
    
    min_w = CGRectGetWidth(self.followBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.followBtn.frame);
    min_y = CGRectGetMinY(self.followBtn.frame) - min_h - margin;
    self.commentBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.followBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.commentBtn.frame);
    min_y = CGRectGetMinY(self.commentBtn.frame) - min_h - margin;
    self.likeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 20;
    min_h = 20;
    min_y = min_view_h - min_h - 50;
    min_w = self.likeBtn.zf_left - margin;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h *2);
    
    self.headerImgView.frame = CGRectMake(SCREEN_WIDTH - 67, self.likeBtn.frame.origin.y - 100, 50, 50);
    
    self.likeCountLabel.frame = CGRectMake(MinX(self.likeBtn), MaxY(self.likeBtn) + 8, self.likeBtn.frame.size.width, 15);
    self.commentCountLabel.frame = CGRectMake(MinX(self.commentBtn), MaxY(self.commentBtn) + 8, self.commentBtn.frame.size.width, 15);
    
}


/** 评论 */
- (void)commentBtnClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_ZFDouYinCellDelegateSelectCommontent:)]) {
        [_delegate fh_ZFDouYinCellDelegateSelectCommontent:self.data];
    }
}

/** 点赞 */
- (void)likeBtnClick:(UIButton *)likeBtn {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_ZFDouYinCellDelegateSelectLikeClicck:withBtn:withCountLabel:)]) {
        [_delegate fh_ZFDouYinCellDelegateSelectLikeClicck:self.data withBtn:likeBtn withCountLabel:self.likeCountLabel];
    }
}

/** 视频收藏 */
- (void)followBtnClick:(UIButton *)followBtn {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_ZFDouYinCellDelegateSelectFollowClick:withBtn:)]) {
        [_delegate fh_ZFDouYinCellDelegateSelectFollowClick:self.data withBtn:followBtn];
    }
}

/** 视频转发 */
- (void)shareBtnClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_ZFDouYinCellDelegateShareClick:)]) {
        [_delegate fh_ZFDouYinCellDelegateShareClick:self.data];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = 25;
        _headerImgView.layer.borderWidth = 1.5;
        _headerImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.clipsToBounds = YES;
    }
    return _headerImgView;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"点赞前 空心"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _likeBtn;
}

- (UILabel *)likeCountLabel {
    if (!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont boldSystemFontOfSize:15];
        _likeCountLabel.text = @"1";
        _likeCountLabel.textColor = [UIColor whiteColor];
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _likeCountLabel;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UILabel *)commentCountLabel {
    if (!_commentCountLabel) {
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.font = [UIFont boldSystemFontOfSize:15];
        _commentCountLabel.text = @"1";
        _commentCountLabel.textColor = [UIColor whiteColor];
        _commentCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _commentCountLabel;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}

- (void)setData:(ZFTableData *)data {
    _data = data;
//    if (data.thumbnail_width >= data.thumbnail_height) {
//        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.coverImageView.clipsToBounds = NO;
//    } else {
//        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.coverImageView.clipsToBounds = YES;
//    }
    
//    [self.coverImageView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"loading_bgView"]];
//    [self.bgImgView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"loading_bgView"]];
    
    if (_data.islike == 0) {
        /** 未点赞 */
        [self.likeBtn setImage:[UIImage imageNamed:@"点赞前 空心"] forState:UIControlStateNormal];
        self.likeBtn.tag = 0;
    } else if (_data.islike == 1) {
        /** 已经点赞 */
        [self.likeBtn setImage:[UIImage imageNamed:@"评论点赞后"] forState:UIControlStateNormal];
        self.likeBtn.tag = 1;
    }
    //是否收藏
    if (_data.isconnection == 0) {
        /** 未收藏 */
        [self.followBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        self.followBtn.tag = 0;
    } else if (_data.isconnection == 1) {
        /** 已收藏 */
        [self.followBtn setImage:[UIImage imageNamed:@"收藏后"] forState:UIControlStateNormal];
        self.followBtn.tag = 1;
    }
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@",_data.like];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@",_data.comment];
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_data.thumbnail_url]];
    self.titleLabel.text = data.title;
    
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
//        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

@end
