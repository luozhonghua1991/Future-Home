//
//  HYJFAddressAdministrationCell.h
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/22.
//  Copyright © 2017年 HYJF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYJFAllAddressModel.h"
@interface HYJFAddressAdministrationCell : UITableViewCell
/**addressModel*/
@property (nonatomic,strong) HYJFAllAddressModel *addressModel;

@property (nonatomic, weak) UIViewController *controller;

@end
