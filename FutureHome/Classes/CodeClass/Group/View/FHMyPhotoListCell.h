//
//  FHMyPhotoListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/10/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FHPhotoModel;
@interface FHMyPhotoListCell : UITableViewCell

///** <#copy属性注释#> */

//@property (nonatomic, copy) NSArray *imgArrs;

@property(nonatomic ,strong) FHPhotoModel           *model;



@property(nonatomic ,weak) UIViewController      *weakSelf;

@end

NS_ASSUME_NONNULL_END
