//
//  FHBlackListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  黑名单列表cell

#import "FHBlackListCell.h"

@interface FHBlackListCell ()
/** 线 */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation FHBlackListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.headerImg];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.bottomLineView];
//    [self.contentView addSubview:self.deleteBtn];
}


#pragma mark — setter && getter
- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    }
    return _headerImg;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_headerImg) + 10, 57 / 2, 100, 13)];
        _nameLabel.text = @"许大宝~";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 69.5, SCREEN_WIDTH - 30, 0.5)];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

//- (UIButton *)deleteBtn {
//    if (!_deleteBtn) {
//        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 32, 21, 22, 22);
//        _deleteBtn.backgroundColor = [UIColor redColor];
//    }
//    return _deleteBtn;
//}

@end
