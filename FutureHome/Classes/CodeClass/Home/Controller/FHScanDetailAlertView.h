//
//  FHScanDetailAlertView.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/18.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FHScanDetailAlertView : UIView
/** 数据字典 */
@property (nonatomic, strong) NSDictionary *dataDetaildic;
/** 二维码字典 */
@property (nonatomic, strong) NSDictionary *scanCodeDic;
/**白色背景View*/
@property (nonatomic,strong) UIView      *whiteBgView;
/** 二维码View */
@property (nonatomic, strong) UIImageView *codeImgView;
/**关闭按钮*/
@property (nonatomic,strong) UIButton    *closeBtn;
/**上边label*/
@property (nonatomic,strong) UILabel     *titleLabel;
/**上边label*/
@property (nonatomic,strong) UILabel     *topLabel;

@end

NS_ASSUME_NONNULL_END
