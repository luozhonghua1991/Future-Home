//
//  FHMyPhotoListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHMyPhotoListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZJCommitPhotoView.h"
#import "FHPhotoModel.h"
//#import "DPPhotoLibrary.h"

@interface FHMyPhotoListCell()
/** <#strong属性注释#> */
//@property (nonatomic, strong) DPPhotoListView *photoListView;
///** 时间label */
@property (nonatomic, strong) UILabel *timeLabel;
// 图片
@property(nonatomic ,strong) ZJCommitPhotoView *photosView;

@end

@implementation FHMyPhotoListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}

- (void)setModel:(FHPhotoModel *)model {
    self.timeLabel.text = model.create_time;
    NSInteger count = model.pic_urls.count;
    
    _photosView.pic_urls = model.pic_urls;
    _photosView.selfVc = _weakSelf;
    // 有图片重新更新约束
    CGFloat oneheight = (kScreenWidth - 80 - 15 - 20) / 3;
    // 三目运算符 小于或等于3张 显示一行的高度 ,大于3张小于或等于6行，显示2行的高度 ，大于6行，显示3行的高度
    CGFloat photoHeight = count<=3 ? oneheight : (count<=6 ? 2 *oneheight + 10 : oneheight * 3+ 20);
    
    [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(- 15);
        make.height.mas_equalTo(photoHeight);
        make.bottom.mas_equalTo(-10);
    }];
}

// 添加所子控件
-(void)setUpAllView {
    
    self.timeLabel.frame = CGRectMake(10, 10, 80, 30);
    [self.contentView addSubview:self.timeLabel];
    // 图片
    #warning 注意  不管你的布局是怎样的 ，一定要有一个(最好是最底部的控件)相对 contentView.bottom的约束，否则计算cell的高度的时候会不正确！
    self.photosView = [[ZJCommitPhotoView alloc]init];
    
    [self.contentView addSubview:self.photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.001);
        make.bottom.mas_equalTo(-10);
    }];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.text = @"收藏于: 2019.08.03";
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
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
