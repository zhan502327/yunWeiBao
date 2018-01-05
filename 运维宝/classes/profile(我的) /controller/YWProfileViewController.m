//
//  YWProfileViewController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWProfileViewController.h"
#import "YWAboutUsController.h"
#import "YWAdviceController.h"
#import "YWShareController.h"
#import "YWProfileViewCell.h"
#import "LMLoginController.h"
#import "YWNavViewController.h"
#import "MineHeadView.h"
#import "YWUser.h"

@interface YWProfileViewController ()
/** 用户模型 */
@property (nonatomic,strong)  YWUser *logUser;
/** 用户名称 */
@property (nonatomic,weak)  UILabel *userNick;
/** 用户ID */
@property (nonatomic,weak)  UILabel *userAcount;
/** MineHeadView */
@property (nonatomic,weak) MineHeadView *headView;
/* 商品图片 */
@property (strong , nonatomic) NSArray *titleArr;

@end
@implementation YWProfileViewController
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"关于我们",@"意见反馈",@"分享",];
    }
    return _titleArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *str1 = @"(";
    NSString *str2 = @")";
    
    self.userNick.text = [NSString stringWithFormat:@"姓名:%@%@%@%@",kGetData(@"nick"),str1,kGetData(@"account"),str2];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //头部view
    [self setUpHeaderView];
    //退出登陆注册
    [self setupFooter];
    NSString *str1 = @"(";
    NSString *str2 = @")";
    
    
    self.userNick.text = [NSString stringWithFormat:@"姓名:%@%@%@%@",[GolbalManager sharedManager].logUser.nick,str1,[GolbalManager sharedManager].logUser.account,str2];
    //用户ID
    self.userAcount.hidden = YES;
    //self.userAcount.text = [NSString stringWithFormat:@"ID:%@",kGetData(@"tel1")];
    
    //刷新页面
    //登陆成功通知
    [YWNotificationCenter addObserver:self selector:@selector(logUser:) name:YWLogUserNotification object:nil];
    
}

//用户模型数据
- (void)logUser:(NSNotification *)notifacation
{
    //取出用户模型
    YWUser *logUser = notifacation.userInfo[YWLogUser];
    self.logUser = logUser;
    //用户昵称
    
    self.userNick.text = [NSString stringWithFormat:@"姓名:%@",[GolbalManager sharedManager].logUser.nick];
    //用户ID
    self.userAcount.text = [NSString stringWithFormat:@"ID:%@",[GolbalManager sharedManager].logUser.account];
    //刷新页面
    [self.tableView reloadData];
    
    YWLog(@"logUser%@",logUser);
    
}

//个人资料页面
- (void)logOut
{
    //退出登录
    
}
// 1.用户头部view
- (void)setUpHeaderView
{
//    __weak typeof(self) weakSelf = self;
    
    MineHeadView *headView =  [[MineHeadView alloc] initWithFrame:CGRectZero loginButtonClick:^{
        
//        //点击头部事件
//        LMLoginController *login = [[LMLoginController alloc] init];
//
//        YWNavViewController *nav = [[YWNavViewController alloc] initWithRootViewController:login];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }];
    
    headView.backgroundColor = [UIColor clearColor];
    _headView = headView;
    
    
    NSString *urlStr = @"/assets_doucment_down.php";
    NSString *urlString = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    
    
    NSString *fileName = [NSString stringWithFormat:@"?token=%@&account_id=%@&file_id=%@",kGetData(@"token"), kGetData(@"account_id"), kGetData(@"photo_id")];
    urlString = [urlString stringByAppendingString:fileName];
    
    [headView.iconView.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    
    
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH,250);
    //账户金额明细工具条
    UIView *bgview = [[UIView alloc] init];
    //bgview.backgroundColor = [UIColor darkGrayColor];
    CGFloat bgviewY = CGRectGetMaxY(headView.frame);
    bgview.frame = CGRectMake(0, bgviewY-40, SCREEN_WIDTH,40);
    
    //提示标题
    UILabel *titleLabel = [[UILabel alloc] init];
    self.userNick = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"姓名:";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    CGFloat margin = 20;
    CGFloat labW = (SCREEN_WIDTH - margin*3);
    titleLabel.frame = CGRectMake(margin, 5,SCREEN_WIDTH - margin*3, 25);
    [bgview addSubview:titleLabel];
    
    //提示标题
    //    UILabel *detilLabel = [[UILabel alloc] init];
    //    self.userAcount = detilLabel;
    //    detilLabel.textAlignment = NSTextAlignmentRight;
    //    detilLabel.numberOfLines = 0;
    //    detilLabel.text = @"ID:";
    //    detilLabel.textColor = [UIColor darkGrayColor];
    //    detilLabel.font = [UIFont systemFontOfSize:15];
    //    CGFloat detilLabelX = SCREEN_WIDTH - margin*2 -labW;
    //    detilLabel.frame = CGRectMake(detilLabelX, 5, labW, 25);
    //    [bgview addSubview:detilLabel];
    
    [headView addSubview:bgview];
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:headView];
    //头像添加手势
    //UITapGestureRecognizer *iconViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewTapClick)];
    //[headView.iconView.iconImageView addGestureRecognizer:iconViewTap];
    
}


- (void)setupFooter
{
    UIView *footView = [[UIView alloc] init];
    
    UIButton *logout = [[UIButton alloc] init];
    // 2.设置属性
    logout.layer.cornerRadius = 5;
    logout.clipsToBounds = YES;
    logout.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置背景颜色的话占满屏幕
    logout.backgroundColor = LOGINCLOLOR;
    // 设置背景
    logout.frame = CGRectMake(20, 15, SCREEN_WIDTH-40, 35);
    [footView addSubview:logout];
    // 1.创建按钮
    self.tableView.tableFooterView = footView;
    footView.height = 55;
    
}

//退出登录按钮事件处理
- (void)logoutBtnClick
{
    //退出登录
    //    [GolbalManager sharedManager].isLogin = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LMLoginController *login = [[LMLoginController alloc] init];
    YWNavViewController *nav = [[YWNavViewController alloc] initWithRootViewController:login];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    
    return self.titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YWProfileViewCell *cell = [YWProfileViewCell cellWithTableView:tableView];
    
    cell.titleLabel.text = self.titleArr[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击cell的跳转处理
    
    if (indexPath.row == 0) {
        //关于我们
        YWAboutUsController *aboutUs = [[YWAboutUsController alloc] init];
        
        [self.navigationController pushViewController:aboutUs animated:YES];
        
    } else if (indexPath.row == 1){
        //意见反馈
        
        
        YWAdviceController *advice = [[YWAdviceController alloc] init];
        
        [self.navigationController pushViewController:advice animated:YES];
        
    }else if (indexPath.row == 2){
        
        
        //分享
        YWShareController *share = [[YWShareController alloc] init];
        [self.navigationController pushViewController:share animated:YES];
        
        //检查更新
        //        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        //
        //        NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
        //        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kStoreAppId]];
        //        NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        //
        //        NSRange substr = [file rangeOfString:@"\"version\":\""];
        //        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        //        NSRange substr2 =[file rangeOfString:@"\"" options:nil range:range1];
        //        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
        //        NSString *newVersion =[file substringWithRange:range2];
        //            if(![nowVersion isEqualToString:newVersion])
        //            {
        //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
        //                [alert show];
        //            }else{
        //弹框提示不需要更新
        
        //
        //        [SVProgressHUD showWithStatus:@"正在检查版本信息"];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //             [SVProgressHUD showInfoWithStatus:@"当前已是最新版本"];
        //        });
        
        
        //    }
    }
    //    else if (indexPath.row == 3){
    //        //分享
    //        YWShareController *share = [[YWShareController alloc] init];
    //        [self.navigationController pushViewController:share animated:YES];
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//移除通知
- (void)dealloc
{
    [YWNotificationCenter removeObserver:self];
}


@end
