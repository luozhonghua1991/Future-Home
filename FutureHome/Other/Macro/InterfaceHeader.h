//
//  InterfaceHeader.h
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/11.
//  Copyright © 2017年 HYJF. All rights reserved.
//  网络接口相关的宏定义 API KEY相关的

#ifndef InterfaceHeader_h
#define InterfaceHeader_h
/**  域名 链接 **/

//测试环境
//链接前缀
//#define BASE_URL @"http://testm.hongyajinrong.com/allApi"
//#define BASE_DD_URL @"https://m.hongyajinrong.com"

#define BASE_URL @"http://192.168.3.57/v1"

//#define BASE_URL @"http://192.168.10.36:8081"         //测试宏亚 大鸟
//#define PROTOCOL_URL @"http://192.168.10.36"          //协议总地址

//#define BASE_URL @"http://192.168.10.49:8088"         //测试宏亚 飞机
//#define PROTOCOL_URL @"http://192.10.49"          //协议总地址

//#define BASE_URL @"http://192.168.10.76:8080"        //测试宏亚 海丰
//#define PROTOCOL_URL @"http://192.168.10.76.218"          //协议总地址

//#define BASE_URL @"http://192.168.10.47:8888"         //内网测试服务器
//#define PROTOCOL_URL @"http://118.178.246.218"          //协议总地址   //公司内部测试专用

//#define BASE_URL @"http://218.75.74.58:8888"         // 外网测试服务器
//#define PROTOCOL_URL @"http://218.75.74.58"          //协议总地址

// 正式
//#define BASE_URL @"https://m.hongyajinrong.com" // 正式
//#define PROTOCOL_URL @"https://www.hongyajinrong.com" // 连接h5使用    //线上版本


#define Website_URL @"https://www.hongyajinrong.com"  // 官网


/********************************* .do的接口 ********************************/
/****************** 邀友返利/相关接口 *****************/
#define INVITE_PEOPLE_GETGIFT_API     @"/activity/getActivityRewardsSumAndFriendSum.dos"//邀友返利首页接口
#define INVITE_HISSTORICAL_RECORD_OLDAPI @"/activity/getMyInvitation.dos"   //邀请的历史记录接口 (老版本接口)
#define INVITE_HISSTORICAL_RECORD_NEWAPI @"/activity/getMyNewInvitation.dos"   //邀请的历史记录接口(新版接口)
#define INVITE_REWARD_HISTORY_API @"/activity/getNewActivityFriendStatisticsDetails.dos"//新的新规则奖励记录
#define GOOD_FRIENDS_INFO_LIST_API @"/activity/getSourceReward.dos"//新的好友信息列表数据
#define GETGIFT_HISSTORICAL_RECORD_API @"/activity/getActivityFriendStatisticsDetails.dos"//获取奖励历史记录的接口
/****************** 地址管理/相关接口 *****************/
#define ADDRESS_GET_ALLADDRESS_API   @"/member/getDrMenberAddress.dos"//获取用户所有地址
#define ADDRESS_ADD_API             @"/member/insertDrMenberAddress.dos"//添加用户地址
#define ADDRESS_UPDATE_API          @"/member/updateDrMenberAddress.dos"//更新用户地址
#define ADDRESS_DELETE_API           @"/member/de#defineeDrMenberAddress.dos"//删除用户地址
/****************** 注册登录/相关接口 *****************/
#define LOGIN_API                  @"/login/doLogin.dos"//用户登录 接口
#define VERIFY_PHONE_EXISIT_API    @"/register/existMobilePhone.dos" //验证手机号是否存在
#define GAIN_VERIFY_CODE_API       @"/register/sendAppRegMsg.dos"  //注册验证码短信 type: 1验证码 2 语音验证码
#define REGISTER_API               @"/register/reg.dos"  //注册
#define FIND_PASSWORD_API          @"/memberSetting/forgetPwdSmsCode.dos" //重置（忘记）登录密码 -> 发送短信验证码
#define UPDATE_LOGIN_PASSWORD_API  @"/memberSetting/updateLoginPassWord.dos" //设置登录密码
#define FORGET_PWD_VERIFY_CODE_API @"/memberSetting/sendForgetTpwdCode.dos"  //重置交易密码->发送短信验证码
#define PIC_CODE_API               @"/login/validateCode.dos"       //获取图形验证码
/******************     首页    相关接口    *****************/
#define Home_Api @"/index/index.dos"                          //首页
#define NewHead_Api @"/index/isNewHead.dos"                  //接口文档没有  （此API没有用到）
#define Renewal_Api @"/renewal.dos"       //app更新，版本控制的
#define NewHeadExpire_API @"/index/isNewHeadExpire.dos"  //用户首投b
#define UrgentNotice_Api @"/index/urgentNotice.dos"  //系统紧急公告 首页->获取列表->系统紧急公告
//平台公告
#define System_UrgentNotice_Api  @"/system/urgentNotice.dos"

/******************     我要投资    相关接口    *****************/
#define Investment_Api     @"/product/list.dos"   //产品列表
#define OpenGoldEgg_Api    @"/activity/getRandomCouponByProductId.dos"  //砸金蛋  随机加息券


#define ProductDetails_Api @"/product/detail.dos"//产品详情接口
#define DetailsList_Api    @"/product/detail_info.dos"//产品的详细资料   产品投资记录/图片/审核项目
#define Usable_Api         @"/activity/usable.dos"//获取可用红包
#define ProductInvest_Api  @"/product/invest.dos"//产品投资接口
#define Apponintment_Api   @"/product/getReservation.dos"//开始预约
#define JSInvestDetailCoupon_Api @"/activity/getUsableCoupon.dos" //投资获取可用优惠券
#define JSInvetProductActivity_APi @"/product/activityPrizeBanner.dos"    //产品列表banner

/****************** 我的信息相关接口    *****************/
#define MyAccount_Api     @"/accountIndex/info.dos"//我的帐户接口
#define MyInformation_Api @"/memberSetting/index.dos"//我的信息接口 -> 首页
#define MyBankCard_Api    @"/memberSetting/myBankInfo.dos"//我的银行卡接口
#define MyMessage_Api     @"/messageCenter/getMessage.dos"//我的站内信接口  （我的消息->获取信息列表）
#define MemberSet_Api     @"/memberSetting/sendBankMsg.dos"//银行验证码 （信息认证 -> 发送验证码）
#define MemberSetBank_Api @"/memberSetting/bankInfoVerify.dos"      //银行四要素和添加银行卡
#define GetBankQuotaList_Api @"/recharge/getBankQuotaList.dos"      // 银行限额列表
#define MyAssets_Api      @"/accountIndex/myFunds.dos"//我的资产接口
#define MyAccumulatedIncome_Api @"/assetRecord/getAccumulatedIncome.dos" //累计收益接口
#define JYPassWord_Api    @"/memberSetting/updateTpwdBySms.dos"//重置交易密码接口   （接口文档：设置交易密码）
#define MyActivity_Api    @"/activity/index.dos"//我的红包接口
#define MyAssetRecord_Api @"/assetRecord/index.dos"//我的明细接口
#define MyInvitation_Api  @"/activity/myRecommend.dos"//我的邀请接口

#define MyBackToRecord_Api @"/investCenter/repayInfoDetail.dos" //我的投资 - 投资回款记录
#define MyAccountGetMoney_Api @"/assetRecord/getTheRewards.dos" //我的账户 - 马上领取
#define GetActivityFriendAll_Api @"/activity/getActivityFriendConfigAll.dos"  //我的账户-》赚钱任务
#define GetActivityAll_Api @"/activity/getAllActivity.dos"        //我的账户-》活动中心

#define GetMoneyDidSelected_Api @"/inviteFriend"   //赚钱任务 - 》 cell点击
#define OpenEggShare_Api @"/newcomer?wap=true&toFrom=zjdfxfx"  //砸金蛋 -》 分享

#define GetPromoteRedCoupon_Api @"/member/getPromoteRedelivery.dos"  //点击红包和我要取现
#define GetUse_Api @"/member/getUse.dos"                //立即变现
#define ExperienceDetail @"/product/experienceDetail.dos" //体验标详情
#define ExperienceInvest @"/product/experienceInvest.dos"  //投资体验标

#define Recharge_getCityList @"/recharge/getCityList.dos"  //获取城市列表

/******************     我的投资    相关接口    *****************/
#define MyInvest_Api @"/investCenter/productList.dos" //我的投资接口 -> 投资记录
#define GetAddress_Api @"/member/getReceiptAddress.dos" //获取收货地址、联系电话、姓名
#define SaveAddress_Api @"/member/insertReceiptAddress.dos" //上传收获地址、联系电话、姓名

#define InvestAppoinment_Api @"/activity/insertPrizeInfo.dos" //添加预约
#define SelectProduct_Prize @  "/activity/selectProductPrize.dos" //查询产品绑定的奖品奖品

#define MyInvest_GiftDetail_Api @"/investCenter/prizeInfo.dos"    //投即送 奖品详情
#define MyInvest_PrizeDetail_Api @"/product/getMyLuckCodesAndStatus.dos"    //IPhone7 奖品详情
#define JSGiveTelephoneFare_Api  @""                               //APP2.0，投即送中充话费功能

/******************     充值提现    相关接口    *****************/
#define Recharge_Api      @"/recharge/index.dos"//充值首页接口
#define RechargeMsg_Api   @"/recharge/sendRechargeMsg.dos"//充值短信接口 (旧版)
#define RechargeGo_Api    @"/recharge/goJYTPay.dos"//充值接口 （旧版）
#define Withdrawals_Api   @"/withdrawals/index.dos"//提现首页接口
#define WithdrawalsGo_Api @"/withdrawals/addWithdrawals.dos"//提现接口
#define CreatePayOrder_Api @"/recharge/createPayOrder.dos"   //创建订单
#define SendRechargeSms_Api @"/recharge/sendRechargeSms.dos"    //发送验证码
#define GoPay @"/recharge/goPay.dos"        //认证充值

/******************     更多    相关接口    *****************/
#define Feedback_Api @"/system/feedback.dos" //意见反馈接口


/******************     协议  相关接口    *****************/
#define NewhandDetail_Api  @"/XSXQ"     //新手标详情
#define MoreSecurity_Api   @"/aqbz"     //更多安全保障
#define NormalBiaoSecurity_Api  @"/aqbzDetail"   //标的安全保障


#define RegisterProtocol_Api   @"/zc"   //注册协议
#define LoanProtocol_Api       @"/loan"     //借款协议

#define ActivityDetail_Api     @"/iPhone"         //iPhone活动标详情 -> web详情
#define AuthenticationInformation_Api @"/pay"
/**********************     版本获取     *******************/
//版本获取
#define GetVersion_Api      @"/system/version.dos"

/**********************     广告启动页面     *******************/
#define StartAdvertisement_Api @"/index/startAdvertisement.dos"

/**********************     活动标接口     *******************/

//#define GetMyLuckCodes @"/product/getMyLuckCodes.dos"   //活动页  我的幸运码
//#define GetNewActivityProduct @"/product/getNewActivityProduct.dos" //产品详情

#define  PrizePerson_Api   @"/activity/getPrizeInfoByProductId.dos"    //查询中奖者
#define  GetPrizeRecords_Api   @"/activity/getMyPrizeRecords.dos"      //活动中心 - 中奖记录
#define  LuckyMoney_Api   @"/activity/luckyMoneyIndex.dos"                 //压岁钱主界面
#define  GetLuckyMoney_Api   @"/activity/getLuckyMoney.dos"                //领取压岁钱

/*****************  写死的接口     *********************/
#define  JSBanner_Api @"888/app/getIndexBanner.dos"

/*******************   (接口文档有)  ***********************/
//4.8.2 权益转让及受让协议
#define AgreeMent_Api @"/agreement/product.dos"
// 4.9.2 消息标记为已读
#define UpdateUnReadMsg_Api @"/messageCenter/updateUnReadMsg.dos"
// 4.9.3 删除消息
#define DelMsg_Api @"/messageCenter/delMsg.dos"

// 4.13.1 自动投标个人设置
#define AutoInvest_Conf_Api  @"/autoInvest/autoInvestConf.dos"
// 4.13.2  修改自动投标设置
#define AutoInvest_UpdateConf_Api @"/autoInvest/updateAutoInvestConf.dos"

//好友信息邀请
#define Invited_api @"/activity/myInvitation.dos"
//新闻动态
#define PublicNotice_api @"/aboutus/newsInformationList.dos"

/******************* 新手标续投接口  ***********************/
//领取现金金额接口
#define GetContinueReward_Api @"/product/getContinueReward.dos"
//续投接口
#define AddContinueReward_Api @"/product/addContinueReward.dos"
//投即送
#define GetOpenRedCoupon_Api @"/member/getOpenRed.dos"
/*********************** 双旦活动 tabbar ***********************/
#define IsInDoubleEggActivity_APi @"/activity/isInDoubleEggActivity.dos"

//************************ 开放日 接口 **************************//
#define ActList @"/actList"
#define Openday_Url @"/openday"                                 //开放日活动详情
#define Enroll_Api           @"/activity/SignUp.dos"            //在线预约接口
#define EnrollGetPicture_Api @"/activity/getOpenDayDetail.dos"   //在线预约获取图片接口

//************************ 三重好礼活动接口 **************************//
#define InviteFriendTri_Api @ "/inviteFriendTri"

//**************** 新版我的邀请 ****************//
#define JSNewInvited_Api @"/activity/firstInvestList.dos"

// 1.2.4新加接口
#define LastLogin_Api @"/login/lastLogin.dos"     //最后登录时间更新

/*********************** 系统维护 ***********************/
#define XTWH_Api @"/template/pages/maintenance.html"
#define Set_Push_RegistrationId @"/app/setPushRegistrationId.dos"    //app推送,设置对象 //正式服使用

//#define Set_Push_RegistrationId @"/setPushRegistrationId.dos"    //app推送,设置对象 //测试服使用
////体验金使用规则
#define ExperienceRule @"/GGXQ?artiId=2"

/********************* 翻翻乐 *************************/
#define FlopShare_Api @"/activity/flopShare.dos"

//银行卡限额接口
#define BankLimitAmount_Api @"/CP080"

/*********************** 关于我们 ***********************/
//走进宏亚
#define GSJS @"/GSJS"
//股东介绍
#define GDJS @"/GDJS"
//管理团队
#define GLTD @"/GLTD"
//公司资质
#define GSZZ @"/GSZZ"
//一亿验资
#define YYYZ @"/YYYZ"
//网站公告,需要加上afid
#define GGXQ @"/GGXQ"
//一亿验资
#define YanZi_Api @"/YYYZ"
//公司概况//媒体报道
#define CompanySituation_Api @"/GYWM"
//媒体报道详情
#define Report @"/GGXQ"

/********************** H5 活动 **************************/  //下周才发
#define OfflineActivity_Api @"/activity/offlineActivityList.dos"

/*********************** 富友支付充值下单 ***********************/
#define fuRecharge_Api @"/recharge/wapRechge.dos"

// 募集列表
#define MOjiProductList_Api     @"/product/productList.dos"   //获取已募集 已还款列表
#define Product_RaisedAndRepayedNum_Api     @"/product/raisedAndRepayedNum.dos"   //获取已募集 已还款列表

// 正式版
#define QQ_KEY @"1106247480"
#define WX_KEY @"wxdfb50227ab9dd582"
#define UMENG_KEY @"593f482d734be423ea001237"
#define JPushKey @"494bee2f75215505d55d1357"
#define REG_FROM @"appstore"
#define APP_URL @"https://itunes.apple.com/us/app/%E5%AE%8F%E4%BA%9A%E9%87%91%E8%9E%8D/id1253856422?mt=8"
#endif /* InterfaceHeader_h */
