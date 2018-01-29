//
//  YWShareController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWShareController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface YWShareController ()

@end

@implementation YWShareController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分享";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加子控件
    [self creatAllView];
    // Do any additional setup after loading the view.
}

- (void)creatAllView
{
   
    //顶部文字
    //提示标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"       \"运维宝\"是电力设备在线状态监测预警与电力设备运维管理移动应用平台。应用\"运维宝\"您能在任何时候，任何地方，在线监测分析您的电力设备状态;查看设备档案，技术图纸，试验报告;共享设备制造商的售后服务，专家团队，备品备件资源。";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top .mas_equalTo(10);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(120);
    }];

    
    //中间二维码图片
    UIImageView *share = [[UIImageView alloc] init];
    share.contentMode = UIViewContentModeScaleAspectFill;
    share.image = [UIImage imageNamed:@"downLoadErWeiMa"];
    [self.view addSubview:share];
    
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];

    //提示扫描文字
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"扫一扫二维码下载\"运维宝\"客户端";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(share.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];

    //分享按钮
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.titleLabel.font = FONT_BOLD_17;
    shareBtn.layer.cornerRadius = 5;
    shareBtn.clipsToBounds = YES;
    shareBtn.backgroundColor = LOGINCLOLOR;
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [shareBtn addTarget:self action:@selector(shareBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];

    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(35);
    }];
    
}

//分享按钮点击事件
- (void)shareBtnDidClick
{
    //1、创建分享参数  erweima
    NSArray* imageArray1 = @[[UIImage imageNamed:@"downLoadErWeiMa"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray1) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"“运维宝”是电力设备在线状态监测预警与电力设备运维管理移动应用平台。"
                                         images:imageArray1
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ep%E8%BF%90%E7%BB%B4%E5%AE%9D/id1331837742?l=zh&ls=1&mt=8"]
                                          title:@"“运维宝”"
                                           type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
               }
           }
     ];}
 
        
}
@end
