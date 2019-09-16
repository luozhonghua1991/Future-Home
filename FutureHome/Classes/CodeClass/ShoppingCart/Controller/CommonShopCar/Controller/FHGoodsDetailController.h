//
//  FHGoodsDetailController.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/9.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "BaseViewController.h"
#import "GNRCountStepper.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHGoodsDetailController : BaseViewController

@property (nonatomic, assign ) CGFloat currentNumber;

@property (strong, nonatomic)GNRCountStepper * stepper;

@end

NS_ASSUME_NONNULL_END
