//
//  FFDropDownMenuCell.m
//  FFDropDownMenuDemo
//
//  Created by mac on 16/7/31.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "FFDropDownMenuCell.h"

//model
#import "FFDropDownMenuModel.h"

//other
#import "FFDropDownMenu.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FFDropDownMenuCell ()

/** 图片 */
@property (weak, nonatomic) UIImageView *customImageView;

/** 标题 */
@property (weak, nonatomic) UILabel *customTitleLabel;

/** 底部分割线 */
@property (nonatomic, weak) UIView *separaterView;

/** 消息气泡 */
@property (nonatomic, retain) UILabel *bulle;

@end

@implementation FFDropDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //初始化子控件
        UIImageView *customImageView = [[UIImageView alloc] init];
        customImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:customImageView];
        self.customImageView = customImageView;
        
        UILabel *customTitleLabel = [[UILabel alloc] init];
        customTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        customTitleLabel.textColor = HEX_COLOR(0x333333);
        [self addSubview:customTitleLabel];
        self.customTitleLabel = customTitleLabel;
        
        //泡泡
        UILabel *bulle = [[UILabel alloc] init];
        bulle.layer.masksToBounds = YES;
        bulle.layer.cornerRadius = SCREEN_WIDTH/375*20*0.5;
        bulle.font = [UIFont systemFontOfSize:SCREEN_HEIGHT/667*12];
        bulle.textAlignment=NSTextAlignmentCenter;
        bulle.backgroundColor = [UIColor redColor];
//        bulle.textColor = COLOR_8;
        [self addSubview:bulle];
        self.bulle = bulle;
        
        
        UIView *separaterView = [[UIView alloc] init];
        separaterView.backgroundColor = HEX_COLOR(0xEBEBEB);
        [self addSubview:separaterView];
        self.separaterView = separaterView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    FFDropDownMenuModel *realMenuModel = (FFDropDownMenuModel *)self.menuModel;
    //frame的赋值
    CGFloat separaterHeight = 1; //底部分割线高度
    //图片 customImageView
    CGFloat imageViewMargin = SCREEN_HEIGHT/667*10;
    CGFloat imageViewH = self.frame.size.height - 2 * imageViewMargin;
    self.customImageView.frame = CGRectMake(SCREEN_WIDTH/375*22, imageViewMargin, imageViewH, imageViewH);
    
    //给imageView赋值
    if (realMenuModel.menuItemIconName.length) {
        //标题
        CGFloat labelX = CGRectGetMaxX(self.customImageView.frame) + 10;
        self.customTitleLabel.frame = CGRectMake(labelX, 0, self.frame.size.width - labelX, self.frame.size.height - separaterHeight);
    } else {
        //标题
        self.customTitleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - separaterHeight);
        self.customTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.bulle.frame = CGRectMake(SCREEN_WIDTH/375*115, SCREEN_HEIGHT/667*10,SCREEN_WIDTH/375*20,SCREEN_WIDTH/375*20);
    
    //分割线
    self.separaterView.frame = CGRectMake(0, self.frame.size.height - separaterHeight, self.frame.size.width, separaterHeight);
}


- (void)setMenuModel:(id)menuModel {
    _menuModel = menuModel;
    
    FFDropDownMenuModel *realMenuModel = (FFDropDownMenuModel *)menuModel;
    self.customTitleLabel.text = realMenuModel.menuItemTitle;
    
    //给imageView赋值
    if (realMenuModel.menuItemIconName.length) {
        self.customImageView.image = [UIImage imageNamed:realMenuModel.menuItemIconName];
        
    } else {
        FFLog(@"您传入的图片为空图片,框架内部默认不做任何处理。若您的确不想传入图片，则请忽略此处打印");
    }
    
    if (realMenuModel.menuItemMessageNum == 0) {
        self.bulle.hidden = YES;
        self.bulle.text = @"";
    }else{
        self.bulle.hidden = NO;
        self.bulle.text = [NSString stringWithFormat:@"%d",realMenuModel.menuItemMessageNum];
    }
    
}

@end
