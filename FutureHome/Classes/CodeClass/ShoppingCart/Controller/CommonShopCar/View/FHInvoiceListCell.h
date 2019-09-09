//
//  FHInvoiceListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FHInvoiceListCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional // 可选实现的方法
- (void)fh_invoiceListCellSelect;

@end

@interface FHInvoiceListCell : UITableViewCell

@property(nonatomic, weak) id<FHInvoiceListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
