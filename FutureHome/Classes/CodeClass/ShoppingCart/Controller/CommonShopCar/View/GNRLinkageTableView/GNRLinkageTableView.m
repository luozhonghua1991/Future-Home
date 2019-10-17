//
//  GNRLinkageTableView.m
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import "GNRLinkageTableView.h"
#import "GNRShopHeader.h"
#import "GNRSectionHeader.h"
#import "GNRGoodsIndexCell.h"

@interface GNRLinkageTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL relate;
    BOOL topCanChange;//是否可以渐变
    CGFloat NavBarHeight;
    CGFloat headerHeight;
    CGFloat ChangedHeight;
    
    CGFloat leftWidth;
    CGFloat rightWidth;
    CGRect BOUNDS;
}
@property (nonatomic, strong)GNRShopHeader * header;

/** 商品合集 */
@property (nonatomic, strong) NSMutableArray *goodsListArrs;

@end

@implementation GNRLinkageTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self installTableView];
    }
    return self;
}

- (GNRShopHeader *)header{
    if (!_header) {
        _header = [GNRShopHeader header];
//        [self addSubview:_header];
    }
    return _header;
}

- (void)initData{
    relate = YES;
//    NavBarHeight = 64.f;
//    headerHeight = 152.f;
//    ChangedHeight = headerHeight - NavBarHeight;
    NavBarHeight = 0;
    headerHeight = 0;
    ChangedHeight = 0;
    _goodsList = [GNRGoodsListModel new];
    BOUNDS = self.bounds;
    leftWidth = 90;
    rightWidth = BOUNDS.size.width - leftWidth;
    
}

- (void)reloadData {
    topCanChange = NO;
    [_leftTbView reloadData];
    [_rightTbView reloadData];
    [self resetFrame];
}

- (void)resetFrame {
    if (_rightTbView.contentSize.height-_rightTbView.bounds.size.height>=ChangedHeight) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height+ChangedHeight);
        _rightTbView.frame = CGRectMake(leftWidth, headerHeight, rightWidth, BOUNDS.size.height-headerHeight+ChangedHeight);
    } else{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        _rightTbView.frame = CGRectMake(leftWidth, headerHeight, rightWidth, BOUNDS.size.height-headerHeight);
    }
    _leftTbView.frame = CGRectMake(0, headerHeight, leftWidth, BOUNDS.size.height-headerHeight);
//    self.header.frame = CGRectMake(0, 0, BOUNDS.size.width, headerHeight);
}

- (void)installTableView {
//haeder
//    self.header.frame = CGRectMake(0, 0, BOUNDS.size.width, headerHeight);
    
    _leftTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerHeight, leftWidth, BOUNDS.size.height - headerHeight+ChangedHeight) style:UITableViewStylePlain];
    _leftTbView.delegate = self;
    _leftTbView.dataSource = self;
    _leftTbView.showsVerticalScrollIndicator = NO;
    _leftTbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTbView.tableFooterView = [[UIView alloc] init];
    
    
    _rightTbView = [[UITableView alloc]initWithFrame:CGRectMake(leftWidth, headerHeight, rightWidth, BOUNDS.size.height-headerHeight+ChangedHeight) style:UITableViewStylePlain];
    _rightTbView.delegate = self;
    _rightTbView.dataSource = self;
    _rightTbView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_leftTbView];
    [self addSubview:_rightTbView];
    
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_leftTbView) {
        return 1;
    }
//    return self.goodsList.sectionNumber;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTbView) {
        return self.goodsList.sectionNumber;
    }
    
    if (section < self.goodsList.goodsGroups.count) {
//        GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[section];
//        return [goodsGroup.goodsList count];
        return self.goodsListArrs.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTbView) {
        GNRGoodsIndexCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GNRGoodsIndexCell"];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GNRGoodsIndexCell" owner:self options:nil] firstObject];
        }
        if (indexPath.row == 0) {
            GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[0];
            [self getRequestWithClassID:goodsGroup.classID];
            
            NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [_leftTbView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        if (indexPath.row<self.goodsList.goodsGroups.count) {
            GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[indexPath.row];
            cell.goodsGroup = goodsGroup;
        }
        return cell;
    }
    
    /** 右边的物品列表 */
    GNRGoodsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GNRGoodsListCell"];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GNRGoodsListCell" owner:self options:nil] firstObject];
    }
//    if (indexPath.section < self.goodsList.goodsGroups.count) {
//        GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[indexPath.section];
//        if (indexPath.row < goodsGroup.goodsList.count) {
//            GNRGoodsModel * goods = goodsGroup.goodsList[indexPath.row];
//            cell.goods = goods;
//            cell.delegate = _target;
//        }
//    }
    
        if (indexPath.section < self.goodsList.goodsGroups.count) {
            GNRGoodsModel * goods = self.goodsListArrs[indexPath.row];
            cell.goods = goods;
            cell.delegate = _target;
//            GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[indexPath.section];
//            if (indexPath.row < goodsGroup.goodsList.count) {
//                GNRGoodsModel * goods = goodsGroup.goodsList[indexPath.row];
//                cell.goods = goods;
//                cell.delegate = _target;
//            }
        }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_leftTbView) {
        return 52.5f;
    }
    return 105.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _rightTbView) {
        return 0.01;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _leftTbView) {
        return 0;
    }
    return CGFLOAT_MIN;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    if (relate) {
//        NSInteger firstCellSection = [[[tableView indexPathsForVisibleRows] firstObject]section];
//        if (tableView == _rightTbView) {//坐标index滚动到中间
//            [_leftTbView selectRowAtIndexPath:[NSIndexPath indexPathForItem:firstCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
//    if (relate) {
//        NSInteger firstCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
//        if (tableView == _rightTbView) {
//            [_leftTbView selectRowAtIndexPath:[NSIndexPath indexPathForItem:firstCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        }
//    }
//}

- (void)getRequestWithClassID:(NSString *)classID {
    WS(weakSelf);
    self.goodsListArrs  = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shop_id",
                               classID,@"variety", nil];
    
    [AFNetWorkTool get:@"shop/getShopsByVariety" params:paramsDic success:^(id responseObj) {
        NSArray *list = responseObj[@"data"];
        
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GNRGoodsModel * goods = [GNRGoodsModel new];
            goods.goodsName = [obj objectForKey:@"title"];
            goods.goodsPrice = [obj objectForKey:@"sell_price"];
            goods.goodsImage = [obj objectForKey:@"cover"];
            goods.goodsPlace = [obj objectForKey:@"Place"];
            goods.goodsUnitAtr = [obj objectForKey:@"UnitAtr"];
            goods.goodsID = [obj objectForKey:@"id"];
            goods.goodsSafetStock = [obj objectForKey:@"SafetStock"];
            //                [goodsGroup.goodsList addObject:goods];
            [weakSelf.goodsListArrs addObject:goods];
            
        }];
        
        //            [weakSelf.goodsList.goodsGroups addObject:goodsGroup];
        [weakSelf.rightTbView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_leftTbView) {
//        relate = NO;
//        [_leftTbView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];//左边滚动到中间
//        [_rightTbView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];//右边相应section滚动到顶部
        GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[indexPath.row];
        [self getRequestWithClassID:goodsGroup.classID];
    } else {
        
        //        if (indexPath.section < self.goodsList.goodsGroups.count) {
        //            GNRGoodsGroup * goodsGroup = self.goodsList.goodsGroups[indexPath.section];
        //            if (indexPath.row < goodsGroup.goodsList.count) {
        //                GNRGoodsModel * goods = goodsGroup.goodsList[indexPath.row];
        //                GNRGoodsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //                if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_selectIndexModel:cell:)]) {
        //                    [_delegate fh_selectIndexModel:goods cell:cell];
        //                }
        //            }
        
        GNRGoodsModel * goods = self.goodsListArrs[indexPath.row];
        GNRGoodsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_selectIndexModel:cell:)]) {
            [_delegate fh_selectIndexModel:goods cell:cell];
        }
    }
}

#pragma mark -
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    relate = YES;
}

@end
