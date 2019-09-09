//
//  Account.h
//  Reading
//
//  Created by liuchao on 16/7/27.
//  Copyright © 2016年 liuchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
{
    @public
    NSString *_phone;
}
/** id */
@property (nonatomic, assign) NSInteger user_id;
/** 账号 */
@property (nonatomic, copy) NSString *username;
/** 密码 */
@property (nonatomic, copy) NSString *password;
/** 用户头像 */
@property (nonatomic, copy) NSString *avatar;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 昵称 */
@property (nonatomic, copy) NSString *nickname;
/** token */
@property (nonatomic, copy) NSString *token;
/** 手机号 */
@property (nonatomic, copy) NSString *mobile;


///** Analyst: 分析师 NormalUser: 普通用户 */
//@property (nonatomic, copy) NSString *type;
///** 分析师 - 余额;用户 - 浮豆 */
//@property (nonatomic, copy) NSString *account;
///** 手机号 */
//@property (nonatomic, copy) NSString *phone;
///** 1 已绑定手机，0 没绑定手机 */
//@property (nonatomic, copy) NSString *has_phone;
///** 1 为密码登录，0为验证码登录 */
//@property (nonatomic, copy) NSString *has_password;
///** 可交易金币数量  我的账户的数据*/
//@property (nonatomic, strong) NSNumber *coin;
///** 竞猜金币数量 */
//@property (nonatomic, strong) NSNumber *show_coins;
///** 冻结金币 */
//@property (nonatomic, strong) NSNumber *frozen_coins;
///** 道具数 */
//@property (nonatomic, strong) NSNumber *props;
///** 履行次数 */
//@property (nonatomic, strong) NSNumber *c2c_done_count;
///** 违约次数 */
//@property (nonatomic, strong) NSNumber *c2c_break_count;
///** 取消次数 */
//@property (nonatomic, strong) NSNumber *c2c_cancel_count;
///** 待付款 */
//@property (nonatomic, strong) NSNumber *c2c_wait_pay;
///** 待收款 */
//@property (nonatomic, strong) NSNumber *c2c_wait_receive;
///** 支付宝 */
//@property (nonatomic, copy) NSString *zfb;
///** 支付宝名 */
//@property (nonatomic, copy) NSString *zfb_name;
///** 未读消息 */
//@property (nonatomic, strong) NSNumber *unread_msg;
///** 正在进行交易的饰品数 */
//@property (nonatomic, strong) NSNumber *ongoing_decorations;
///** 当天剩余可查看免费推荐 */
//@property (nonatomic, assign) NSInteger today_free_browse_limit;
///** 券 */
//@property (nonatomic, strong) NSDictionary *pockets;
///** 会员券 */
//@property (nonatomic, assign) NSUInteger memberCouponCount;
///** 折扣券 */
//@property (nonatomic, assign) NSUInteger recCouponCount;
///** 全部券 */
//@property (nonatomic, assign) NSUInteger totalCouponCount;
///**红包个数*/
//@property (nonatomic,assign) NSInteger redPacketCount;
///**用户通过QQ还是微信登录的状态判断*/
//@property (nonatomic,copy) NSString      *omniauth_provider;
///**代理状态 agent是代理  applying代理申请中 nil非代理*/
//@property (nonatomic,copy) NSString      *agent_status;
///**如果是fause不显示代理中心*/
//@property (nonatomic,assign) BOOL inviter_agent;
//
///**收入*/
//@property (nonatomic,assign) float income;
//
///**当前红包金额数*/
//@property (nonatomic,assign) float current_packet_amount;
//
///**钻石数量*/
//@property (nonatomic,assign) float diamond;
///**冻结钻石*/
//@property (nonatomic,assign) float frozen_diamond;
//
////新增的参数
///**账户限额*/
//@property (nonatomic,assign) float limit_coin;
///**可交易余额*/
//@property (nonatomic,assign) float tradable_coin;
///**我的竞猜数量*/
//@property (nonatomic,assign) int   opening_bet_orders_count;
//
///**
// *  普通用户区
// */
///** 邀请码 */
//@property (nonatomic, copy) NSString *invite_code;
///** 用户现在是否是有效的全局会员 */
//@property (nonatomic, strong) NSNumber *vip_member;
///** 购买的分析师数量 */
//@property (nonatomic, copy) NSString *analyst_member_count;
///** 过期时间:1970-01-01 */
//@property (nonatomic, copy) NSString *expire_date;
///** 是否是vip会员 */
//@property (nonatomic, assign, getter=isVipMember) BOOL vipMember;
///** 是否是分析师会员 */
//@property (nonatomic, assign, getter=isVipAnalyst) BOOL vipAnalyst;
//
///**
// *  分析师账户区分角色用
// *  "dota2","csgo"，"lol"
// */
//
//@property (nonatomic, strong) NSArray *roles;
///** NormalUser:普通用户; JuniorAnalyst:初级分析师;IntermediateAnalyst:中级分析师;SeniorAnalyst:高级分析师; */
//@property (nonatomic, copy) NSString *real_type;
///** 分析师信息 */
//@property (nonatomic, strong) AnalystsExt *ext;
///**
// *  "1 == dota2",
// *  "2 == csgo"
// *  "3 == lol"
// */
//@property (nonatomic, strong) NSNumber *accoutGameID;

@end




