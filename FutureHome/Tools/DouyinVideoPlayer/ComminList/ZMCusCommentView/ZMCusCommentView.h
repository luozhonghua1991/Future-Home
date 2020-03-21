//
//  ZMCusCommentView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMCusCommentListView.h"
#import "ZMCusCommentToolView.h"
#import "ZFTableData.h"

@interface ZMCusCommentView : UIView
/** 视频TopicID */
@property (nonatomic, copy) NSString *videoTopicId;
/** 文章id */
@property (nonatomic, copy) NSString *article_id;
/** 文章类型 */
@property (nonatomic, copy) NSString *article_type;
/** video视频 其他都是文章类型*/
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) ZMCusCommentListView *commentListView;

@property (nonatomic, strong) ZMCusCommentToolView *toolView;

- (void)showView;

@end

@interface ZMCusCommentManager : NSObject

+ (instancetype)shareManager;

- (void)showCommentWithSourceId:(NSString *)sourceId
                       dataArrs:(NSMutableArray *)commentListArrs
                      tableData:(ZFTableData *)data
                           tpye:(NSString *)commentType;

- (void)showCommentWithArticleid:(NSString *)articleid
                        dataArrs:(NSMutableArray *)commentListArrs
                     articleType:(NSString *)articleType
                            tpye:(NSString *)commentType;

@end
