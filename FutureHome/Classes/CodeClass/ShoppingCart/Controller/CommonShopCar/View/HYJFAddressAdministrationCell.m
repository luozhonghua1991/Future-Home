//
//  HYJFAddressAdministrationCell.m
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/22.
//  Copyright © 2017年 HYJF. All rights reserved.
//

#import "HYJFAddressAdministrationCell.h"
#import "UIColor+Extend.h"
@interface HYJFAddressAdministrationCell()
{
    UILabel  *nameLabel;//姓名
    UILabel  *phoneLabel;//手机号
    UILabel  *addressLabel;//详细地址
    UIView   *lineView;
    UIButton *editBtn;//编辑地址btn
    UIButton *deleteBtn;//删除地址btn
    UIView   *bottomView;
    UIButton *addressBtn;//默认地址btn
    UIView   *bottomLineView;

}
@end
@implementation HYJFAddressAdministrationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;

}
- (void)setUpUI{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ZH_SCALE_SCREEN_Width(12), ZH_SCALE_SCREEN_Height(15), ZH_SCALE_SCREEN_Width(150), ZH_SCALE_SCREEN_Height(15))];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font =[UIFont systemFontOfSize:15];
    nameLabel.text = @"XXXXXX";
    [self.contentView addSubview:nameLabel];

    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + ZH_SCALE_SCREEN_Width(12), ZH_SCALE_SCREEN_Height(15), ZH_SCALE_SCREEN_Width(200), ZH_SCALE_SCREEN_Height(13))];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.font =[UIFont systemFontOfSize:15];
    phoneLabel.text = @"13849132460";
    [self.contentView addSubview:phoneLabel];

    addressLabel = [[UILabel alloc]init];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font =[UIFont systemFontOfSize:12];
    addressLabel.text = @"重庆市沙坪坝大学城";
    [self.contentView addSubview:addressLabel];

    lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZH_COLOR(239, 239, 239);
    [self.contentView addSubview:lineView];

    bottomView =[[UIView alloc]init];
    [self.contentView addSubview:bottomView];

    addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(ZH_SCALE_SCREEN_Width(15), 0, ZH_SCALE_SCREEN_Width(150), ZH_SCALE_SCREEN_Height(40));
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [addressBtn addTarget:self action:@selector(changeDefultAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addressBtn];

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

    bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexStr:@"#EDECEC"];
//    [self.contentView addSubview:bottomLineView];
}
- (void)setAddressModel:(HYJFAllAddressModel *)addressModel{
    _addressModel = addressModel;
//    nameLabel.text = [NSString stringWithFormat:@"姓名: %@",addressModel.name];
//    phoneLabel.text = addressModel.phone;
//    addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressModel.province,addressModel.city,addressModel.district,addressModel.address];
    addressLabel.text = @"重庆市沙坪坝大学城";
    CGSize size = [UIlabelTool sizeWithString:addressLabel.text font:addressLabel.font];
    addressLabel.frame = CGRectMake(ZH_SCALE_SCREEN_Width(12), CGRectGetMaxY(phoneLabel.frame) + ZH_SCALE_SCREEN_Height(8), ZH_SCALE_SCREEN_Width(320), size.height);
    addressLabel.numberOfLines = 0;
    lineView.frame = CGRectMake(0, CGRectGetMaxY(addressLabel.frame) + ZH_SCALE_SCREEN_Height(10), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(1));

    if (addressModel.isDefault == 1) {
        //默认地址
        [addressBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [addressBtn setTitle:@"默认地址" forState:UIControlStateNormal];
        [addressBtn setTitleColor:ZH_COLOR(255, 182, 55) forState:UIControlStateNormal];
    } else {
        [addressBtn setImage:[UIImage imageNamed:@"unChecked"] forState:UIControlStateNormal];
        [addressBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(addressLabel.frame) + ZH_SCALE_SCREEN_Height(16), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(40));

//    bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(bottomView.frame) - 0.5, SCREEN_WIDTH, 1);
    addressModel.rowHight = CGRectGetMaxY(bottomView.frame);
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark  -- 改变默认地址
- (void)changeDefultAddressClick {
    
//    if (self.addressModel.isDefault == 1) {
//        return;
//    }
//
//    NSDictionary *params = @{@"isDefault":@(1)};
    __weak typeof(self) weakSelf = self;
//
//    NSString *urlStr = [NSString stringWithFormat:@"Address/%d?isDefault=1",self.addressModel.id];
//
//    [AFNetWorkTool put:urlStr params:nil success:^(id responseObj) {
//        int code = [[responseObj objectForKey:@"code"] intValue];
//        if (code == 0) {
//            [ZHProgressHUD showMessage:@"设置成功" inView:[UIApplication sharedApplication].keyWindow];
//
            if ([weakSelf.controller respondsToSelector:@selector(changeDefaultAddress)]) {
                [weakSelf.controller performSelector:@selector(changeDefaultAddress)];
            }
//        }else{
//            [ZHProgressHUD showMessage:[responseObj objectForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow];
//        }
//    } failure:^(NSError *error) {
//        //
//        NSLog(@"error === %@",error);
//    }];
}

#pragma mark  -- 编辑地址
- (void)editBtnClick {
    if ([self.controller respondsToSelector:@selector(editAddress:)]) {
        [self.controller performSelector:@selector(editAddress:) withObject:self.addressModel];
    }
}

#pragma mark  -- 删除地址
- (void)deleteBtnClick{
    __weak typeof(self) weakSelf = self;

    NSString *urlStr = [NSString stringWithFormat:@"Address/%d",self.addressModel.id];
    
    [AFNetWorkTool deleteRequest:urlStr params:nil success:^(id responseObj) {
        int code = [[responseObj objectForKey:@"code"] intValue];
        if (code == 0) {
            [ZHProgressHUD showMessage:@"删除成功" inView:[UIApplication sharedApplication].keyWindow];

            if ([weakSelf.controller respondsToSelector:@selector(changeDefaultAddress)]) {
                [weakSelf.controller performSelector:@selector(changeDefaultAddress)];
            }
        }else{
            [ZHProgressHUD showMessage:[responseObj objectForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(NSError *error) {
        //
    }];
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
