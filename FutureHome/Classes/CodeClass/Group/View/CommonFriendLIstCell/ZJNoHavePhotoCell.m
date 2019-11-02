//
//  ZJHavePhotoCell.m
//  ZJKitTool
//
//  Created by 同熙传媒 on 2019/11/1.
//  Copyright © 2019 kapokcloud. All rights reserved.
//

#import "ZJNoHavePhotoCell.h"
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

@interface ZJNoHavePhotoCell()
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

/** 底部View */
@property (nonatomic, strong) UIView         *bottomView;
// 最上面的分割线
@property(nonatomic ,strong) UIView         *topLine;
/** 浏览次数 */
@property (nonatomic, strong) UIButton *eyeBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation ZJNoHavePhotoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}


-(void)setModel:(ZJCommit *)model{
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    self.nameLab.text = model.nickname;
    NSInteger time = [model.add_time integerValue];
    self.timeLab.text = [NSDate dateWithTimeInterval:time format:@"MM月dd日"];
    self.contentLab.text = model.content;
    
    CGSize size = [UIlabelTool sizeWithString:self.contentLab.text font:self.contentLab.font];
    [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_avatar.mas_bottom).offset(10);
        make.left.equalTo(self->_nameLab.mas_left);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(size.height);
    }];
}

// 添加所子控件
-(void)setUpAllView{
    // 头像
    self.avatar = [UIImageView zj_imageViewWithImage:@"" SuperView:self.contentView contentMode:UIViewContentModeScaleAspectFill isClip:YES constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];
    
    // 昵称
    self.nameLab = [UILabel zj_labelWithFontSize:15 textColor:kBlackColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_avatar.mas_centerY);
        make.left.equalTo(self->_avatar.mas_right).offset(15);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(20);
    }];
    
    // 时间
    self.timeLab = [UILabel zj_labelWithFontSize:12 textColor:kLightGrayColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_avatar.mas_centerY);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
        
    }];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    
    // 内容
    self.contentLab = [UILabel zj_labelWithFontSize:14 lines:0 text:nil textColor:kBlackColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_avatar.mas_bottom).offset(10);
        make.left.equalTo(self->_nameLab.mas_left);
        make.right.mas_equalTo(-15);
//        make.height.mas_lessThanOrEqualTo(16);
        make.height.mas_equalTo(0.001);
    }];
    
#warning 注意  不管你的布局是怎样的 ，一定要有一个(最好是最底部的控件)相对 contentView.bottom的约束，否则计算cell的高度的时候会不正确！
    self.bottomView = [UIView zj_viewWithBackColor:kGreenColor supView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_contentLab.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(-5); // 这句很重要！！！
    }];
    
    //最上面的的分割线
    self.topLine = [UIView zj_viewWithBackColor:kLightGrayColor supView:self.bottomView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self->_nameLab.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];

    self.eyeBtn = [self creatBtnWithTitle:@"11" image:[UIImage imageNamed:@"头像"]];
    [self.bottomView addSubview:self.eyeBtn];
    [_eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_nameLab.mas_left);
        make.centerY.mas_equalTo(self.bottomView.centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];

    self.commitBtn = [self creatBtnWithTitle:@"22" image:[UIImage imageNamed:@"头像"]];
    [self.bottomView addSubview:self.commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.bottomView.centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
}

- (UIButton *)creatBtnWithTitle:(NSString *)title image:(UIImage *)imgage{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [btn setImage:imgage forState:UIControlStateNormal];
    btn.enabled = NO;
    return btn;
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
