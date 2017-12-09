//
//  LMSetPwdViewController.m
//  实体联盟
//
//  Created by 贾斌 on 2017/7/13.
//  Copyright © 2017年 贾斌. All rights reserved.
//

#import "LMSetPwdViewController.h"

@interface LMSetPwdViewController ()<UITextFieldDelegate>
{
    
    NSArray *_dataSource; 
    UIButton *_provingBtn;
    int _res;
    BOOL _isProv;
    //参数
    NSString*_name;
    NSString*_password;
    NSString*_mobile;
    NSString*_code;
    NSString*_aPassword;
    
    NSTimer*_myTimer;
    NSString*_valueCode;//验证码

}

/**姓名*/
@property (nonatomic, weak) UITextField *phoneTextField;
/**密码*/
@property (nonatomic, weak) UITextField *userPwdText;
/**密码*/
@property (nonatomic, weak) UITextField *reSetpwdText;
/**验证码*/
@property (nonatomic, weak) UITextField *codeTextField;
/**验证码按钮*/
@property (nonatomic, weak)    UIButton *proCodeBtn;

/**验证码按钮*/
@property (nonatomic, weak)    UIButton *resetPwdBtn;


@end

@implementation LMSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重设密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:self.userPwdText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:self.reSetpwdText];
    
    
    [self setupAllChildView];
    // Do any additional setup after loading the view.
}



#pragma mark - custom
- (void)setupAllChildView
{
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgview.image = [UIImage imageNamed:@"login_register_background"];
    bgview.userInteractionEnabled = YES;
    [self.view addSubview:bgview];
    CGFloat viewX = 30;
    CGFloat viewY = HEADER_HEIGHT+30;
    CGFloat viewW = SCREEN_WIDTH - viewX*2;
    CGFloat viewH = 35;
    
    //输入手机号
    UITextField *phoneText = [[UITextField alloc] init];
    phoneText.frame = CGRectMake(viewX,2, viewW, viewH);
    self.phoneTextField = phoneText;
    phoneText.delegate = self;
    phoneText.font = FONT_14;
    //phoneText.leftIconNameStr = @"handShake";
    phoneText.placeholder = @"请输入11位手机号";
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
   
    //验证码分割线
    UIView *lineViewPhone = [[UIView alloc]init];
    lineViewPhone.backgroundColor = COLOR_Line;
    lineViewPhone.alpha = 0.5;
    lineViewPhone.frame = CGRectMake(-5,viewH-0.5,viewW + 10, 0.5);
    [phoneText addSubview:lineViewPhone];
    [self.view addSubview:phoneText];

    
    //验证输入框
    UITextField *proText = [[UITextField alloc] init];
    CGFloat proTextY = CGRectGetMaxY(phoneText.frame);
    proText.frame = CGRectMake(viewX, proTextY, viewW, viewH);
    proText.font = FONT_14;
    //proText.leftIconNameStr = @"MoreAbout";
    self.codeTextField = proText;
    proText.layer.cornerRadius = 5;
    proText.layer.masksToBounds = YES;
    proText.delegate = self;
    proText.keyboardType = UIKeyboardTypeNumberPad;
    proText.placeholder = @"请输入正确的验证码";
    proText.backgroundColor = [UIColor whiteColor];
    
    //验证码分割线
    UIView *lineViewCode = [[UIView alloc]init];
    lineViewCode.backgroundColor = COLOR_Line;
    lineViewCode.alpha = 0.5;
    lineViewCode.frame = CGRectMake(-5,viewH-0.5,viewW + 10, 0.5);
    [proText addSubview:lineViewCode];

    
    [self.view addSubview:proText];
    
    //验证按钮
    UIButton *probutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.proCodeBtn = probutton;
    probutton.layer.cornerRadius = 5;
    probutton.clipsToBounds = YES;
    probutton.frame = CGRectMake(proText.width*0.7,5,proText.width*0.3, viewH-10);
    probutton.backgroundColor = [UIColor lightGrayColor];
    [probutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [probutton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [probutton addTarget:self action:@selector(proCodeClick) forControlEvents:UIControlEventTouchUpInside];
    
    YWLog(@"probtn%@",probutton.titleLabel);
    probutton.titleLabel.font = FONT_13;
    [proText addSubview:probutton];
    
    //密码输入框
    UITextField *userPwdText = [[UITextField alloc] init];
    CGFloat pwdY = CGRectGetMaxY(proText.frame);
    userPwdText.frame = CGRectMake(viewX, pwdY, viewW, viewH);
    self.userPwdText = userPwdText;
    userPwdText.font = FONT_14;
    userPwdText.delegate = self;
    userPwdText.secureTextEntry = YES;
    //reSetpwdText.leftIconNameStr = @"IDInfo";
    userPwdText.placeholder = @"请设置你的新密码";
    userPwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    userPwdText.keyboardType = UIKeyboardTypeNumberPad;
    userPwdText.leftViewMode = UITextFieldViewModeAlways;
    
    //验证码分割线
    UIView *lineViewPwd = [[UIView alloc]init];
    lineViewPwd.backgroundColor = COLOR_Line;
    lineViewPwd.alpha = 0.5;
    lineViewPwd.frame = CGRectMake(-5,viewH-0.5,viewW + 10, 0.5);
    [userPwdText addSubview:lineViewPwd];
    
    [self.view addSubview:self.userPwdText];
    
    //重置密码输入框
    UITextField *reSetpwdText = [[UITextField alloc] init];
    CGFloat repwdY = CGRectGetMaxY(userPwdText.frame);
    reSetpwdText.frame = CGRectMake(viewX, repwdY, viewW, viewH);
    self.reSetpwdText = reSetpwdText;
    reSetpwdText.font = FONT_14;
    reSetpwdText.delegate = self;
    reSetpwdText.secureTextEntry = YES;
    //reSetpwdText.leftIconNameStr = @"IDInfo";
    reSetpwdText.placeholder = @"请重新输入你的新密码";
    reSetpwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    reSetpwdText.keyboardType = UIKeyboardTypeNumberPad;
    reSetpwdText.leftViewMode = UITextFieldViewModeAlways;
    
    //验证码分割线
    UIView *lineViewReSet = [[UIView alloc]init];
    lineViewReSet.backgroundColor = COLOR_Line;
    lineViewReSet.alpha = 0.5;
    lineViewReSet.frame = CGRectMake(-5,viewH-0.5,viewW + 10, 0.5);
    [reSetpwdText addSubview:lineViewReSet];

    [self.view addSubview:self.reSetpwdText];
    
    //重置密码按钮
    UIButton *resetPwdBtn = [[UIButton alloc] init];
    self.resetPwdBtn = resetPwdBtn;
    [resetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat risterBtnY = CGRectGetMaxY(reSetpwdText.frame)+20;
    resetPwdBtn.frame = CGRectMake(viewX,risterBtnY,viewW,viewH);
    
    [resetPwdBtn addTarget:self action:@selector(reSetPwdBtn) forControlEvents:UIControlEventTouchUpInside];
    resetPwdBtn.backgroundColor = [UIColor lightGrayColor];
    resetPwdBtn.layer.cornerRadius = 5;
    resetPwdBtn.layer.masksToBounds = YES;
    [resetPwdBtn setTitle:@"重设密码" forState:UIControlStateNormal];
        
    [resetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetPwdBtn.titleLabel.font = FONT_BOLD_16;
    [self.view addSubview:resetPwdBtn];
    
    
}

/**
 *  文本框的文字发生改变的时候调用
 */
- (void)phoneTextFieldChange
{
    // 发送验证手机号请求
    if (self.phoneTextField.text.length == 0) {
        self.proCodeBtn.enabled = NO;
        self.proCodeBtn.backgroundColor = [UIColor lightGrayColor];
        
    }else if (self.phoneTextField.text.length == 11) {
        
        self.proCodeBtn.enabled = YES;
        self.proCodeBtn.backgroundColor = LOGINCLOLOR;
    }
}
//输入框文字改变
- (void)textLabelChanged
{
    //注册按钮状态设置
    if (self.phoneTextField.text.length == 0 || self.codeTextField.text.length == 0 || self.reSetpwdText.text.length == 0||self.userPwdText.text.length == 0) {
        self.resetPwdBtn.backgroundColor = [UIColor lightGrayColor];
        self.resetPwdBtn.enabled = NO;
        
    }else if(self.phoneTextField.text.length != 0 && self.codeTextField.text.length != 0 && self.reSetpwdText.text.length != 0 && self.userPwdText.text.length != 0){
        
        self.resetPwdBtn.enabled = YES;
        self.resetPwdBtn.backgroundColor = LOGINCLOLOR;
        
    }

    YWLog(@"textLabelChanged");
}

//验证码点击
- (void)proCodeClick
{
    //设置验证码按钮样式
    [self setUpProcodeBtn];
    
    // 发送验证手机号请求
    if (self.phoneTextField.text.length == 0) {
        self.proCodeBtn.enabled = NO;
        self.proCodeBtn.backgroundColor = [UIColor lightGrayColor];
        
    }else if (self.phoneTextField.text.length == 11) {
        
        self.proCodeBtn.enabled = YES;
        self.proCodeBtn.backgroundColor = LOGINCLOLOR;

        //发送请求
        NSMutableDictionary *param = [NSMutableDictionary  dictionary];
        //手机号
        param[@"mobile"] = self.phoneTextField.text;
        //版本号
        param[@"type"] = @"sms_get_password";
        
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
                    

                    
                });
                
            }else{
                
                //返回发送失败信息
                [SVProgressHUD showErrorWithStatus:msg];
                
            }
            
            
        } failure:^(NSError *error) {
            
            YWLog(@"请求失败--%@", error);
            
            
        }];

    
    }
    
}


//重置密码
- (void)reSetPwdBtn
{
    
    //发送验证码是否正确请求
    NSMutableDictionary *param = [NSMutableDictionary  dictionary];
    //手机号
    param[@"mobile"] = self.phoneTextField.text;
    //版本号
    param[@"vercode"] = self.codeTextField.text;
    //版本号
    param[@"token"] = kGetData(@"token");
    
    
    NSString *shortStr = @"/sms_verification.php";
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
                [self reSetUserPwd];
                //self.codeTextField.text =
            });
            
        }else{
            
            //返回发送失败信息
            [SVProgressHUD showErrorWithStatus:msg];
            
        }
        
        
    } failure:^(NSError *error) {
        
        YWLog(@"请求失败--%@", error);
        
        
    }];

    YWLog(@"reSetPwdBtn");
}


//发送修改密码请求
- (void)reSetUserPwd
{
    
    //发送验证码是否正确请求
    NSMutableDictionary *param = [NSMutableDictionary  dictionary];
    //手机号
    param[@"mobile"] = self.phoneTextField.text;
       //版本号
    param[@"token"] = kGetData(@"token");
    //版本号
    param[@"pwd"] = self.userPwdText.text;

    //版本号
    param[@"repwd"] = self.reSetpwdText.text;

    NSString *shortStr = @"/user_update_pwd.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];
    
    [HMHttpTool get:url params:param success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        //YWLog(@"getWarningEvent--%@",responseObj);
        if ([status isEqual:@1] && msg) { // 数据
            //返回发送成功提示信息
            [SVProgressHUD showSuccessWithStatus:msg];
            //修改成功后退出页面
            [self.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
#warning mark-TODO
                
                //self.codeTextField.text =
            });
            
        }else{
            
            //返回发送失败信息
            [SVProgressHUD showErrorWithStatus:msg];
            
        }
        
        
    } failure:^(NSError *error) {
        
        YWLog(@"请求失败--%@", error);
        
        
    }];
    
    YWLog(@"reSetPwdBtn");
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}

@end
