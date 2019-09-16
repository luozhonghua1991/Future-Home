//
//  FHAnnouncementListCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/27.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHNoticeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FHAnnouncementListCell : UITableViewCell
/** 公告模型 */
@property (nonatomic, strong) FHNoticeListModel *noticeModel;

@end

NS_ASSUME_NONNULL_END
