//
//  JSShareView.h
//  JSShareView
//
//  Created by 乔同新 on 16/6/7.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShareType) {
    ShareTypeSocial = 0, //社交分享
    ShareTypeSysterm     //系统
};

typedef void(^ShareResultBlock)(ShareType type,BOOL isSuccess);

@protocol JSShareViewDelegate <NSObject>
//点击举报按钮
-(void)JSShareViewDelegateClickReport;
@end
@interface JSShareView : UIView
/** 数组数据 */
@property (nonatomic,strong)NSArray *dataArray;
/** 上面类型数组 */
@property (nonatomic,strong)NSArray *typeArray1;
/** 下面类型数组 */
@property (nonatomic,strong)NSArray *typeArray2;
/** 传入内容 */
@property (nonatomic,strong)NSDictionary *publishContent;

@property (nonatomic,copy) ShareResultBlock ShareResultBlock;


@property (nonatomic,weak) id<JSShareViewDelegate> delegate;
/**
 *  分享
 *
 *  @param content     @{@"text":@"",@"image":@[],@"url":@""}
 *  @param resultBlock 结果
 *  @param DataArray 传入的数组
 */
+ (JSShareView *)showShareViewWithPublishContent:(NSDictionary *)content
                                       DataArray:(NSArray *)dataArray
                                      TypeArray1:(NSArray *)typeArray1
                                      TypeArray2:(NSArray *)typeArray2
                                    IsShowReport:(BOOL)isShowReport
                                    isLocalImage:(BOOL)isLocalImage
                                     addViewType:(NSString *)viewType
                                          Result:(ShareResultBlock)resultBlock;

- (void)dismissShareView;
@end
