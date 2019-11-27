//
//  FHNewWatiingOrderCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHNewWatiingOrderCell.h"
#import "FHGoodListCollectionCell.h"
#import "FHGoodsListModel.h"

@interface FHNewWatiingOrderCell () <UICollectionViewDelegate,UICollectionViewDataSource>
/** 白色背景图 */
@property (nonatomic, strong) UIView *whiteBgView;
/** 上面的标题label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 下单时间 */
@property (nonatomic, strong) UILabel *orderTimeLabel;
/** 配送类型 */
@property (nonatomic, strong) UILabel *orderTypeLabel;
/** 上面的线 */
@property (nonatomic, strong) UIView *topLineView;
/**
 *  物品列表collectionView
 */
@property (nonatomic,strong) UICollectionView *goodsListCollection;
/** 价格label */
@property (nonatomic, strong) UILabel *priceLabel;
/** 个数label */
@property (nonatomic, strong) UILabel *countLabel;
/** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;


@end

@implementation FHNewWatiingOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBACOLOR(203, 203, 203, 1);
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    [self.contentView addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.titleLabel];
    [self.whiteBgView addSubview:self.orderTimeLabel];
    [self.whiteBgView addSubview:self.orderTypeLabel];
    [self.whiteBgView addSubview:self.topLineView];
    [self.whiteBgView addSubview:self.goodsListCollection];
    [self.whiteBgView addSubview:self.priceLabel];
    [self.whiteBgView addSubview:self.countLabel];
    [self.whiteBgView addSubview:self.bottomLineView];
    [self.whiteBgView addSubview:self.typeBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.whiteBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH , 260);
    self.titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH , 50);
    self.orderTimeLabel.frame = CGRectMake(15, MaxY(self.titleLabel) + 17, SCREEN_WIDTH , 14);
    self.orderTypeLabel.frame = CGRectMake(0, MaxY(self.titleLabel) + 17, SCREEN_WIDTH - 15 , 14);
    self.topLineView.frame = CGRectMake(15, MaxY(self.orderTimeLabel) + 17, SCREEN_WIDTH - 15 , 0.5);
    self.goodsListCollection.frame = CGRectMake(15, MaxY(self.topLineView) + 20, 300, 60);
    self.priceLabel.frame = CGRectMake(0, MaxY(self.topLineView) + 30, SCREEN_WIDTH - 15 , 15);
    self.countLabel.frame = CGRectMake(0, MaxY(self.priceLabel) + 10, SCREEN_WIDTH - 15 , 15);
    self.bottomLineView.frame = CGRectMake(15, MaxY(self.topLineView) + 100, SCREEN_WIDTH - 15 , 0.5);
    self.typeBtn.frame = CGRectMake(SCREEN_WIDTH - 85, MaxY(self.bottomLineView) + 18, 70, 30);
}

- (void)setListModel:(FHGoodsListModel *)listModel {
    _listModel = listModel;
    self.titleLabel.text = [NSString stringWithFormat:@"   %@",_listModel.shopname];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间: %@",_listModel.add_time];
    self.priceLabel.text  = [NSString stringWithFormat:@"￥%@",_listModel.pay_money];
    self.countLabel.text = [NSString stringWithFormat:@"共%@件",_listModel.number];
}

- (void)setGoodsImgArrs:(NSArray *)goodsImgArrs {
    _goodsImgArrs = goodsImgArrs;
    [self.goodsListCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsImgArrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHGoodListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FHGoodListCollectionCell" forIndexPath:indexPath];
    if (!IS_NULL_ARRAY(self.goodsImgArrs)) {
        NSString *imageURLString = self.goodsImgArrs[indexPath.row];
        cell.imageUrlString = imageURLString;
    }
    return cell;
}


#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIView *)whiteBgView {
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"   台北城一期";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = RGBACOLOR(0, 174, 173, 1);
    }
    return _titleLabel;
}

- (UILabel *)orderTimeLabel {
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.font = [UIFont systemFontOfSize:14];
        _orderTimeLabel.text = @"下单时间: 2019-11-09 17:36:41";
        _orderTimeLabel.textColor = [UIColor lightGrayColor];
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderTimeLabel;
}

- (UILabel *)orderTypeLabel {
    if (!_orderTypeLabel) {
        _orderTypeLabel = [[UILabel alloc] init];
        _orderTypeLabel.font = [UIFont systemFontOfSize:14];
        _orderTypeLabel.text = @"配送时间: 快递到家";
        _orderTypeLabel.textColor = HEX_COLOR(0x1296db);
        _orderTypeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderTypeLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:15];
        _priceLabel.text = @"￥99999.00";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.text = @"共1件";
        _countLabel.textColor = [UIColor lightGrayColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UIButton *)typeBtn {
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeBtn setTitle:@"" forState:UIControlStateNormal];
        [_typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _typeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _typeBtn.backgroundColor = HEX_COLOR(0x1296db);
//        [_typeBtn addTarget:self action:@selector(<#metodName#>) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeBtn;
}

- (UICollectionView *)goodsListCollection {
    if (!_goodsListCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 60);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _goodsListCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _goodsListCollection.delegate = self;
        _goodsListCollection.dataSource = self;
        _goodsListCollection.scrollsToTop = NO;
        _goodsListCollection.backgroundColor = [UIColor clearColor];
        [_goodsListCollection registerClass:[FHGoodListCollectionCell class] forCellWithReuseIdentifier:@"FHGoodListCollectionCell"];
    }
    return _goodsListCollection;
}

@end
