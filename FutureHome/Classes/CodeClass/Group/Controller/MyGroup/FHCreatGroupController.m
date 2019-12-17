//
//  FHCreatGroupController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/12/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  创建群组界面

#import "FHCreatGroupController.h"
#import "AnalyzPermisViewController.h"
#import "FHFriendMessageController.h"

@interface FHCreatGroupController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDActionSheetDelegate>
/** 下一步按钮 */
@property (nonatomic,strong) UIButton    *nextBtn;
/**添加群头像按钮 */
@property (nonatomic,strong) UIButton    *addImagBtn;
/**群名称TF */
@property (nonatomic,strong) UITextField *groupNameTF;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImage *groupImg;

@end

@implementation FHCreatGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    //创建UI界面
    [self creatUI];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"创建群组";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    UILabel *groupLab = [[UILabel alloc]initWithFrame:CGRectMake(0, WCX_SCALE_SCREEN_Height(120), SCREEN_WIDTH, WCX_SCALE_SCREEN_Height(18))];
    groupLab.text = @"填写群名称";
    groupLab.textColor = COLOR_1;
    groupLab.font = [UIFont systemFontOfSize:WCX_SCALE_SCREEN_Height(17)];
    groupLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:groupLab];
    
    self.addImagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImagBtn setBackgroundImage:[UIImage imageNamed:@"news_group_head_portrait"] forState:UIControlStateNormal];
    [self.addImagBtn setBackgroundImage:[UIImage imageNamed:@"news_group_head_portrait"] forState:UIControlStateHighlighted];
    self.addImagBtn.frame = CGRectMake((SCREEN_WIDTH - WCX_SCALE_SCREEN_Width(132))/2, CGRectGetMaxY(groupLab.frame) + WCX_SCALE_SCREEN_Height(33), WCX_SCALE_SCREEN_Width(132), WCX_SCALE_SCREEN_Height(132));
    self.addImagBtn.layer.cornerRadius = 5;
    self.addImagBtn.layer.masksToBounds = YES;
    [self.addImagBtn addTarget:self action:@selector(addImagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addImagBtn];
    
    self.groupNameTF = [[UITextField alloc]initWithFrame:CGRectMake(WCX_SCALE_SCREEN_Width(60), CGRectGetMaxY(self.addImagBtn.frame) + WCX_SCALE_SCREEN_Height(41), WCX_SCALE_SCREEN_Width(258), WCX_SCALE_SCREEN_Height(31))];
    NSMutableParagraphStyle *style = [self.groupNameTF.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = self.groupNameTF.font.lineHeight - (self.groupNameTF.font.lineHeight - [UIFont systemFontOfSize:SCREEN_HEIGHT/667 *10].lineHeight) / 2.0;
    self.groupNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 填入群名称，不超过10个字符" attributes:@{NSForegroundColorAttributeName: COLOR_4,NSFontAttributeName : [UIFont systemFontOfSize:SCREEN_HEIGHT/667 *12],NSParagraphStyleAttributeName : style}];
    self.groupNameTF.textColor = COLOR_2;
    self.groupNameTF.delegate = self;
    self.groupNameTF.keyboardType=UIKeyboardTypeDefault;
    self.groupNameTF.font = [UIFont systemFontOfSize:WCX_SCALE_SCREEN_Height(12)];
    [self.view addSubview:self.groupNameTF];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(WCX_SCALE_SCREEN_Width(60), CGRectGetMaxY(self.groupNameTF.frame) + WCX_SCALE_SCREEN_Height(1), WCX_SCALE_SCREEN_Width(258), WCX_SCALE_SCREEN_Height(0.5))];
    lineView.backgroundColor = COLOR_24;
    [self.view addSubview:lineView];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.backgroundColor = [UIColor lightGrayColor];
    [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:WCX_SCALE_SCREEN_Height(18)];
    [self.nextBtn setTitleColor:COLOR_8 forState:UIControlStateNormal];
    self.nextBtn.frame = CGRectMake((SCREEN_WIDTH - WCX_SCALE_SCREEN_Width(310))/2, CGRectGetMaxY(lineView.frame) + WCX_SCALE_SCREEN_Height(44), WCX_SCALE_SCREEN_Width(310), WCX_SCALE_SCREEN_Height(44));
    self.nextBtn.layer.cornerRadius = WCX_SCALE_SCREEN_Height(22);
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.userInteractionEnabled = NO;
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (self.groupNameTF.isFirstResponder) {
        [self.groupNameTF resignFirstResponder];
    }
}

#pragma mark  -- 点击添加群头像
- (void)addImagBtnClick{
    /** 选取图片 */
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}

#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:
        {
            [self addCamera];
            break;
        }
        case 1:
        {
            [self addPhotoClick];
            break;
        }
        case 2:
        {
            ZHLog(@"取消");
            break;
        }
        default:
            
            break;
    }
}

//调用系统相机
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * cameraPicker = [[UIImagePickerController alloc]init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;  //是否可编辑
        //摄像头
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

/**
 *  跳转相册页面
 */
- (void)addPhotoClick {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - <相册处理区域>
/**
 *  拍摄完成后要执行的方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.groupImg = image;
    [self.addImagBtn setBackgroundImage:self.groupImg forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showHUDPostDetailsShowText:(NSString *)text showTime:(NSTimeInterval)showTime {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:showTime];
}


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (((((int)range.location>=0)&&(![string isEqualToString:@""])) || (((int)range.location>=1)&&[string isEqualToString:@""]))) {
        NSString * toBeString = [self.groupNameTF.text stringByReplacingCharactersInRange:range withString:string];
        if ([toBeString length] >=10) {
            self.groupNameTF.text = [toBeString substringToIndex:10];
            self.nextBtn.userInteractionEnabled = YES;
            self.nextBtn.backgroundColor = HEX_COLOR(0x1296db);
            return NO;
        }
        self.nextBtn.userInteractionEnabled = YES;
        self.nextBtn.backgroundColor = HEX_COLOR(0x1296db);
        return YES;
    }else{
        self.nextBtn.userInteractionEnabled = NO;
        self.nextBtn.backgroundColor = [UIColor lightGrayColor];
        return YES;
    }
    return YES;
}

/** 确定按钮点击事件 */
- (void)nextBtnClick {
    WS(weakSelf);
    [self.view makeToast:@"创建群聊中···"];
    self.nextBtn.userInteractionEnabled = NO;
    Account *account = [AccountStorage readAccount];
    NSString *personSelectString = [self.selectPersonArrs componentsJoinedByString:@","];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.groupNameTF.text,@"groupName",
                               personSelectString,@"number_str",
                               self.groupImg,@"avatar",
                               nil];
    NSData *imageData = UIImageJPEGRepresentation(self.groupImg,0.5);
    [AFNetWorkTool updateHeaderImageWithUrl:@"sheyun/createGroup" parameter:paramsDic imageData:imageData success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [self.view makeToast:@"创建群聊成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 跳转到对应的群聊 */
                FHFriendMessageController *conversationVC = [[FHFriendMessageController alloc] init];
                conversationVC.conversationType = ConversationType_GROUP;
                conversationVC.targetId = responseObj[@"data"][@"groupId"];
                conversationVC.titleString = responseObj[@"data"][@"groupName"];
                conversationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:conversationVC animated:YES];
            });
        } else {
            self.nextBtn.userInteractionEnabled = YES;
        }
    } failure:^(NSError *error) {
        self.nextBtn.userInteractionEnabled = YES;
    }];
}

@end
