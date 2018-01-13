//
//  LMRegisterController.m
//  实体联盟
//
//  Created by 贾斌 on 2017/7/9.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "LMRegisterController.h"
#import "YWAgreeViewController.h"
#import "LMLoginController.h"

#define LMAccountKey @"account"
#define LMPwdKey @"pwd"
#define LMRmbPwdKey @"resetPwd"
#define LMAutoLoginKey @"proCode"
@interface LMRegisterController ()<UITextFieldDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

{
     NSArray *_dataSource;
            int  _res;
        BOOL  _isProv;
    //参数
    NSString *_name;
    NSString *_password;
    NSString *_mobile;
    NSString *_code;
    NSString *_aPassword;
    
     NSTimer *_myTimer;
    NSString *_valueCode;//验证码
}

/** 头像 */
@property (nonatomic,weak) UIImageView *iconImageView;

/**单位*/
@property (nonatomic, weak) UITextField *officeTextField;
/**姓名*/
@property (nonatomic, weak) UITextField *nameTextField;
/**姓名*/
@property (nonatomic, weak) UITextField *phoneTextField;
/**验证码*/
@property (nonatomic, weak) UITextField *codeTextField;
/**密码*/
@property (nonatomic, weak) UITextField *pwdTextField;
/**验证码按钮*/
@property (nonatomic, weak)          UIButton *proCodeBtn;
/**注册按钮*/
@property (nonatomic, weak)          UIButton *registerBtn;
/**验证码按钮*/
@property (nonatomic, weak)          UIButton *protcolBtn;
/**注册按钮*/
@property (nonatomic, weak)          UIButton *privacyBtn;
@property (nonatomic, weak) UIImageView *noDataView;
/**遮盖*/
@property (weak, nonatomic) UIView *cover;
/** 是否有人发布意见 */
@property (nonatomic, assign) BOOL  iderVCSendIderSuccess;
/** 用户模型 */
@property (nonatomic,strong) UITableView *tableView;
/** 用户模型 */
@property (nonatomic,strong) UITableView *companyView;
/** 用户模型 */
@property (nonatomic,strong) NSMutableArray *companys;

@end

@implementation LMRegisterController

- (UITableView *)companyView
{
    if (!_companyView) {
        _companyView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _companyView.delegate = self;
        _companyView.dataSource = self;
        _companyView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _companyView.backgroundColor = [UIColor whiteColor];
        _companyView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_companyView];
        _companyView.frame = CGRectMake((SCREEN_WIDTH-280)*0.5,SCREEN_HEIGHT*0.3,280,180);
    }
    return _companyView;
}

- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 3;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        CGFloat viewY = CGRectGetMaxY(self.officeTextField.frame);
        _tableView.frame = CGRectMake(20,viewY,SCREEN_WIDTH - 40,200);
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    //[self initData];
     [self setupAllChildView];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdTextField];

    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.officeTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    
    // 读取上次的配置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phoneTextField.text = [defaults objectForKey:LMAccountKey];
    self.pwdTextField.text = [defaults objectForKey:LMRmbPwdKey];
    



}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - custom
- (void)setupAllChildView
{
    //添加所有的子视图
    UIImageView *icon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_launcher"]];
    icon.userInteractionEnabled = YES;
    self.iconImageView = icon;
    icon.layer.cornerRadius = 12;
    icon.clipsToBounds = YES;
    CGFloat iconViewWH = 80;
    CGFloat iconX = (SCREEN_WIDTH-iconViewWH)*0.5;
    icon.frame = CGRectMake(iconX,50, iconViewWH, iconViewWH);
    [self.view addSubview:_iconImageView];
      //电话输入框
    CGFloat viewX = 30;
    CGFloat viewW = SCREEN_WIDTH - viewX*2;
    CGFloat viewH = 50;
    
    //单位
    UITextField *officeTextField = [[UITextField alloc] init];
    self.officeTextField = officeTextField;
    officeTextField.keyboardType = UIKeyboardTypeWebSearch;
    officeTextField.delegate = self;
    CGFloat rePutPwdY = CGRectGetMaxY(icon.frame)+50;
    officeTextField.frame = CGRectMake(viewX, rePutPwdY, viewW, viewH);
    [officeTextField addTarget:self action:@selector(officeTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    officeTextField.font = FONT_15;
    //分割线up
    UIView *lineViewUp = [[UIView alloc]init];
    lineViewUp.backgroundColor = COLOR_Line;
    lineViewUp.alpha = 0.5;
    lineViewUp.frame = CGRectMake(-5, 0, viewW+10, 0.5);
    [officeTextField addSubview:lineViewUp];
    
    //分割线down
    UIView *lineViewDown = [[UIView alloc]init];
    lineViewDown.backgroundColor = COLOR_Line;
    lineViewDown.alpha = 0.5;
    lineViewDown.frame = CGRectMake(-5,viewH-0.5,viewW+10, 0.5);
    [officeTextField addSubview:lineViewDown];
    [self.view addSubview:officeTextField];
    officeTextField.delegate = self;
    officeTextField.placeholder = @"请输入单位名称";
    officeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    officeTextField.leftViewMode = UITextFieldViewModeAlways;


    //姓名输入框
    UITextField *nameTextField = [[UITextField alloc] init];
    CGFloat nameTextY = CGRectGetMaxY(officeTextField.frame);
    nameTextField.frame = CGRectMake(viewX, nameTextY, viewW, viewH);
    nameTextField.font = FONT_15;
    self.nameTextField = nameTextField;
    nameTextField.delegate = self;
    nameTextField.placeholder = @"请输入您的姓名";
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
     //姓名分割线
    UIView *lineViewName = [[UIView alloc]init];
    lineViewName.backgroundColor = COLOR_Line;
    lineViewName.alpha = 0.5;
    lineViewName.frame = CGRectMake(-5,viewH-0.5,viewW+10, 0.5);
    [nameTextField addSubview:lineViewName];
    [self.view addSubview:nameTextField];

    //手机输入框
    UITextField *phoneText = [[UITextField alloc] init];
    CGFloat phoneY = CGRectGetMaxY(nameTextField.frame);

    phoneText.frame = CGRectMake(viewX, phoneY, viewW, viewH);
    self.phoneTextField = phoneText;
    phoneText.delegate = self;
    phoneText.font = FONT_15;
    //phoneText.leftIconNameStr = @"handShake";
    phoneText.placeholder = @"请输入11位手机号";
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChange) name:UITextFieldTextDidChangeNotification object:phoneText];
    
    //电话分割线
    UIView *lineViewPhone = [[UIView alloc]init];
    lineViewPhone.backgroundColor = COLOR_Line;
    lineViewPhone.alpha = 0.5;
    lineViewPhone.frame = CGRectMake(-5,viewH-0.5,viewW+10, 0.5);
    [phoneText addSubview:lineViewPhone];
    [self.view addSubview:self.phoneTextField];
    
    
    //验证输入框
    UITextField *proText = [[UITextField alloc] init];
    CGFloat proTextY = CGRectGetMaxY(phoneText.frame);
    proText.frame = CGRectMake(viewX, proTextY, viewW, viewH);
    proText.font = FONT_15;
    
    self.codeTextField = proText;
    proText.layer.cornerRadius = 5;
    proText.layer.masksToBounds = YES;
    proText.delegate = self;
    proText.placeholder = @"请输入正确的验证码";
    proText.backgroundColor = [UIColor whiteColor];
    proText.keyboardType = UIKeyboardTypeNumberPad;

    //验证码分割线
    UIView *lineViewCode = [[UIView alloc]init];
    lineViewCode.backgroundColor = COLOR_Line;
    lineViewCode.alpha = 0.5;
    lineViewCode.frame = CGRectMake(-5,viewH-0.5,viewW + 10, 0.5);
    [self.codeTextField addSubview:lineViewCode];
    [self.view addSubview:self.codeTextField];
    
    //验证按钮
    UIButton *probutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.proCodeBtn = probutton;
    probutton.layer.cornerRadius = 5;
    probutton.clipsToBounds = YES;
    probutton.enabled = NO;
    probutton.frame = CGRectMake(proText.width*0.7, 10,proText.width*0.3, viewH-20);
    probutton.backgroundColor = [UIColor lightGrayColor];
    [probutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [probutton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [probutton addTarget:self action:@selector(proRegesterCodeClick) forControlEvents:UIControlEventTouchUpInside];
    YWLog(@"probtn%@",probutton.titleLabel);
    probutton.titleLabel.font = FONT_14;
    [proText addSubview:probutton];

  //密码输入框
    UITextField *pwdText = [[UITextField alloc] init];
    CGFloat pwdY = CGRectGetMaxY(proText.frame);
    pwdText.frame = CGRectMake(viewX, pwdY, viewW, viewH);
    self.pwdTextField = pwdText;
    pwdText.font = FONT_14;
    
    //验证码分割线
    UIView *lineViewPwd = [[UIView alloc]init];
    lineViewPwd.backgroundColor = COLOR_Line;
    lineViewPwd.alpha = 0.5;
    lineViewPwd.frame = CGRectMake(-5,viewH-0.5,viewW+10, 0.5);
    [pwdText addSubview:lineViewPwd];
    
    [self.view addSubview:self.pwdTextField];
    pwdText.delegate = self;
    pwdText.secureTextEntry = YES;
    //pwdText.leftIconNameStr = @"IDInfo";
    pwdText.placeholder = @"请设置你的密码";
    pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdText.keyboardType = UIKeyboardTypeNumberPad;
    pwdText.leftViewMode = UITextFieldViewModeAlways;
    
    
   //确定按钮
    UIButton *button = [[UIButton alloc] init];
    self.registerBtn = button;
    button.enabled = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat risterBtnY = CGRectGetMaxY(pwdText.frame)+50;
    button.frame = CGRectMake(viewX,risterBtnY, viewW, viewH - 5);
    
    [button addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor lightGrayColor];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONT_BOLD_17;
    [self.view addSubview:button];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    CGFloat tipLabelY = CGRectGetMaxY(self.registerBtn.frame)+10;
    CGFloat tipW = 220;
    CGFloat tipX = (SCREEN_WIDTH - tipW)*0.5;
    tipLabel.frame = CGRectMake(tipX, tipLabelY, tipW, 20);
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"点击注册即表示您同意并愿意遵守";
    tipLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tipLabel];

    //同意协议按钮
    UIButton *greebutton = [[UIButton alloc] init];
    
    CGFloat btnW = 150;
    CGFloat btnX = (SCREEN_WIDTH - btnW)*0.5;
    CGFloat btnY = CGRectGetMaxY(tipLabel.frame);
    greebutton.frame = CGRectMake(btnX, btnY, btnW , 20);
    [greebutton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    greebutton.titleLabel.font = FONT_13;
    [greebutton setTitle:@"用户协议和隐私政策" forState:UIControlStateNormal];
    [greebutton addTarget:self action:@selector(agreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:greebutton];


}

- (void)agreeButtonClicked{
    
    YWAgreeViewController *vc = [[YWAgreeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  单位名称文本框的文字发生改变的时候调用
 */
- (void)officeTextFieldDidChange
{
    
    
    
    if (self.officeTextField.text.length != 0)
    {
        
        NSMutableDictionary *param = [NSMutableDictionary  dictionary];
        //手机号
        param[@"company"] = self.officeTextField.text;
        
        NSString *shortStr = @"/user_company.php";
        NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];
        
        [HMHttpTool get:url params:param success:^(id responseObj) {
            NSDictionary *dict = responseObj[@"data"];
            NSString *status = responseObj[@"code"];
            //NSString *msg = responseObj[@"tip"];
            
            if ([status isEqual:@1]) { // 数据郑州厦门厦门
                
                NSMutableArray *dicArr = [[NSMutableArray alloc] init];
                for (NSString *str in dict) {
                    [dicArr addObject:str];
                }
                self.companys = dicArr;
                //获得模型数据郑州
                [self.tableView reloadData];
                /**停止刷新*/
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
            }
            
            YWLog(@"mine--officeTextChange%@",responseObj);
            
        } failure:^(NSError *error) {
            
            YWLog(@"请求失败--%@", error);
            
        }];
        
        
        [self tableViewClick];
    }
    
    
}


/**
 *  弹出view
 */
- (void)tableViewClick
{
    
    CGFloat duration = 0.25;
    if (self.cover == nil) {
        // 1.添加遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0;
        //[cover addTarget:self action:@selector(tableViewClick) forControlEvents:UIControlEventTouchUpInside];
        self.cover = cover;
        //[self.view addSubview:self.loginView];
        // 2.添加loginView到最中间
        [self.view bringSubviewToFront:self.tableView];
        [self.view insertSubview:cover belowSubview:self.tableView];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.view addSubview:self.tableView];
            
        }];
    } else {
        
        [self.cover removeFromSuperview];
        [self.tableView removeFromSuperview];
        self.cover = nil;
    }
    
}
/**
 *  文本框的文字发生改变的时候调用
 */
- (void)phoneTextFieldChange
{
    // 获取单位公司列表
    if (self.phoneTextField.text.length == 0) {
        self.proCodeBtn.enabled = NO;
        self.proCodeBtn.backgroundColor = [UIColor lightGrayColor];
        
    }else if (self.phoneTextField.text.length == 11) {
       
       self.proCodeBtn.enabled = YES;
       self.proCodeBtn.backgroundColor = LOGINCLOLOR;
        
    }

}

#pragma mark--验证按钮点击
- (void)proRegesterCodeClick
{
    //设置倒计时按钮样式
    [self setUpProcodeBtn];
    //发送请求
    NSMutableDictionary *param = [NSMutableDictionary  dictionary];
    //手机号
    param[@"mobile"] = self.phoneTextField.text;
    //版本号
    param[@"type"] = @"sms_register";
 
    NSString *shortStr = @"/sms_send.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];

        [HMHttpTool get:url params:param success:^(id responseObj) {
            NSArray *dict = responseObj[@"data"];
            NSString *status = responseObj[@"code"];
            NSString *msg = responseObj[@"tip"];
            //YWLog(@"getWarningEvent--%@",responseObj);
            if ([status isEqual:@1] && msg) { // 数据
                //返回发送成功提示信息
                [SVProgressHUD showSuccessWithStatus:msg];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];

#warning mark-TODO
                    
                    
                [SVProgressHUD showSuccessWithStatus:msg];
                    //self.codeTextField.text =
                });

            }else{
                
                //返回发送失败信息
                
            }
            
            
        } failure:^(NSError *error) {
            
            YWLog(@"请求失败--%@", error);
            
            
        }];
    
}

//注册
- (void)doRegister
{
    
    //发送注册请求
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    
    //单位
    params[@"company"] = self.officeTextField.text;
    //名称
    params[@"name"] = self.nameTextField.text;
    //手机号
    params[@"mobile"] = self.phoneTextField.text;
    //密码
    params[@"password"] = self.pwdTextField.text;
    //手机验证码
    params[@"vercode"] = self.codeTextField.text;
    //手机号
    params[@"token"] = @"";
    
    
    NSString *shortStr = @"/user_register.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];
    [HMHttpTool post:url params:params success:^(id responseObj) {
        
        NSString *code = responseObj[@"code"];
        NSString *dict = responseObj[@"data"];
        NSString *msg = responseObj[@"tip"];
        YWLog(@"doRegister-params-%@",params);
        if ([code  isEqual:@1]) {
            
            //如果注册成功，请重新登陆
            //LMLoginController *logVc = [[LMLoginController alloc] init];
            //[self.navigationController pushViewController:logVc animated:YES];
            [SVProgressHUD showSuccessWithStatus:msg];
            [self popoverPresentationController];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
        
        YWLog(@"mine--doRegister%@",responseObj);
        
    } failure:^(NSError *error) {
        
        YWLog(@"请求失败--%@", error);
        
    }];
    
    
}
//结束输入文字时退出键盘
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == self.officeTextField) {
        [self.officeTextField resignFirstResponder];
    }
    
   
}
#pragma mark--tableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.companys.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    static NSString *ID = @"companyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.font = FONT_14;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = self.companys[indexPath.row];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   [self tableViewClick];
    self.officeTextField.text = self.companys[indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}

//设置倒计时按钮样式
- (void)setUpProcodeBtn
{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.proCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.proCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.proCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.proCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.proCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.proCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)textChange
{
    
    //注册按钮状态设置
    if (self.phoneTextField.text.length == 0 || self.pwdTextField.text.length == 0 ||self.officeTextField.text.length == 0 || self.codeTextField.text.length == 0 || self.nameTextField.text.length == 0) {
        self.registerBtn.backgroundColor = [UIColor lightGrayColor];
        self.registerBtn.enabled = NO;
        
    }else if(self.phoneTextField.text.length != 0 && self.pwdTextField.text.length != 0 &&self.officeTextField.text.length != 0 && self.codeTextField.text.length != 0 && self.nameTextField.text.length != 0){
        
        self.registerBtn.enabled = YES;
        self.registerBtn.backgroundColor = LOGINCLOLOR;
        
    }

}



- (void)doFind
{
    YWLog(@"doFind");
}


- (void)doSure
{
    YWLog(@"doSure");
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
