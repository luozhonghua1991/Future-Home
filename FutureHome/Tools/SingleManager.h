//
//  SingleManager.h
//  Huamu
//
//  Created by baimifan on 15/9/24.
//  Copyright © 2015年 lyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "GNRShoppingBar.h"
#import "PPNumberButton.h"

@interface SingleManager : NSObject
@property (nonatomic,copy) NSString *uid; /* 用户id*/
/**
 *  用户token
 */
@property(nonatomic,copy)  NSString *netToken;
@property (nonatomic,copy) NSString *name; /* 用户姓名*/
@property (nonatomic,copy) NSString *photo;/**< 用户头像url >*/
@property (nonatomic,copy) NSString *points;/**< 用户积分 >*/
/**
 *  视频的标题
 */
@property(nonatomic,strong)NSString *titleName;

@property (nonatomic,assign) BOOL soundNotice; /* 铃声提醒*/
@property (nonatomic,assign) BOOL sharkNotice; /* 震动提醒*/

@property (nonatomic,assign) BOOL isLine;
/** 是否有视频 */
@property (nonatomic,assign) BOOL isVideo;
/** 是否是断点续传状态 */
@property (nonatomic,assign) BOOL isResumableUpload;
/** 是否是手机网络 */
@property (nonatomic,assign) BOOL isIphone4G;
/** 聊天背景图 */
@property (nonatomic,copy) NSString  *chatBgURL;

/** 是否是表情键盘 */
@property (nonatomic,assign) BOOL isEmojyKeyBoard;
/** 是否是游戏开黑 */
@property (nonatomic,assign)BOOL isGameOpenBlack;
/** 是否是举报window */
@property (nonatomic,assign) BOOL isReportWindow;
//是否是游戏缩小状态
@property (nonatomic,assign) BOOL isGameSmall;

//开黑游戏时间
@property (nonatomic,copy) NSString *timeString;

@property(nonatomic)NSDateFormatter *dateFormatter;

/**是否是群成员编辑状态 */
@property (nonatomic,assign) BOOL isGroupListEditing;
/**邀请好友的第五个区的cell的高度*/
@property(nonatomic,assign) CGFloat inviteFriendRowHeight;
/**是否需要展示活动图 */
@property (nonatomic,assign) BOOL isShowActivityView;

/** 是否选择用户头像 */
@property (nonatomic, assign) BOOL isSelectPerson;

@property (nonatomic, strong)GNRShoppingBar * shoppingBar;
/** <#strong属性注释#> */
@property (nonatomic, strong) PPNumberButton *numberButton;
/** 是评论评论的状态 */
@property (nonatomic, assign) BOOL isCommentComment;

/** 是否是选择发布动态中的视频状态  如果选择了视频 就不能选择图片 */
@property (nonatomic, assign) BOOL isSelectVideo;
/** 是否是选择发布动态中的图片状态  如果选择了图片 就不能选择视频 */
@property (nonatomic, assign) BOOL isSelectPhoto;
/** 是否是动态状态的界面 */
@property (nonatomic, assign) BOOL isDongTaiType;
/**
 *  视频的path
 */
@property (nonatomic,copy)NSString   *videoPath;
/** 动态cell有图片的高度 */
@property (nonatomic, assign) CGFloat cellPicHeight;
/** 动态cell没有图片的高度 */
@property (nonatomic, assign) CGFloat cellNoPicHeight;
/** 动态cell有视频的高度 */
@property (nonatomic, assign) CGFloat cellVideoHeight;
/** 选择的类型 */
@property (nonatomic, copy) NSString *selectType;
/** 商店名字 */
@property (nonatomic, copy) NSString *shopName;
/** 商品数组 */
@property (nonatomic, strong) NSMutableArray *goodsArrs;
/** 总价 */
@property (nonatomic, copy) NSString *totalMoneyString;
/** 用户的所有好友信息数组 */
@property (nonatomic, strong) NSArray *allFriendsArrs;


/**
 *  返回时间str，当有一个str或时间戳或NSDate的时间格式时(三选一)，可以得到指订输出格式的时间字符串
 *
 *  @param inFormate   输入时间格式,可选
 *  @param outFormate  输出时间格式，可选
 *  @param date        输入时间为str，可选
 *  @param shijianchuo 输入时间为时间戳，可选
 *  @param dateTwo     输入时间为NSDate，可选
 *
 *  @return 时间str
 */
- (NSString *)changeDateStrToDateStrWithInDateFormate:(NSString *)inFormate withOutFormate:(NSString *)outFormate withDateStr:(NSString *)date withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)dateTwo;

/**
 *  得到      如果时间是今天，昨天，前天，就返回文字，否则，返回需要时间
 *
 *  @param inFormate   输入时间格式,可选
 *  @param outFormate  输出时间格式，可选
 *  @param date        输入时间为str，可选
 *  @param shijianchuo 输入时间为时间戳，可选
 *  @param dateTwo     输入时间为NSDate，可选
 *
 *  @return 时间信息
 */

- (NSString *)getDateStrWithInDateFormate:(NSString *)inFormate withOutFormate:(NSString *)outFormate withDateStr:(NSString *)date withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)dateTwo;

/**
 *  得到     1分钟前，2小时前，3天前，4月前
 *
 *  @param inFormate   时间输入格式
 *  @param outFormate  时间输出格式
 *  @param date        时间字符
 *  @param shijianchuo 时间戳
 *  @param dateTwo     时间dete
 *
 *  @return 需要时间
 */
- (NSString *)getBeforDateStrWithInDateInFormate:(NSString *)inFormate withOutFormate:(NSString *)outFormate withDateStr:(NSString *)dateStr withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)date;

- (NSString *)getSundayWithShiJianChuoStr:(NSString *)shijianchuo;

- (NSString *)getDateStrWithOutFormate:(NSString *)outFormate withDateStr:(NSString *)date withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)dateTwo;

- (NSString *)getDateStrWithOutFormate:(NSString *)outFormate withShiJianChuoStr:(NSString *)shijianchuo;

/**
 *  获取消息提醒
 *
 *  @return <#return value description#>
 */
//- (void)gotoNotice;
/**
 *  播放新消息提醒
 */
- (void)playSound;
/**
 *  播放声音
 */
- (void)systemSound;
/**
 *  震动
 */
- (void)systemShark;

+ (instancetype)shareManager;

-(void)xys_canGetAddressBook;


/**
 *  获取设备类型
 */
- (NSString*)xys_getDeviceString;
/**
 *  获取网络状态
 */
- (NSString *)xys_getNetWorkStates;
/**
 *  获取缓存大小
 */
- (float)getCaChe;
/**
 *  用户是否是登录状态
 */
- (BOOL)isLogin;
/**
 *  获取用户手机号
 */
- (NSString *)getPersonPhone;
/**
 *  用户是否开户
 */
- (BOOL)isOpenAccount;
/**
 *  用户是否投资过
 */
- (BOOL)isHasInvest;
/**
 判断手机号码格式是否正确
 @param mobile 用户的手机号（字符串）
 @return 结果
 */
- (BOOL)valiMobile:(NSString *)mobile;
//只能输入 英文字母和数字
- (BOOL)checkIsPassword:(NSString *)password;
//验证用户密码
- (BOOL)checkPassword:(NSString *)password;
//传入时间戳字符串 转成时间 formatterString 是你想要转出来的格式
- (NSString *)stringWithTimeIntervalString:(NSString *)TimeIntervalString
                           formatterString:(NSString *)formatterString;

//交易类型转义
- (NSString *)configTradeType:(NSString *)tradeType;

@end
