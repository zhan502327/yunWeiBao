//
//  YWAdviceController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWAdviceController.h"
#import "YXTextView.h"

@interface YWAdviceController ()
/**反馈已将输入框*/
@property (nonatomic, weak) YXTextView *adviceTv;
/**邮箱输入框*/
@property (nonatomic, weak) UITextField *emailTf;
/**提交按钮*/
@property (nonatomic, weak) UIButton *submitBtn;
@end

@implementation YWAdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:self.adviceTv];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:self.emailTf];

    //添加子控件
    [self creatAllView];
    
}


- (void)creatAllView
{
    
    //顶部文字
    //提示标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"       \"运维宝\"是电力设备在线状态监测预警与电力设备运维管理移动应用平台。应用\"运维宝\"您能在任何时候，任何地方，在线监测分析您的电力设备状态;查看设备档案，技术图纸，试验报告;共享设备制造商的售后服务，专家团队，备品备件资源。欢迎您提出宝贵的建议和反馈，我们将及时处理与回复。谢谢您的支持！";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top .mas_equalTo(10);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(150);
    }];
    
    //反馈意见
    UILabel *adviceLabel = [[UILabel alloc] init];
    adviceLabel.textAlignment = NSTextAlignmentLeft;
    adviceLabel.numberOfLines = 0;
    adviceLabel.text = @"反馈意见";
    adviceLabel.textColor = [UIColor darkGrayColor];
    adviceLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:adviceLabel];
    
    [adviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];

    
    YXTextView *adviceTv = [[YXTextView alloc] init];
    adviceTv.layer.borderWidth = 0.5;
    adviceTv.placeholder = @"请在这里填写您遇到的问题和建议";
    adviceTv.placeholderColor = [UIColor lightGrayColor];
    adviceTv.layer.borderColor = LOGINCLOLOR.CGColor;
    self.adviceTv = adviceTv;
    adviceTv.font = FONT_15;
    // 2.监听textView文字改变的通知
    [YWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:adviceTv];
    
    [self.view addSubview:adviceTv];
    
    [adviceTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(adviceLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 100));
    }];
    
    
    //提示扫描文字
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.textAlignment = NSTextAlignmentLeft;
   
    emailLabel.text = @"请输入您的常用邮箱地址，方便我们联系您";
    emailLabel.textColor = [UIColor darkGrayColor];
    emailLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(adviceTv.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    //邮箱输入
    UITextField *emailTf = [[UITextField alloc] init];
    emailTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    emailTf.leftViewMode = UITextFieldViewModeAlways;
    emailTf.font = FONT_15;
    self.emailTf = emailTf;
    emailTf.layer.borderWidth = 0.5;
    emailTf.layer.borderColor = LOGINCLOLOR.CGColor;
    emailTf.placeholder = @"请输入您的常用邮箱";
    // 2.监听邮箱输入框文字改变的通知
    [YWNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:emailTf];
    [self.view addSubview:emailTf];
    
    [emailTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(emailLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 35));
    }];

    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    self.submitBtn = submitBtn;
    submitBtn.titleLabel.font = FONT_BOLD_17;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    submitBtn.backgroundColor = [UIColor lightGrayColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [submitBtn addTarget:self action:@selector(submitBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emailTf.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
    
}

/**
 *  监听文字改变
 */
- (void)textDidChange
{
    //控制提交按钮状态
    if (self.adviceTv.text.length == 0 || self.emailTf.text.length == 0) {
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submitBtn.enabled = NO;
        
    
    }else if(self.adviceTv.text.length != 0 && self.emailTf.text.length != 0){
        
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = LOGINCLOLOR;
        
    }
   
}

//提交按钮点击事件
- (void)submitBtnDidClick
{
    
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    
    NSString *shortStr = @"/user_feedback.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    //手机号
    params[@"email"] = self.emailTf.text;
    //版本号
    params[@"content"] = self.adviceTv.text;

    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        YWLog(@"submitBtnDidClick--%@",responseObj);
        if ([status isEqual:@1] && msg) { // 数据
            //返回发送成功提示信息
            
            [SVProgressHUD showSuccessWithStatus:msg];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
