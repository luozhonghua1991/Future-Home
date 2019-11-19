//
//  FHInvoiceListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHInvoiceListCell.h"
#import "UIColor+Extend.h"
#import "FHInvoiceModel.h"

@interface FHInvoiceListCell ()
{
    UILabel  *nameLabel;//姓名
    UILabel  *addressLabel;//详细地址
    UIView   *lineView;
    UIButton *editBtn;//编辑地址btn
    UIButton *deleteBtn;//删除地址btn
    UIView   *bottomView;
}

@end


@implementation FHInvoiceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZH_SCALE_SCREEN_Width(12), ZH_SCALE_SCREEN_Height(15), ZH_SCALE_SCREEN_Width(150), ZH_SCALE_SCREEN_Height(15))];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font =[UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    
    addressLabel = [[UILabel alloc]init];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font =[UIFont systemFontOfSize:12];
    [self.contentView addSubview:addressLabel];
    
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZH_COLOR(239, 239, 239);
    [self.contentView addSubview:lineView];
    
    bottomView =[[UIView alloc]init];
    [self.contentView addSubview:bottomView];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(ZH_SCALE_SCREEN_Width(245), 0, ZH_SCALE_SCREEN_Width(65), ZH_SCALE_SCREEN_Height(40));
    [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editBtn];
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(ZH_SCALE_SCREEN_Width(310), 0, ZH_SCALE_SCREEN_Width(65), ZH_SCALE_SCREEN_Height(40));
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteBtn];
}


/** 编辑按钮 */
- (void)editBtnClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_invoiceListCellSelectModel:)]) {
        [_delegate fh_invoiceListCellSelectModel:self.invoiceModel];
    }
}

/** 删除按钮 */
- (void)deleteBtnClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_deleteInvoiceListCellSelectModel:)]) {
        [_delegate fh_deleteInvoiceListCellSelectModel:self.invoiceModel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [UIlabelTool sizeWithString:addressLabel.text font:addressLabel.font];
    addressLabel.frame = CGRectMake(ZH_SCALE_SCREEN_Width(12), CGRectGetMaxY(nameLabel.frame) + ZH_SCALE_SCREEN_Height(8), ZH_SCALE_SCREEN_Width(320), size.height);
    addressLabel.numberOfLines = 0;
    lineView.frame = CGRectMake(0, CGRectGetMaxY(addressLabel.frame) + ZH_SCALE_SCREEN_Height(10), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(1));
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(addressLabel.frame) + ZH_SCALE_SCREEN_Height(16), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(40));
}

- (void)setInvoiceModel:(FHInvoiceModel *)invoiceModel {
    _invoiceModel = invoiceModel;
    addressLabel.text = _invoiceModel.companyaddress;
    nameLabel.text = _invoiceModel.companyname;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
