//
//  FHMyAccountController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/12.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  账户信息

#import "FHMyAccountController.h"
#import "FHMyAccountCell.h"
#import "FHChangeNameController.h"
#import "FHAutographController.h"
#import "FHScanDetailAlertView.h"

@interface FHMyAccountController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDActionSheetDelegate>
/** table */
@property (nonatomic, strong) UITableView *homeTable;
/** 名字数组 */
@property (nonatomic, copy) NSArray *logoArrs;
/** <#strong属性注释#> */
@property (nonatomic, strong) UIImageView *headerImageView;
/** <#strong属性注释#> */
@property (nonatomic, strong) Account *account;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHScanDetailAlertView *codeDetailView;

@end

@implementation FHMyAccountController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHaveNavgationView = YES;
    [self fh_creatNav];
    [self.view addSubview:self.homeTable];
    [self.homeTable registerClass:[FHMyAccountCell class] forCellReuseIdentifier:NSStringFromClass([FHMyAccountCell class])];
    self.logoArrs = @[@"头像",@"昵称",@"未来家园号",@"未来家园号",@"个性签名"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.account = [AccountStorage readAccount];
    [self.homeTable reloadData];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"账户信息";
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


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logoArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHMyAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHMyAccountCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.logoLabel.text = [NSString stringWithFormat:@"%@",self.logoArrs[indexPath.row]];
    
    if (indexPath.row == 0||indexPath.row == 3) {
        cell.headerImg.hidden = NO;
        cell.headerImg.image = [UIImage imageNamed:@"black_erweima"];
        if (indexPath.row == 0) {
            self.headerImageView = cell.headerImg;
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.account.avatar]];
        }
        cell.rightArrowImg.hidden = YES;
        cell.contentLabel.hidden = YES;
    } else {
        cell.headerImg.hidden = YES;
        cell.rightArrowImg.hidden = YES;
        cell.contentLabel.hidden = NO;
        if (indexPath.row == 1) {
            cell.contentLabel.text = self.account.nickname;
        }
        if (indexPath.row == 4) {
            cell.contentLabel.text = self.account.autograph ? self.account.autograph : @"暂无个性签名";
        }
        if (indexPath.row == 2) {
            cell.contentLabel.text = self.account.username;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        /** 头像修改 */
        /** 选取图片 */
        FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
        [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
        [actionSheet addAnimation];
        [actionSheet show];
    } else if (indexPath.row == 1) {
        /** 修改昵称 */
        FHChangeNameController *change = [[FHChangeNameController alloc] init];
        change.strNikeName = self.account.nickname;
        [self.navigationController pushViewController:change animated:YES];
    } else if (indexPath.row == 4) {
        /** 修改个性签名 */
        FHAutographController *change = [[FHAutographController alloc] init];
        change.strAutograph = self.account.autograph;
        [self.navigationController pushViewController:change animated:YES];
    } else if (indexPath.row == 3) {
        self.codeDetailView.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
        [UIView animateWithDuration:0.3 animations:^{
            self.codeDetailView.alpha = 1;
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.codeDetailView];
    }
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
        cameraPicker.allowsEditing = NO;  //是否可编辑
        //摄像头
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

/**
 *  跳转相册页面
 */
- (void)addPhotoClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.naviBgColor = HEX_COLOR(0x1296db);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            self.headerImageView.image = image;
            Account *account = [AccountStorage readAccount];
            NSString *arr = @"111";
            NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @(account.user_id),@"user_id",
                                       arr,@"avatar",
                                       nil];
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            [AFNetWorkTool updateHeaderImageWithUrl:@"userCenter/updateAvatar" parameter:paramsDic imageData:imageData success:^(id responseObj) {
                if ([responseObj[@"code"] integerValue] == 1) {
                    NSString *url = responseObj[@"data"];
                    self.account.avatar = url;
                    [AccountStorage saveAccount:self.account];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - <相册处理区域>
/**
 *  拍摄完成后要执行的方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headerImageView.image = image;
    Account *account = [AccountStorage readAccount];
    NSString *arr = @"111";
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               arr,@"avatar",
                               nil];
    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    [AFNetWorkTool updateHeaderImageWithUrl:@"userCenter/updateAvatar" parameter:paramsDic imageData:imageData success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            NSString *url = responseObj[@"data"];
            self.account.avatar = url;
            [AccountStorage saveAccount:self.account];
        }
    } failure:^(NSError *error) {
        
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark — setter & getter
- (UITableView *)homeTable {
    if (_homeTable == nil) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.scrollEnabled = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

- (FHScanDetailAlertView *)codeDetailView {
    if (!_codeDetailView) {
        _codeDetailView = [[FHScanDetailAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"com.sheyun",@"app_key",
                                   @(self.account.user_id),@"id",
                                   self.account.nickname,@"name",
                                   self.account.username,@"username",
                                   @"0",@"type",
                                   nil];
//        NSDictionary *codeDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"com.sheyun",@"app_key",
//                                   @(self.account.user_id),@"id",
//                                   @"0",@"type",
//                                   nil];
        _codeDetailView.dataDetaildic = paramsDic;
        //_codeDetailView.scanCodeDic = codeDic;
    }
    return _codeDetailView;
}

@end
