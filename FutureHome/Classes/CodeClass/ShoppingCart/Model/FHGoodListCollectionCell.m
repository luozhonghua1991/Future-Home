//
//  FHGoodListCollectionCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHGoodListCollectionCell.h"

@interface FHGoodListCollectionCell ()
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *goodsImgView;

@end

@implementation FHGoodListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.goodsImgView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.goodsImgView.frame = self.contentView.bounds;
}

- (void)setImageUrlString:(NSString *)imageUrlString {
    _imageUrlString = imageUrlString;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrlString] placeholderImage:[UIImage imageNamed:@""]];
}

- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
    }
    return _goodsImgView;
}

@end
