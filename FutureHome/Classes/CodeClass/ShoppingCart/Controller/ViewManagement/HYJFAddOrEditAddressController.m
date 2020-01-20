//
//  HYJFAddOrEditAddressController.m
//  宏亚金融OC版
//
//  Created by HYJF on 2017/12/22.
//  Copyright © 2017年 HYJF. All rights reserved.
//  编辑或者增加地址

#import "HYJFAddOrEditAddressController.h"
#import "AddressPickerView.h"
#import "FHAddressPickerView.h"

@interface HYJFAddOrEditAddressController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,AddressPickerViewDelegate>
{
    AddressPickerView *addressPicker;//地址选择
    UILabel *addressLabel;//省市区地址显示的label
    UIButton *conserveBtn;//保存按钮
    UITextField *recipientsTF;//收件人TF
    UITextField *phoneNumberTF;//手机号TF
    UITextView *detailAddressTextView;//详细地址的textView

    NSInteger isDefault;//是否是默认的地址
    NSString *strProvince;//省的字段
    NSString *strCity;//市的字段
    NSString *strArea;//区的字段

    int Id;//数据库保存的默认地址的Id值

}
/**tbale*/
@property (nonatomic,strong) UITableView *editAddTableView;
@property (nonatomic, strong) FHAddressPickerView *addressPickerView;
@end

@implementation HYJFAddOrEditAddressController


//懒加载
- (UITableView *)editAddTableView{
    if (_editAddTableView == nil) {
        _editAddTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight) style:UITableViewStylePlain];
        _editAddTableView.dataSource = self;
        _editAddTableView.delegate = self;
        _editAddTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _editAddTableView.showsVerticalScrollIndicator = NO;
        _editAddTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _editAddTableView.backgroundColor = [UIColor clearColor];

        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        _editAddTableView.tableFooterView = view;
        _editAddTableView.tableHeaderView = view;
    }
    return _editAddTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexStr:@"#EDECEC"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self fh_creatNav];
    [self creatTopView];
    [self creatBottomBtn];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleName;
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

#pragma mark  -- 创建上面的视图
- (void)creatTopView{
    [self.view addSubview:self.editAddTableView];
}

//保存按钮
- (void)creatBottomBtn{
    if (conserveBtn == nil) {
        conserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        conserveBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
        conserveBtn.backgroundColor = HEX_COLOR(0x1296db);
        [conserveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [conserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [conserveBtn addTarget:self action:@selector(conserveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:conserveBtn];
    }
}
#pragma mark  -- 保存地址
- (void)conserveBtnClick {
    //首先判断手机号格式是否正确
    if ([self.titleName isEqualToString:@"添加地址"]) {
        //添加地址保存
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   recipientsTF.text,@"username",
                                   phoneNumberTF.text,@"phone",
                                   strProvince,@"province_id",
                                   strCity,@"city_id",
                                   strArea,@"area_id",
                                   detailAddressTextView.text,@"address",
                                   @"0",@"id",
                                   [SingleManager shareManager].ordertype,@"ordertype",
                                   nil];
        //POST请求 新增用户地址信息
        __weak typeof(self)weakSelf = self;
        [AFNetWorkTool post:@"shop/addOrUpdateddress" params:paramsDic success:^(id responseObj) {
            ZHLog(@"新增用户地址信息%@",responseObj);
            int code = [[responseObj objectForKey:@"code"] intValue];
            if (code == 1) {
                //请求数据成功
                [ZHProgressHUD showMessage:@"添加成功" inView:weakSelf.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [ZHProgressHUD showMessage:[responseObj objectForKey:@"msg"] inView:weakSelf.view];
            }
        } failure:^(NSError * error) {
            [ZHProgressHUD showMessage:@"添加出错" inView:weakSelf.view];
            NSLog(@"%@",error.description);
        }];
    } else if ([self.titleName isEqualToString:@"编辑地址"]) {
        /** 编辑地址 */
        Account *account = [AccountStorage readAccount];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   recipientsTF.text,@"username",
                                   phoneNumberTF.text,@"phone",
                                   strProvince,@"province_id",
                                   strCity,@"city_id",
                                   strArea,@"area_id",
                                   detailAddressTextView.text,@"address",
                                   @(self.addressID),@"id",
                                   [SingleManager shareManager].ordertype,@"ordertype",
                                   nil];
        
        __weak typeof(self)weakSelf = self;
        [AFNetWorkTool post:@"shop/addOrUpdateddress" params:paramsDic success:^(id responseObj) {
            int code = [[responseObj objectForKey:@"code"] intValue];
            if (code == 1) {
                //请求数据成功
                [ZHProgressHUD showMessage:@"编辑成功" inView:[UIApplication sharedApplication].keyWindow];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else{
                [ZHProgressHUD showMessage:[responseObj objectForKey:@"msg"] inView:weakSelf.view];
            }
        } failure:^(NSError * error) {
            [ZHProgressHUD showMessage:@"编辑地址出错" inView:weakSelf.view];
            NSLog(@"%@",error.description);
        }];
    }

}

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

//返回每个区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//每行cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake((12), 0, (80), 44)];
        leftLab.textColor = [UIColor lightGrayColor];
        leftLab.font =[UIFont systemFontOfSize:16];
        [cell.contentView addSubview:leftLab];
        if (indexPath.section == 0) {
            leftLab.text = @"收件人:";
            //收件人TF
            recipientsTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.strName)) {
                recipientsTF.text = self.strName;
            }
            recipientsTF.placeholder = @"          请输入收货人的姓名";
            recipientsTF.textAlignment = NSTextAlignmentRight;
            recipientsTF.delegate = self;
            recipientsTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:recipientsTF];
        } else if (indexPath.section == 1){
            leftLab.text = @"手机号码:";
            //手机号码TF
            phoneNumberTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.strPhoneNum)) {
                phoneNumberTF.text = self.strPhoneNum;
            }
            phoneNumberTF.placeholder = @"           请输入正确的手机号码";
            phoneNumberTF.textAlignment = NSTextAlignmentRight;
            phoneNumberTF.delegate = self;
            phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
            phoneNumberTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:phoneNumberTF];

        } else if (indexPath.section == 2){
            leftLab.text = @"省市区:";
            //省市区addressLabel
            addressLabel  = [[UILabel alloc]init];
            addressLabel.frame = CGRectMake(105, 0,263,44);
            if (IsStringEmpty(self.strAddress)) {
                addressLabel.textColor = [UIColor blackColor];
                addressLabel.text = @"           请选择地址 >";
            } else {
                addressLabel.text = self.strAddress;
            }
            strProvince = self.province;
            strCity = self.city;
            strArea = self.district;
            addressLabel.font = [UIFont systemFontOfSize:15];
            addressLabel.textAlignment = NSTextAlignmentRight;
            
            @weakify(self)
            //调用方法(核心)根据后面的枚举,传入不同的枚举,展示不同的模式
            _addressPickerView = [[FHAddressPickerView alloc] initWithkAddressPickerViewModel:kAddressPickerViewModelAll];
            //默认为NO
            //_addressPickerView.showLastSelect = YES;
            _addressPickerView.cancelBtnBlock = ^() {
                @strongify(self)
                //移除掉地址选择器
                [self.addressPickerView hiddenInView];
            };
            _addressPickerView.sureBtnBlock = ^(NSString *province,
                                                NSString *city,
                                                NSString *district,
                                                NSString *addressCode,
                                                NSString *parentCode,
                                                NSString *provienceCode) {
                //返回过来的信息在后面的这四个参数中,使用的时候要做非空判断,(province和addressCode为必返回参数,可以不做非空判断)
                @strongify(self)
                NSString *showString;
                if (city != nil) {
                    showString = [NSString stringWithFormat:@"%@",city];
                }else{
                    showString = province;
                }
                
                if (district != nil) {
                    showString = [NSString stringWithFormat:@"%@%@", showString, district];
                }
                
                self->addressLabel.text = [NSString stringWithFormat:@"%@%@%@",province,city,district];
                self->strProvince = provienceCode;
                self->strCity = parentCode;
                self->strArea = addressCode;
                //移除掉地址选择器
                [self.addressPickerView hiddenInView];
                self->conserveBtn.hidden = NO;
            };

            //topView添加手势 点击进入邀请的好友记录
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLabelClick)];
            addressLabel.userInteractionEnabled = YES;
            [addressLabel addGestureRecognizer:gesture];
            [cell.contentView addSubview:addressLabel];
        } else {
            leftLab.text = @"详细地址:";

            leftLab.frame = CGRectMake((12.0), 5,(80.0), 30.0);

            detailAddressTextView  = [[UITextView alloc]init];
            detailAddressTextView.frame = CGRectMake(100, 2,263, 90);
            detailAddressTextView.text = self.strDetialAddress;
            detailAddressTextView.font = [UIFont systemFontOfSize:15];
            detailAddressTextView.delegate = self;
            [cell.contentView addSubview:detailAddressTextView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

//返回每行的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return (90);
    }
    return (44);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (5);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = [UIColor colorWithHexStr:@"#EDECEC"];
    return headerView;
}

//每行的点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//弹出地址选择picker
- (void)addressLabelClick {
    [self.addressPickerView showInView:self.view];
    conserveBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark textFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSUInteger existedLength = textField.text.length;
    NSUInteger selectedLength = range.length;
    NSUInteger replaceLength = string.length;
    if (textField == phoneNumberTF) {
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }

    return YES;
}

@end
