//
//  YWServiceSuportController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWServiceSuportController.h"
#import "YWSupportLineCell.h"
#import "YWSupportPhoneCell.h"
#import "YWSupportGroup.h"
#import "YWSercice.h"
#import "YWOnlineInfo.h"
#import "YWEmployeeInfo.h"
#import "YWBrandInfo.h"
#import "YWBrandDetil.h"
#import "YWBrandCoreOne.h"
#import "YWBrandCoreTwo.h"

@interface YWServiceSuportController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *onlines;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) YWSupportGroup *supportGroup;

/** NSTimer */
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YWServiceSuportController
/**懒加载*/
- (NSMutableArray *)onlines
{
    if (!_onlines) {
        _onlines = [NSMutableArray array];
    }
    return _onlines;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    // 首先自动刷新一次
    [self autoRefresh];
    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    //删除系统分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.onlines = [NSMutableArray array];
        [self getServiceSupport];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getServiceSupport];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServiceSupport
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/service_hotline.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    //电站
    if (self.a_id) {
        params[@"a_id"] = self.a_id;
    } else {
        params[@"a_id"] = self.deviceSercice.a_id;
    };
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceSupport--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.supportGroup = [YWSupportGroup mj_objectWithKeyValues:dict];
            
            NSMutableArray *onlineArr = [[NSMutableArray alloc] init];
            
            for (YWOnlineInfo *lineInfo in self.supportGroup.online) {
                [onlineArr addObject:lineInfo];
            }
            self.onlines = onlineArr;
            //获得模型数据
            [self.tableView reloadData];
            /**停止刷新*/
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }
        
    } failure:^(NSError *error) {
        /**停止刷新*/
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1){
        return 4;
    }else {
        return self.onlines.count;
        
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        YWOnlineInfo *onlineModel = self.onlines[indexPath.row];
        
        
        //技术支持类型
        YWSupportLineCell *cell = [YWSupportLineCell cellWithTableView:tableView];
        
        cell.didTapQQBtn = ^{
            NSURL *url = [NSURL URLWithString:@"mqq://"];
            //是否安装QQ
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
                NSString *QQ = onlineModel.qq;
                //调用QQ客户端,发起QQ临时会话
                NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"未安装QQ"];
            }
            YWLog(@"qq-点击啦qq按钮");
        };
        cell.didTapWeChatBtn = ^{
//            
//            NSURL *url = [NSURL URLWithString:@"weixin://"];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }else{
//                
//                [SVProgressHUD showErrorWithStatus:@"未安装微信"];
//                NSLog(@"no---");
//                
//            }
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = onlineModel.weixin;
            [SVProgressHUD showSuccessWithStatus:@"微信号已复制至剪切板"];

            YWLog(@"weChat-点击啦微信按钮");
        };
        
        cell.didTapMsgBtn = ^{
            
//            NSURL *url = [NSURL URLWithString:@"mailto://"];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                [[UIApplication sharedApplication] openURL:url];
//            }else{
//                
//                [SVProgressHUD showErrorWithStatus:@"未打开邮件"];
//                NSLog(@"no---");
//                
//            }

            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = onlineModel.email;
            [SVProgressHUD showSuccessWithStatus:@"邮箱号已复制至剪切板"];
            YWLog(@"msg-点击啦短信按钮");
        };
        
        cell.onlineInfo = self.onlines[indexPath.row];
        return cell;
    }
    
    //创建在线支持cell
    YWSupportPhoneCell *cell = [YWSupportPhoneCell cellWithTableView:tableView];
    //拨打电话处理    
    [cell setDidNamePhoneLab:^(UILabel *label){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",label.text]];
        
        [[UIApplication sharedApplication] openURL:url];
    }];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //第一区第一行
            cell.supportLab.text = [NSString stringWithFormat:@"%@  %@",self.supportGroup.employee.department,self.supportGroup.employee.contact];
            cell.namePhone.text = self.supportGroup.employee.mobile;
        } else if (indexPath.row == 1){
            //第一区第二行
            cell.supportLab.text = @"固定电话";
            cell.namePhone.text = self.supportGroup.employee.Telephone;
            
        }
    } else if (indexPath.section == 1){
            //第二区
        if (indexPath.row == 0) {
            //第一区第一行
            cell.supportLab.text = [NSString stringWithFormat:@"%@",self.supportGroup.brand.brand.company];
            cell.namePhone.text = self.supportGroup.brand.brand.mobile;
        } else if (indexPath.row == 1){
            //第一区第二行
            cell.supportLab.text = [NSString stringWithFormat:@"%@",self.supportGroup.brand.core1.company];
            cell.namePhone.text = self.supportGroup.brand.core1.mobile;
        }else if (indexPath.row == 2){
            //第一区第三行
            cell.supportLab.text = [NSString stringWithFormat:@"%@",self.supportGroup.brand.core2.company];
            cell.namePhone.text = self.supportGroup.brand.core2.mobile;
        }else if (indexPath.row == 3){
            //第一区第四行
            cell.supportLab.text = @"热线电话";
            cell.namePhone.text = self.supportGroup.brand.hotline;
        }

    }
    
    return cell;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = BGCLOLOR;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = FONT_15;
    if(section == 0) {
        titleLab.text = @"内部技术支持";
    }else if (section == 1){
        titleLab.text = @"制造商支持";
    }else if (section == 2){
        titleLab.text = @"在线支持";
    }

    [bgview addSubview:titleLab];
    return bgview;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果点击的是其他行执行跳转到服务详情
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


@end
