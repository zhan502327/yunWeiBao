//
//  YWAboutUsController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWAboutUsController.h"

@interface YWAboutUsController ()

@end

@implementation YWAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加子控件
    [self creatAllView];
    // Do any additional setup after loading the view.
}

//添加子控件
- (void)creatAllView
{
  
    //提示标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"       \"运维宝\"是电力设备在线状态监测预警与电力设备运维管理移动应用平台。应用\"运维宝\"您能在任何时候，任何地方，在线监测分析您的电力设备状态;查看设备档案，技术图纸，试验报告;共享设备制造商的售后服务，专家团队，备品备件资源。\"运维宝\"实现设备运维管理移动化，帮你提高电力资产安全运维绩效，降低运维成本。\"运维宝\"-电力设备移动运维专业平台！";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top .mas_equalTo(10);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(180);
    }];
    
    
    //中间二维码图片
    UIImageView *share = [[UIImageView alloc] init];
    share.contentMode = UIViewContentModeScaleAspectFill;
    share.image = [UIImage imageNamed:@"push"];
    [self.view addSubview:share];
    
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
}
@end
