//
//  FHNoPicPersonCommitsCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHNoPicPersonCommitsCell.h"
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

@interface FHNoPicPersonCommitsCell ()
// 昵称
@property(nonatomic ,strong) UILabel        *nameLab;
// 头像
@property(nonatomic ,strong) UIImageView    *avatar;
// 时间
@property(nonatomic ,strong) UILabel        *timeLab;
// 内容
@property(nonatomic ,strong) UILabel        *contentLab;
// 分割线
@property(nonatomic ,strong) UIView         *bottomView;

@end

@implementation FHNoPicPersonCommitsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}


-(void)setModel:(ZJCommit *)model {
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@""]];
    
    if ([SingleManager shareManager].isPersonCommits) {
        self.nameLab.text = [self tranlateStrWithString:_model.nickname];
    } else {
        self.nameLab.text = _model.nickname;
    }
    
    self.timeLab.text = _model.add_time;
    self.contentLab.text = _model.content;
    
    CGSize size = [UIlabelTool sizeWithString:self.contentLab.text font:self.contentLab.font width:SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15];
    self.contentLab.frame = CGRectMake(MaxX(self.avatar) + 15, MaxY(self.avatar) + 5, SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15, size.height);
    
    self.bottomView.frame = CGRectMake(0, MaxY(self.contentLab) + 10, SCREEN_WIDTH, 0.5);
    
    [SingleManager shareManager].cellNoPicHeight = MaxY(self.bottomView) + 5;
}

- (NSString *)tranlateStrWithString:(NSString *)str {
    
    NSMutableString * newStr = [NSMutableString stringWithString:str];
    for(int i = 0; i < str.length; i++){
        if (i > 0) {
            [newStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return newStr;
    
}

// 添加所子控件
-(void)setUpAllView {
    // 头像
    if (!self.avatar) {
        self.avatar = [[UIImageView alloc] init];
        self.avatar.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:self.avatar];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)];
//        self.avatar.userInteractionEnabled = YES;
//        [self.avatar addGestureRecognizer:tap];
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
    
    //下面的 浏览量 点赞 评论数
    if (!self.bottomView) {
        self.bottomView = [[UIView alloc] init];
        [self.contentView addSubview:self.bottomView];
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
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
}


@end
