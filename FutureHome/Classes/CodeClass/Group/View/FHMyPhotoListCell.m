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


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self fh_setUpUI];
//    }
//    return self;
//}
//
//- (void)fh_setUpUI {
//
//}
//
//- (void)setImgArrs:(NSArray *)imgArrs {
//    _imgArrs = imgArrs;
//    if (self.photoListView) {
//        [self.photoListView removeFromSuperview];
//        [self creatPhotosWithArray:_imgArrs];
//    } else {
//        [self creatPhotosWithArray:_imgArrs];
//    }
//
//}
//
//- (void)creatPhotosWithArray:(NSArray *)imgArrs {
//    self.photoListView = [[DPPhotoListView alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH - 80, self.photoListView.height) numberOfCellInRow:3 lineSpacing:15 dataSource:[imgArrs mutableCopy]];
//    CGFloat height = [self.photoListView getItemSizeHeight];
//    CGFloat photoListHeight = 0.0;
//    if (imgArrs.count == 0) {
//        photoListHeight = 0;
//    } else if (imgArrs.count <= 3) {
//        photoListHeight = height + 15;
//    } else if (imgArrs.count <=6 && imgArrs.count > 3) {
//        photoListHeight = 2 * height + 15 * 2;
//    } else if (imgArrs.count <=9 && imgArrs.count > 6) {
//        photoListHeight = 3 * height + 15 * 3;
//    }
//    self.photoListView.height = photoListHeight;
//    self.photoListView.showAddImagesButton = NO;
//    self.photoListView.allowLongPressEditPhoto = NO;
//    self.photoListView.delegate = self;
//    [self.contentView addSubview:self.photoListView];
//}
//
//- (void)fh_selectCellWithIndex:(NSIndexPath *)selectIndex {
//    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
//    browser.isFullWidthForLandScape = YES;
//    browser.isNeedLandscape = YES;
//    browser.currentImageIndex = (int)selectIndex.row;
//    browser.imageArray = self.imgArrs;
//    [browser show];
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//}
//

//
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

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
