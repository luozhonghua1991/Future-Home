//
//  ZMCusCommentListContentCell.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHCommentListModel.h"
@interface ZMCusCommentListContentCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHCommentListModel *commentListModel;

- (void)configData:(id)data;

@end
