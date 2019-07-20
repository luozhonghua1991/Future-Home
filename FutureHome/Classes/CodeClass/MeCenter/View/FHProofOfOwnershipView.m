//
//  FHProofOfOwnershipView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  权属证明View

#import "FHProofOfOwnershipView.h"
#import "NSMutableAttributedString+XZCategory.h"

@interface FHProofOfOwnershipView ()
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FHProofOfOwnershipView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self addSubview:self.titleLabel];
}


#pragma mark — setter && getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, SCREEN_WIDTH - 20, 35)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 2;
        NSString *titleString = @"建筑物业权属证明(能够证明建筑物业的合同房产证等⽂文件拍照上传)";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:9 legth:23]];
        _titleLabel.attributedText = attributedTitle;
    }
    return _titleLabel;
}

@end
