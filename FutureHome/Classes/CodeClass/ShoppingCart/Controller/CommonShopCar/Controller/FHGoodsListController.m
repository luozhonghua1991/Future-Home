//
//  FHGoodsListController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  商品列表VC

#import "FHGoodsListController.h"
#import "GNRLinkageTableView.h"
#import "GNRShoppingBar.h"
#import "UINavigationBar+Awesome.h"
#import "FHSureOrderController.h"
#import "FHGoodsDetailController.h"

@interface FHGoodsListController () <GNRGoodsNumberChangedDelegate,GNRLinkageTableViewDelegate,CAAnimationDelegate,GNRShoppingBarDelegate>
@property (nonatomic,strong) CALayer *dotLayer;//小圆点
@property (nonatomic,assign) CGFloat endPointX;
@property (nonatomic,assign) CGFloat endPointY;
@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic, strong)GNRLinkageTableView * goodsListView;
@property (nonatomic, strong)GNRShoppingBar * shoppingBar;
/** 如果是push到下一页就添加到上面 */
@property (nonatomic, assign) BOOL isPush;


@end

@implementation FHGoodsListController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.goodsListView];
    [self initData];
    [SingleManager shareManager].shoppingBar = self.shoppingBar;
    [self.view addSubview:[SingleManager shareManager].shoppingBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:[SingleManager shareManager].shoppingBar];
    /** 新过来的商家 重新展示 shoppingBar */
//    if ([SingleManager shareManager].shoppingBar) {
//        [self.shoppingBar removeFromSuperview];
//        [[SingleManager shareManager].shoppingBar removeFromSuperview];
//        [SingleManager shareManager].shoppingBar = self.shoppingBar;
//    }
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    self.navigationController.navigationBar.tintColor = HEX_COLOR(0x1296db);
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationController.navigationBar lt_reset];
//}

- (void)initData {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.shopID,@"shopid",
                               [SingleManager shareManager].ordertype,@"ordertype",
                               nil];
    
    [AFNetWorkTool get:@"shop/getVariety" params:paramsDic success:^(id responseObj) {
        
        NSArray *arr = [[NSArray alloc] init];
        arr = responseObj[@"data"];
        if (IS_NULL_ARRAY(arr)) {
            return ;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GNRGoodsGroup * goodsGroup = [GNRGoodsGroup new];
                goodsGroup.classesName = [obj objectForKey:@"name"];
                goodsGroup.classID = [obj objectForKey:@"id"];
                [weakSelf.goodsListView.goodsList.goodsGroups addObject:goodsGroup];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.goodsListView.leftTbView reloadData];
            });
        });
    } failure:^(NSError *error) {
        
    }];
    
    /** 购物车的数据 */
    [AFNetWorkTool get:@"shop/getAppledataByShopid" params:paramsDic success:^(id responseObj) {
        NSArray *arr = [[NSArray alloc] init];
        arr = responseObj[@"data"];
        if (IS_NULL_ARRAY(arr)) {
            return ;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GNRGoodsGroup * goodsGroup = [GNRGoodsGroup new];
                goodsGroup.classesName = [obj objectForKey:@"title"];
                NSArray * list = [obj objectForKey:@"list"];
                [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    GNRGoodsModel * goods = [GNRGoodsModel new];
                    goods.goodsName = [obj objectForKey:@"title"];
                    goods.goodsPrice = [NSString stringWithFormat:@"%.2f",[[obj objectForKey:@"sell_price"] floatValue]];
                    goods.goodsImage = [obj objectForKey:@"cover"];
                    goods.goodsPlace = [obj objectForKey:@"Place"];
                    goods.goodsUnitAtr = [obj objectForKey:@"UnitAtr"];
                    goods.goodsID = [obj objectForKey:@"id"];
                    goods.goodsSafetStock = [obj objectForKey:@"SafetStock"];
                    goods.Isrestrictions = [[obj objectForKey:@"Isrestrictions"] integerValue];
                    goods.limit_num = [[obj objectForKey:@"limit_num"] integerValue];
                    [goodsGroup.goodsList addObject:goods];
                }];
                /** 暂时注释了 具体不知道为啥 */
//                [weakSelf.goodsListView.goodsList.goodsGroups addObject:goodsGroup];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                /** 暂时注释掉 */
                //        [weakSelf.goodsListView reloadData];

                weakSelf.shoppingBar.goodsList = weakSelf.goodsListView.goodsList;
            });
        });
    } failure:^(NSError *error) {

    }];
}


//clean
- (void)cleanGoodsCartAction:(id)sender{
    [self.goodsListView.goodsList.shoppingCart clear];
    [self.shoppingBar.cartView dismiss];
    [self.shoppingBar refreshCartBar];
    [self.goodsListView.rightTbView reloadData];
}



#pragma mark - stepper delegate
- (void)stepper:(GNRCountStepper *)stepper
valueChangedForCount:(NSInteger)count
          goods:(GNRGoodsModel *)goods {
    if (stepper.style == GNRCountStepperStyleGoodsList) {
        //更新购物车中的商品
        [self.goodsListView.goodsList.shoppingCart.bags.firstObject updateGoods:goods];
        //更新badgeValue
        [self.shoppingBar reloadData];
    } else {//购物车中的
        if (count == 0) {
            [self.goodsListView.goodsList.shoppingCart.bags.firstObject updateGoods:goods];
        }
        [self.goodsListView.rightTbView reloadData];
        if (!self.goodsListView.goodsList.shoppingCart.goodsTotalNumber) {
            [self.shoppingBar.cartView dismiss];
            [self.shoppingBar refreshCartBar];
        }else{
            [self.shoppingBar reloadData];
        }
    }
}

- (void)stepper:(GNRCountStepper *)stepper
      addSender:(UIButton *)sender
           cell:(UITableViewCell *)cell{
    CGRect parentRect = [stepper convertRect:stepper.addBtn.frame toView:self.view];
    [self jumpToCartAnimationWithAddBtnRect:parentRect];
}


#pragma mark - 跳入购物车动画
-(void)jumpToCartAnimationWithAddBtnRect:(CGRect)rect {
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPointX, _endPointY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor blackColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 14, 14);
    _dotLayer.cornerRadius = 14/2.f;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
}


#pragma mark - 开始组合动画
-(void)groupAnimation{
    //路径
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    //alpha
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.35f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.6f];
}

//移除layer
- (void)removeFromLayer:(CALayer *)layerAnimation{
    [layerAnimation removeFromSuperlayer];
}


#pragma mark — GNRShoppingBarDelegate
/** 支付事件 */
- (void)GNRShoppingBarDelegatePayAction {
    FHSureOrderController *vc = [[FHSureOrderController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.shopID = self.shopID;
    /** 3 生鲜商城订单 4 社交商业订单 5 药品商城订单 */
    vc.type = self.type;
    vc.send_cost = self.send_cost;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CAAnimationDelegate
//组合动画结束后 购物车 缩放动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.1f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:1];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1.2];
        shakeAnimation.autoreverses = YES;
        [_shoppingBar.shoppingBarView.shoppingCartIcon.layer addAnimation:shakeAnimation forKey:nil];
    }
}

- (void)fh_selectIndexModel:(GNRGoodsModel *)goods
                       cell:(GNRGoodsListCell *)cell {
    /** 去商品详情界面 */
    FHGoodsDetailController *vc = [[FHGoodsDetailController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.currentNumber = [goods.number floatValue];
    vc.stepper = cell.stepper;
    vc.goodsModel = goods;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark — setter && getter
- (GNRLinkageTableView *)goodsListView{
    if (!_goodsListView) {
        _goodsListView = [[GNRLinkageTableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight + 44 + 35, self.view.bounds.size.width, self.view.bounds.size.height - [GNRShoppingBar defaultHeight] - MainSizeHeight - 44 - 35)] ;
        _goodsListView.target = self;
        _goodsListView.delegate = self;
        _goodsListView.shopID = self.shopID;
    }
    return _goodsListView;
}

- (GNRShoppingBar *)shoppingBar{
    if (!_shoppingBar) {
        _shoppingBar = [GNRShoppingBar barWithStyle:GNRShoppingBarStyleDefault showInView:self.view];
        _shoppingBar.cartView.target = self;
        _shoppingBar.delegate = self;
        
        [_shoppingBar.cartView.header.cleanBtn addTarget:self action:@selector(cleanGoodsCartAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect = [self.view convertRect:_shoppingBar.shoppingBarView.shoppingCartIcon.frame fromView:_shoppingBar.shoppingBarView];
        
        _endPointX = rect.origin.x + rect.size.width/2.0;
        _endPointY = rect.origin.y + rect.size.height/2.0;
    }
    return _shoppingBar;
}

@end
