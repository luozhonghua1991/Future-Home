//
//  FHEntryVerificationCodeController.h
//  RWGame
//
//  Created by luozhonghua on 2018/7/18.
//  Copyright © 2018年 chao.liu. All rights reserved.
//

typedef enum : NSUInteger {
    REGISTER_VC,            //新用户注册界面
    THIRDLOGIN_VC,          //第三方登陆界面()
    VERIFICATIONLOGIN_VC,   //验证码登陆界面(底部有密码登录)
    PASSWORD_VC,            //修改密码界面
    FORGETPASSWORD_VC,      //忘记密码界面
    BOUNDPHONE_VC,          //绑定手机号界面
} type;

#import "BaseViewController.h"



@interface FHEntryVerificationCodeController : UIViewController

@property (nonatomic, assign) type vcType;
/**区号*/
@property (nonatomic,copy) NSString *dialing_code;
/**手机号码*/
@property (nonatomic,copy) NSString *phoneNumber;
/** 验证码类型 */
@property (nonatomic, assign) NSInteger type;


@end
