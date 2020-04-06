//
//  FHArticleOrVideoShareCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/1/10.
//  Copyright © 2020 同熙传媒. All rights reserved.
//  文章或者视频分享的cell

#import "FHArticleOrVideoShareCell.h"
#import "ZJCommit.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZJCategory.h"
#import "ZJUIMasonsyKit.h"

#define kBlackColor       [UIColor blackColor]
#define kDarkGrayColor    [UIColor darkGrayColor]
#define kLightGrayColor   [UIColor lightGrayColor]
#define kWhiteColor       [UIColor whiteColor]
#define kRedColor         [UIColor redColor]
#define kBlueColor        [UIColor blueColor]
#define kGreenColor       [UIColor greenColor]
#define kCyanColor        [UIColor cyanColor]
#define kYellowColor      [UIColor yellowColor]
#define kMagentaColor     [UIColor magentaColor]
#define kOrangeColor      [UIColor orangeColor]
#define kPurpleColor      [UIColor purpleColor]
#define kBrownColor       [UIColor brownColor]
#define kClearColor       [UIColor clearColor]

@interface FHArticleOrVideoShareCell()

// 昵称
@property(nonatomic ,strong) UILabel        *nameLab;
// 头像
@property(nonatomic ,strong) UIImageView    *avatar;
// 时间
@property(nonatomic ,strong) UILabel        *timeLab;
// 内容
@property(nonatomic ,strong) UILabel        *contentLab;
// 分割线
@property(nonatomic ,strong) UIView         *line;

/** 灰色背景View */
@property (nonatomic, strong) UIView *lightGrayView;
/**封面图 */
@property (nonatomic, strong) UIImageView *corverImg;
/** 上面的label */
@property (nonatomic, strong) UILabel *topLabel;
/** 下面的label */
@property (nonatomic, strong) UILabel *bottomLabel;
/** 视频图片 */
@property (nonatomic, strong) UIImageView   *videoPlayImageView;

/** 底部View */
@property (nonatomic, strong) UIView         *bottomView;
// 最上面的分割线
@property(nonatomic ,strong) UIView         *topLine;
/** 浏览次数 */
@property (nonatomic, strong) UIButton *eyeBtn;
/** 点赞按钮 */
@property (nonatomic, strong) UIButton *upBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commitBtn;


@end

@implementation FHArticleOrVideoShareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}


-(void)setModel:(ZJCommit *)model {
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:nil];
    
    self.nameLab.text = _model.nickname;
    
    self.timeLab.text = _model.add_time;
    self.contentLab.text = _model.content;
    
    if (_model.like_status == 2) {
        [self.upBtn setImage:[UIImage imageNamed:@"1点赞"] forState:UIControlStateNormal];
        [self.upBtn addTarget:self action:@selector(upBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.upBtn.enabled = YES;
    } else if (_model.like_status == 1) {
        self.upBtn.enabled = YES;
        [self.upBtn setImage:[UIImage imageNamed:@"2已点赞"] forState:UIControlStateNormal];
    }
    
    NSString *topTitle;
    NSString *bottomTitle;
    if ([_model.type integerValue] == 3) {
        /** 转发文章 */
        topTitle = [NSString stringWithFormat:@"分享文章 @%@",_model.forwarder];
        bottomTitle = _model.videoname;
        self.videoPlayImageView.hidden = YES;
    } else if ([_model.type integerValue] == 4) {
        /** 转发视频 */
        topTitle = [NSString stringWithFormat:@"分享视频 @%@",_model.forwarder];
        bottomTitle = _model.videoname;
        self.videoPlayImageView.hidden = NO;
    }
    self.topLabel.text = topTitle;
    self.bottomLabel.text = bottomTitle;
    [self.corverImg sd_setImageWithURL:[NSURL URLWithString:_model.cover]];
    
    CGSize size = [UIlabelTool sizeWithString:self.contentLab.text font:self.contentLab.font width:SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15];
    self.contentLab.frame = CGRectMake(MaxX(self.avatar) + 15, MaxY(self.avatar) + 5, SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15, size.height);
    
    CGFloat oneheight = (SCREEN_WIDTH - 105) / 3 - 10;
    self.lightGrayView.frame = CGRectMake(MaxX(self.avatar) + 15, MaxY(self.contentLab) + 10, SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15, oneheight + 18.6);
    self.topLabel.frame = CGRectMake(MaxX(self.corverImg) + 15, 15 , self.lightGrayView.width - MaxX(self.corverImg) - 30, 40);
    self.bottomLabel.frame = CGRectMake(MaxX(self.corverImg) + 15, MaxY(self.topLabel) + 5 , self.lightGrayView.width - MaxX(self.corverImg) - 30, 38);
    self.bottomView.frame = CGRectMake(0, MaxY(self.lightGrayView) + 10, SCREEN_WIDTH, 42);
    
    [self.eyeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_model.view_num] forState:UIControlStateNormal];
    [self.upBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_model.like_count] forState:UIControlStateNormal];
    [self.commitBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_model.comment_num] forState:UIControlStateNormal];
    
    [SingleManager shareManager].cellArtileOrVideoHeight = MaxY(self.bottomView) + 5;
}

// 添加所子控件
-(void)setUpAllView {
    // 头像
    if (!self.avatar) {
        self.avatar = [[UIImageView alloc] init];
        self.avatar.image = nil;
        [self.contentView addSubview:self.avatar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)];
        self.avatar.userInteractionEnabled = YES;
        [self.avatar addGestureRecognizer:tap];
    }
    
    // 昵称
    if (!self.nameLab) {
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        self.nameLab.textColor = kBlueColor;
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
    }
    
    // 时间
    if (!self.timeLab) {
        self.timeLab = [[UILabel alloc] init];
        self.timeLab.font = [UIFont systemFontOfSize:13];
        self.timeLab.textColor = kLightGrayColor;
        self.timeLab.numberOfLines = 1;
        self.timeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLab];
    }
    
    // 内容
    if (!self.contentLab) {
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.font = [UIFont systemFontOfSize:16];
        self.contentLab.textColor = kBlackColor;
        self.contentLab.numberOfLines = 0;
        self.contentLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentLab];
    }
    
    /** 转发文章和视频的布局 */
    if (!self.lightGrayView) {
        self.lightGrayView = [[UIView alloc] init];
        self.lightGrayView.backgroundColor = HEX_COLOR(0xF2F2F2);
        [self.contentView addSubview:self.lightGrayView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(articleOrVideoClick)];
        self.lightGrayView.userInteractionEnabled = YES;
        [self.lightGrayView addGestureRecognizer:tap];
    }
    
    if (!self.corverImg) {
        self.corverImg = [[UIImageView alloc] init];
        [self.lightGrayView addSubview:self.corverImg];
    }
    
    if (!self.topLabel) {
        self.topLabel = [[UILabel alloc] init];
        self.topLabel.font = [UIFont systemFontOfSize:15];
        self.topLabel.numberOfLines = 2;
        self.topLabel.textColor = HEX_COLOR(0x1296db);
        self.topLabel.textAlignment = NSTextAlignmentLeft;
        [self.lightGrayView addSubview:self.topLabel];
    }
    
    if (!self.bottomLabel) {
        self.bottomLabel = [[UILabel alloc] init];
        self.bottomLabel.font = [UIFont systemFontOfSize:14];
        self.bottomLabel.numberOfLines = 2;
        self.bottomLabel.textColor = [UIColor blackColor];
        self.bottomLabel.textAlignment = NSTextAlignmentLeft;
        [self.lightGrayView addSubview:self.bottomLabel];
    }
    
    if (!self.videoPlayImageView) {
        self.videoPlayImageView = [[UIImageView alloc] init];
        self.videoPlayImageView.image = [UIImage imageNamed:@"播放 (1)"];
        [self.corverImg addSubview:self.videoPlayImageView];
    }
    
    //下面的 浏览量 点赞 评论数
    if (!self.bottomView) {
        self.bottomView = [[UIView alloc] init];
        [self.contentView addSubview:self.bottomView];
    }
    
    if (!self.topLine) {
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = kLightGrayColor;
        [self.bottomView addSubview:self.topLine];
    }
    //浏览量
    if (!self.eyeBtn) {
        self.eyeBtn = [self creatBtnWithTitle:@"1" image:[UIImage imageNamed:@"阅读量"]];
    }
    
    //点赞
    if (!self.upBtn) {
        self.upBtn = [self creatBtnWithTitle:@"1" image:[UIImage imageNamed:@"1点赞"]];
    }
    
    //评论量
    if (!self.commitBtn) {
        self.commitBtn = [self creatBtnWithTitle:@"1" image:[UIImage imageNamed:@"评论、"]];
    }
    
    /** 设置frame */
    [self fh_layoutSubviews];
}

- (void)fh_layoutSubviews {
    self.avatar.frame = CGRectMake(15, 15, 40, 40);
    self.nameLab.frame = CGRectMake(MaxX(self.avatar) + 15, 0, SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 100, 20);
    self.nameLab.centerY = self.avatar.centerY;
    self.timeLab.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15, 20);
    self.timeLab.centerY = self.avatar.centerY;
    
    CGFloat oneheight = (SCREEN_WIDTH - 105) / 3 - 10;
    self.lightGrayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, oneheight + 18.6);
    self.corverImg.frame = CGRectMake(9.3, 9.3, oneheight, oneheight);
    self.videoPlayImageView.frame = CGRectMake(0, 0, 48, 48);
    self.videoPlayImageView.centerX = self.corverImg.frame.size.width / 2;
    self.videoPlayImageView.centerY = self.corverImg.frame.size.height / 2;
    self.videoPlayImageView.hidden = YES;
    self.topLabel.frame = CGRectMake(MaxX(self.corverImg) + 15, 15 , self.lightGrayView.width - MaxX(self.corverImg) - 30, 40);
    self.bottomLabel.frame = CGRectMake(MaxX(self.corverImg) + 15, MaxY(self.topLabel) + 5 , self.lightGrayView.width - MaxX(self.corverImg) - 30, 38);
    
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
    self.topLine.frame = CGRectMake(MaxX(self.avatar) + 15, 0, SCREEN_WIDTH - (MaxX(self.avatar) + 15), 0.25);
    CGFloat btnWidth = (kScreenWidth - MaxX(self.avatar) - 15 - 15 - 20 ) / 3;
    self.eyeBtn.frame = CGRectMake(MaxX(self.avatar) + 15, 11/2, btnWidth, 31);
    self.upBtn.frame = CGRectMake(MaxX(self.eyeBtn) + 10, 11/2, btnWidth, 31);
    self.commitBtn.frame = CGRectMake(MaxX(self.upBtn) + 10, 11/2, btnWidth, 31);
    
}

- (UIButton *)creatBtnWithTitle:(NSString *)title image:(UIImage *)imgage{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [btn setImage:imgage forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.enabled = NO;
    [self.bottomView addSubview:btn];
    return btn;
}

- (void)avatarClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(artileOrVideoShareAvaterClickWithModel:)]) {
        [_delegate artileOrVideoShareAvaterClickWithModel:self.model];
    }
}

- (void)upBtnClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(artileOrVideoShareLikeClickWithModel:)]) {
        [_delegate artileOrVideoShareLikeClickWithModel:self.model];
    }
}

- (void)articleOrVideoClick {
    if ([self.model.type integerValue] == 3) {
        /** 点击查看文章 */
        if (_delegate != nil && [_delegate respondsToSelector:@selector(artileOrVideoShareInfoDetailCLickWithModel:type:)]) {
            [_delegate artileOrVideoShareInfoDetailCLickWithModel:self.model type:3];
        }
    } else if ([self.model.type integerValue] == 4) {
        /** 查看视频 */
        if (_delegate != nil && [_delegate respondsToSelector:@selector(artileOrVideoShareInfoDetailCLickWithModel:type:)]) {
            [_delegate artileOrVideoShareInfoDetailCLickWithModel:self.model type:4];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
