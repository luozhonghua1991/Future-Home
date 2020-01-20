//
//  FHAddOrEditInvoiceController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/14.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  编辑或者添加p发票

#import "FHAddOrEditInvoiceController.h"

@interface FHAddOrEditInvoiceController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *companyNameTF;//公司名字TF
    UITextField *companyCodeTF;//公司编号TF
    UITextField *companyAddressTF;//公司地址TF
    UITextField *companyPhoneTF;//公司电话TF
    UITextField *companyBankTF;//公司开户银行TF
    UITextField *companyAccountTF;//公司开户账号TF
    UIButton *conserveBtn;//保存按钮
    
}
/**tbale*/
@property (nonatomic,strong) UITableView *editAddTableView;
@end

@implementation FHAddOrEditInvoiceController

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
    self.view.backgroundColor = [UIColor colorWithHexStr:@"#EDECEC"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self fh_creatNav];
    [self.view addSubview:self.editAddTableView];
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

//保存按钮
- (void)creatBottomBtn {
    if (conserveBtn == nil) {
        conserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        conserveBtn.frame = CGRectMake(0, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50),SCREEN_WIDTH , (50));
        conserveBtn.backgroundColor = HEX_COLOR(0x1296db);
        [conserveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [conserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [conserveBtn addTarget:self action:@selector(conserveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:conserveBtn];
    }
}


- (void)conserveBtnClick {
    /** 保存发票 */
    /** id新增的话 传0 更新的话传 */
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic;
    if ([self.titleName isEqualToString:@"添加发票"]) {
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     @"0",@"id",
                     companyNameTF.text,@"company",
                     companyCodeTF.text,@"code",
                     companyAddressTF.text,@"address",
                     companyPhoneTF.text,@"tel",
                     companyBankTF.text,@"openbank",
                     companyAccountTF.text,@"accountinfo",
                     nil];
    } else {
        paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     self.companyID,@"id",
                     companyNameTF.text,@"company",
                     companyCodeTF.text,@"code",
                     companyAddressTF.text,@"address",
                     companyPhoneTF.text,@"tel",
                     companyBankTF.text,@"openbank",
                     companyAccountTF.text,@"accountinfo",
                     [SingleManager shareManager].ordertype,@"ordertype",
                     nil];
    }
    
    [AFNetWorkTool post:@"shop/addeditInvoice" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            [weakSelf.view makeToast:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.view makeToast:@"保存失败"];
    }];
}

#pragma mark - TableDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//返回区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
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
            leftLab.text = @"公司单位:";
            //收件人TF
            companyNameTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.companyName)) {
                companyNameTF.text = self.companyName;
            }
            companyNameTF.placeholder = @"          请输入公司单位";
            companyNameTF.textAlignment = NSTextAlignmentRight;
            companyNameTF.delegate = self;
            companyNameTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:companyNameTF];
        }   else if (indexPath.section == 1) {
            leftLab.text = @"公司税号:";
            //手机号码TF
            companyCodeTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.companyCode)) {
                companyCodeTF.text = self.companyCode;
            }
            companyCodeTF.placeholder = @"           请输入公司税号";
            companyCodeTF.textAlignment = NSTextAlignmentRight;
            companyCodeTF.delegate = self;
            companyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
            companyCodeTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:companyCodeTF];
        } else if(indexPath.section == 2) {
            leftLab.text = @"公司地址:";
            //收件人TF
            companyAddressTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.companyName)) {
                companyAddressTF.text = self.companyAddress;
            }
            companyAddressTF.placeholder = @"          请输入公司地址";
            companyAddressTF.textAlignment = NSTextAlignmentRight;
            companyAddressTF.delegate = self;
            companyAddressTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:companyAddressTF];
            
        } else if(indexPath.section == 3) {
            leftLab.text = @"公司电话:";
            //收件人TF
            companyPhoneTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.companyPhone)) {
                companyPhoneTF.text = self.companyPhone;
            }
            companyPhoneTF.placeholder = @"          请输入公司电话";
            companyPhoneTF.textAlignment = NSTextAlignmentRight;
            companyPhoneTF.delegate = self;
            companyPhoneTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:companyPhoneTF];
            
        } else if(indexPath.section == 4) {
            leftLab.text = @"开户银行:";
            //收件人TF
            companyBankTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.companyBank)) {
                companyBankTF.text = self.companyBank;
            }
            companyBankTF.placeholder = @"          请输入开户银行";
            companyBankTF.textAlignment = NSTextAlignmentRight;
            companyBankTF.delegate = self;
            companyBankTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:companyBankTF];
            
        } else if(indexPath.section == 5) {
            leftLab.text = @"开户账号:";
            //收件人TF
            companyAccountTF = [[UITextField alloc] initWithFrame:CGRectMake((100), 0, (263), (44))];
            if (!IsStringEmpty(self.companyAccount)) {
                companyAccountTF.text = self.companyAccount;
            }
            companyAccountTF.placeholder = @"          请输入开户账号";
            companyAccountTF.textAlignment = NSTextAlignmentRight;
            companyAccountTF.delegate = self;
            companyAccountTF.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:companyAccountTF];
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//返回每行的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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



@end
