//
//  ZJMasonryAutolayoutCell.m
//  ZJUIKit
//
//  Created by dzj on 2018/1/26.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//
/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下。😆
 */
#import "ZJMasonryAutolayoutCell.h"
#import "ZJCommit.h"
#import "ZJCommitPhotoView.h"
#import "ZJReplyCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#define ReplyCellKey @"ZJReplyCell"
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

@interface ZJMasonryAutolayoutCell()
// 昵称
@property(nonatomic ,strong) UILabel        *nameLab;
// 头像
@property(nonatomic ,strong) UIImageView    *avatar;
// 时间
@property(nonatomic ,strong) UILabel        *timeLab;
// 内容
@property(nonatomic ,strong) UILabel        *contentLab;
// 图片
@property(nonatomic ,strong) ZJCommitPhotoView *photosView;
/** 底部View */
@property (nonatomic, strong) UIView         *bottomView;
// 最上面的分割线
@property(nonatomic ,strong) UIView         *topLine;
// 最下面的分割线
@property(nonatomic ,strong) UIView         *line;
/** 浏览次数 */
@property (nonatomic, strong) UIButton *eyeBtn;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIButton *commitBtn;


// 评论列表
//@property (nonatomic, strong) UITableView  *commentTable;
@end

@implementation ZJMasonryAutolayoutCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}


-(void)setModel:(ZJCommit *)model {
    _model = model;
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];

    self.nameLab.text = _model.nickname;
    self.timeLab.text = _model.add_time;
    self.contentLab.text = _model.content;
    
    [self.eyeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_model.view_num] forState:UIControlStateNormal];
    [self.commitBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_model.comment_num] forState:UIControlStateNormal];
    
    NSInteger count = _model.pic_urls.count;

    if (count > 0 ) {
        _photosView.pic_urls = _model.pic_urls;
        _photosView.selfVc = _weakSelf;
        // 有图片重新更新约束
        CGFloat oneheight = (kScreenWidth - _nameLab.zj_originX - 15 -20 ) / 3;
        // 三目运算符 小于或等于3张 显示一行的高度 ,大于3张小于或等于6行，显示2行的高度 ，大于6行，显示3行的高度
        CGFloat photoHeight = count<=3 ? oneheight : (count<=6 ? 2*oneheight+10 : oneheight *3+20);

        [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_contentLab.mas_bottom).offset(10);
            make.left.equalTo(self->_nameLab.mas_left);
            make.right.mas_equalTo(- 15);
            make.height.mas_equalTo(photoHeight);
            make.bottom.mas_equalTo(- 45);
        }];
        
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.bottom.mas_equalTo(0); // 这句很重要！！！
        }];
        _photosView.hidden = NO;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } else {
        [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_contentLab.mas_bottom).offset(10);
            make.left.equalTo(self->_nameLab.mas_left);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.001);
        }];
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_photosView.mas_bottom).offset(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
            make.bottom.mas_equalTo(0); // 这句很重要！！！
        }];
        
        _photosView.hidden = YES;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)avatarClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_ZJMasonryAutolayoutCellDelegateWithModel:)]) {
        [_delegate fh_ZJMasonryAutolayoutCellDelegateWithModel:self.model];
    }
}

// 添加所子控件
-(void)setUpAllView {
    // 头像
    self.avatar = [UIImageView zj_imageViewWithImage:[UIImage imageNamed:@"头像"] SuperView:self.contentView contentMode:UIViewContentModeScaleAspectFill isClip:YES constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)];
    self.avatar.userInteractionEnabled = YES;
    [self.avatar addGestureRecognizer:tap];
    
    // 昵称
    self.nameLab = [UILabel zj_labelWithFontSize:15 textColor:kBlueColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_avatar.mas_centerY);
        make.left.mas_equalTo(self->_avatar.mas_right).offset(15);
        make.right.mas_equalTo(- 100);
        make.height.mas_equalTo(20);
    }];
    
    // 时间
    self.timeLab = [UILabel zj_labelWithFontSize:12 textColor:kLightGrayColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_avatar.mas_centerY);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
        
    }];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    
    // 内容
    self.contentLab = [UILabel zj_labelWithFontSize:14 lines:0 text:nil textColor:kBlackColor superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_avatar.mas_bottom).offset(10);
        make.left.mas_equalTo(self->_nameLab.mas_left);
        make.right.mas_equalTo(-15);
        make.height.mas_lessThanOrEqualTo(16);
    }];
    
    // 图片
    self.photosView = [[ZJCommitPhotoView alloc]init];
    [self.contentView addSubview:self.photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_contentLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self->_nameLab.mas_left);
        make.right.mas_equalTo(- 15);
        make.height.mas_equalTo(0.001);
    }];
    
#warning 注意  不管你的布局是怎样的 ，一定要有一个(最好是最底部的控件)相对 contentView.bottom的约束，否则计算cell的高度的时候会不正确！
    self.bottomView = [UIView zj_viewWithBackColor:kWhiteColor supView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_photosView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(0); // 这句很重要！！！
    }];
    
    //最上面的d分割线
    self.topLine = [UIView zj_viewWithBackColor:kLightGrayColor supView:self.bottomView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self->_nameLab.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    //最下面的d分割线
    self.line = [UIView zj_viewWithBackColor:kLightGrayColor supView:self.bottomView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34.5);
        make.left.mas_equalTo(0);
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
