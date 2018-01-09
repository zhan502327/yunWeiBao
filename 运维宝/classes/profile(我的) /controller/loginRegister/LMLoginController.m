//
//  LMLoginController.m
//  实体联盟
//
//  Created by 贾斌 on 2017/7/6.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "LMLoginController.h"
#import "LMRegisterController.h"
#import "LMSetPwdViewController.h"
#import "YWUser.h"
#import "YWTabbarController.h"
#import "YXAcount.h"

//账号文件路径
#define YXAcountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"acount.data"]
@interface LMLoginController ()

@property (weak, nonatomic) UIButton *rememberPwdBtn; // 记住密码
/** 头像 */
@property (nonatomic,weak) UIImageView *iconImageView;
/**用户名*/
@property (nonatomic, weak) UITextField *userName;
/**密码*/
@property (nonatomic, weak) UITextField *password;

/**登陆按钮*/
@property (nonatomic, weak) UIButton *loginBtn;
/**自动登陆按钮*/
@property (nonatomic, weak) UIButton *autoLogin;
/**重置密码*/
@property (nonatomic, weak) UIButton *setPwd;
/**注册按钮*/
@property (nonatomic, weak) UIButton *registerBtn;
/**注册按钮*/
@property (weak, nonatomic) UIView *mainPanel;
/**账号模型*/
@property (nonatomic, strong) YXAcount *acount;

@end

@implementation LMLoginController
singleton_implementation(LMLoginController)
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.acount) {
        self.userName.text = self.acount.name;
        self.password.text = self.acount.pwd;
    };
    
    [self setupAllChildView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"address4_guanbi" highImageName:@"" target:self action:@selector(leftBtnAction)];
    
    //输入框文字改变发出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:self.userName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:self.password];
    
}

#pragma mark - custom

- (void)setupNavigationView {
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //    去除导航栏下方的横线 透明
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}

//返回

- (void)leftBtnAction
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
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
    CGFloat viewY = CGRectGetMaxY(icon.frame)+50;
    CGFloat viewW = SCREEN_WIDTH - viewX*2;
    CGFloat viewH = 50;
    
    UITextField *userName = [[UITextField alloc] init];
    //userName.text = @"13600976198";
    userName.placeholder = @"请输入11位手机号";
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    userName.keyboardType = UIKeyboardTypeNumberPad;
    userName.font = FONT_15;
    userName.frame = CGRectMake(viewX, viewY, viewW, viewH);
    
    //分割线up
    UIView *lineViewUp = [[UIView alloc]init];
    lineViewUp.backgroundColor = COLOR_Line;
    lineViewUp.alpha = 0.5;
    lineViewUp.frame = CGRectMake(-5, 0, viewW+10, 0.5);
    [userName addSubview:lineViewUp];
    
    //分割线down
    UIView *lineViewDown = [[UIView alloc]init];
    lineViewDown.backgroundColor = COLOR_Line;
    lineViewDown.alpha = 0.5;
    lineViewDown.frame = CGRectMake(-5,viewH-0.5,viewW+10, 0.5);
    [userName addSubview:lineViewDown];
    [self.view addSubview:userName];
    _userName = userName;
    
    // 密码输入框
    UITextField *password = [[UITextField alloc] init];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    password.keyboardType = UIKeyboardTypeNumberPad;
    //password.text = @"123456";
    password.placeholder = @"请输入密码";
    password.font = FONT_15;
    [password setSecureTextEntry:YES];
    CGFloat pwdY = CGRectGetMaxY(userName.frame);
    password.frame = CGRectMake(viewX, pwdY, viewW, viewH);
    
    //分割线up
    UIView *lineViewPwd = [[UIView alloc]init];
    lineViewPwd.backgroundColor = COLOR_Line;
    lineViewPwd.alpha = 0.5;
    lineViewPwd.frame = CGRectMake(-5,viewH-0.5,viewW+10, 0.5);
    [password addSubview:lineViewPwd];
    [self.view addSubview:password];
    _password = password;
    
    YWLog(@"userName___text%@",self.userName.text);
    
    //    6、登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = FONT_BOLD_17;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
#warning mark-TODO
    //loginBtn.enabled = YES;
    loginBtn.backgroundColor = [UIColor lightGrayColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    [loginBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    CGFloat loginY = CGRectGetMaxY(password.frame)+20;
    CGFloat loginW = SCREEN_WIDTH-viewX*2;
    loginBtn.frame = CGRectMake(viewX, loginY, loginW, viewH-5);
    
    _loginBtn = loginBtn;
    
    //    7、注册按钮
    CGFloat registerY = CGRectGetMaxY(loginBtn.frame)+10;
    CGFloat registerW = 100;
    CGFloat margin = (SCREEN_WIDTH - registerW*3)/4;
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnDidPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    CGFloat registerX = viewX;
    registerBtn.frame = CGRectMake(registerX-10, registerY, registerW, 25);
    _registerBtn = registerBtn;
    
    // 5、重置密码按钮
    
    UIButton *setPwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [setPwd setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [setPwd addTarget:self action:@selector(setPwdDidPressed) forControlEvents:UIControlEventTouchUpInside];
    [setPwd setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    setPwd.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:setPwd];
    CGFloat setPwdX = registerW*2+margin*3;
    setPwd.frame = CGRectMake(setPwdX, registerY, registerW, 25);
    _setPwd = setPwd;
    
    
}

#pragma mark - 按钮点击处理
- (void)loginBtnDidClick
{
    
    if (self.userName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
    } else if (self.password.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
    }else{
        
        [SVProgressHUD showWithStatus:@"正在登录中"];
        //发送登录请求
        NSMutableDictionary *param = [NSMutableDictionary  dictionary];
        //手机号
        param[@"mobile"] = self.userName.text;
        //密码
        param[@"password"] = self.password.text;
        
        param[@"client_id"] = kGetData(@"token");
        NSString *shortStr = @"/user_login.php";
        NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];
        
        [HMHttpTool get:url params:param success:^(id responseObj) {
            NSDictionary *dict = responseObj[@"data"];
            NSString *status = responseObj[@"code"];
            NSString *msg = responseObj[@"tip"];
            if ([status  isEqual:@1] && msg) {
                //隐藏提示框
                
                [SVProgressHUD showSuccessWithStatus:msg];
                YWTabbarController *tabbar = [[YWTabbarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
                
                //账号模型
                YXAcount *acount = [[YXAcount alloc] init];
                self.acount = acount;
                
                acount.name = self.userName.text;
                acount.pwd = self.password.text;
                // 3.账号数据归档
                //[NSKeyedArchiver archiveRootObject:acount toFile:YXAcountFilepath];
                
                //如果注册成功，请重新登陆
                YWUser *user = [YWUser mj_objectWithKeyValues:dict];
                //发出通知保存用户信息
                [YWNotificationCenter postNotificationName:YWLogUserNotification object:nil userInfo:@{YWLogUser:user}];
                
                [GolbalManager sharedManager].logUser = user;
                [GolbalManager sharedManager].isLogin = YES;
                
                
   
                
                //存储登录
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                
                //存储用户token
                kDataPersistence(user.token,@"token");
                //存储用户ID
                kDataPersistence(user.account_id,@"account_id");
                //存储用户ID
                kDataPersistence(user.account,@"account");
                //存储用户ID
                kDataPersistence(user.nick,@"nick");
                //存储用户ID
                kDataPersistence(user.photo_path,@"photo_path");
                
                kDataPersistence(user.photo_id, @"photo_id");
                //存储用户ID
                kDataPersistence(user.tel1,@"tel1");
                //存储用户ID
                kDataPersistence(user.app_title,@"app_title");
                
                kDataPersistence(self.userName.text,@"db_login_mobile");
                kDataPersistence(self.password.text,@"db_login_password");

                
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                
                [self leftBtnAction];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
                });
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"请输入正确账号或密码"];
                [SVProgressHUD showErrorWithStatus:msg];

            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            
        }];
        
    }
    
}

//注册新用户
- (void)registerBtnDidPressed
{
    LMRegisterController *registerVc = [[LMRegisterController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
    
    YWLog(@"registerBtn");
    
}

// 重置密码
- (void)setPwdDidPressed{
    
    LMSetPwdViewController *setpwd = [[LMSetPwdViewController alloc] init];
    [self.navigationController pushViewController:setpwd animated:YES];
    YWLog(@"setPwdBtn");
    
}

//监听通知
- (void)textFieldChanged {
    
    if (self.userName.text.length == 0 || self.password.text.length == 0) {
        self.loginBtn.backgroundColor = [UIColor lightGrayColor];
        self.loginBtn.enabled = NO;
        
    }else if(self.userName.text.length != 0 && self.password.text.length != 0){
        
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = LOGINCLOLOR;
    }
}
//移除通知
- (void)dealloc
{
    [YWNotificationCenter removeObserver:self];
}

@end
