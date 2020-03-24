//
//  FHCategoryCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/24.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHCategoryCell.h"

@implementation FHCategoryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = view;
        self.backgroundColor = HEX_COLOR(0xE8E8E8);
        [self setUpAllView];
    }
    return self;
}

- (void)setUpAllView {
    [self.contentView addSubview:self.nameLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark — setter && getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        //cell里自己定义label
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH * 0.26 - 6, 44)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
        //换行代码
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

@end
