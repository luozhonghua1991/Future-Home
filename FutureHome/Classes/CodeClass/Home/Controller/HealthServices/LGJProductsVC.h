//
//  LGJProductsVC.h
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ProductsDelegate <NSObject>

- (void)willDisplayHeaderView:(NSInteger)section;
- (void)didEndDisplayingHeaderView:(NSInteger)section;

@end

@interface LGJProductsVC : BaseViewController

@property(nonatomic, weak) id<ProductsDelegate> delegate;/**< delegate */

/** 多少个区 */
@property (nonatomic, assign) NSInteger sectionCount;

/**
 *  当CategoryTableView滚动时,ProductsTableView跟随滚动至指定section
 *
 *  @param section
 */
- (void)scrollToSelectedIndexPath:(NSIndexPath *)indexPath;

- (void)resreshDataWithPid:(NSString *)pid;

@end
