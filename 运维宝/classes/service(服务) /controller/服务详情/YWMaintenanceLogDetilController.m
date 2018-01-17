//
//  YWMaintenanceLogDetilController.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWMaintenanceLogDetilController.h"
#import "YWMaintenancelLogCell.h"
#import "YWLogDetil.h"
#import "YWLogDetilCell.h"
#import "YWCheckBtnCell.h"
#import "YXTextView.h"
#import "YXTextfiledCell.h"

@interface YWMaintenanceLogDetilController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *logDetils;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/** 日志详情模型 */
@property (nonatomic, strong) YWLogDetil *logDetil;
/** 日志详情模型 */
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation YWMaintenanceLogDetilController
/**懒加载*/
- (NSMutableArray *)logDetils
{
    if (!_logDetils) {
        _logDetils = [NSMutableArray array];
    }
    return _logDetils;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"日志详情";

    //创建头部尾部
    
    [self setupFooter];
    [self setupFrenshHeaderandFooter];
    // 首先自动刷新一次
    [self autoRefresh];
    //删除系统分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setupFooter
{
    
    UIView *footView = [[UIView alloc] init];
     //创建按钮设置属性
    UIButton *logout = [[UIButton alloc] init];
    self.sureBtn = logout;
    logout.layer.cornerRadius = 5;
    logout.clipsToBounds = YES;
    logout.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [logout setTitle:@"确认" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置背景颜色的话占满屏幕
    logout.backgroundColor = LOGINCLOLOR;
    // 设置背景
    logout.frame = CGRectMake(20, 15, SCREEN_WIDTH-40, 35);
    [footView addSubview:logout];
    // 1.创建按钮
    self.tableView.tableFooterView = footView;
    footView.height = 55;
    
    //判断按钮是否隐藏
    if ([self.is_dispose isEqualToString:@"已完成"]) {
        logout.hidden = YES;
    } else if ([self.is_dispose isEqualToString:@"未完成"]){
        logout.hidden = NO;
    }

}

//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.logDetils = [NSMutableArray array];
        [self getServiceMaintenanceLogDetil];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getServiceMaintenanceLogDetil];
    }];
    
}

- (void)sureBtnClick
{
    
    YWLog(@"日志详情提交按钮");
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServiceMaintenanceLogDetil{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/service_record_info.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    //电站
    params[@"r_id"] = self.r_id;
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *detilDict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceMaintenanceLogDetil--%@",detilDict);
        if ([status isEqual:@1]) { // 数据
            
            self.logDetil = [YWLogDetil mj_objectWithKeyValues:detilDict];
            
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    if (indexPath.row == 5) {
        
         YWCheckBtnCell *cell = [YWCheckBtnCell cellWithTableView:tableView];
        //判断按钮是否隐藏
        cell.goodsLabel.textColor = [UIColor darkGrayColor];
        if ([self.is_dispose isEqualToString:@"已完成"]) {
            [cell.checkBtn setImage:[UIImage imageNamed:@"checkbox_select"] forState:UIControlStateNormal];
            cell.checkBtn.userInteractionEnabled = NO;
            cell.goodsLabel.text = @"已完成";
        } else if ([self.is_dispose isEqualToString:@"未完成"]){
            [cell.checkBtn setImage:[UIImage imageNamed:@"checkbox_noselect"] forState:UIControlStateNormal];
            //cell.checkBtn.userInteractionEnabled = YES;
            cell.goodsLabel.text = @"已完成";

        }

        return cell;
        
    }else if (indexPath.row == 0 || indexPath.row == 1) {
        
        YWLogDetilCell *cell = [YWLogDetilCell cellWithTableView:tableView];
        cell.textLabel.font = FONT_15;
        //传递模型
        if (indexPath.row == 0) {
            
            cell.typeLab.text = [NSString stringWithFormat:@"服务类型:%@",self.logDetil.repair_type_name];
            cell.nameLab.hidden = NO;
            cell.phoneLab.hidden = NO;
            cell.dateLab.text = self.logDetil.repair_date;
            cell.logDetilTv.text = self.logDetil.summary;
            cell.nameLab.text = [NSString stringWithFormat:@"报修人:%@",self.logDetil.contact];
            cell.phoneLab.text = [NSString stringWithFormat:@"电话:%@",self.logDetil.mobile];
           
            
        } else {
            
            cell.logDetilTv.userInteractionEnabled = YES;
            
            if ([self.is_dispose isEqualToString:@"已完成"]) {
                cell.logDetilTv.placeholder = nil;

            } else if ([self.is_dispose isEqualToString:@"未完成"]){
                cell.logDetilTv.placeholder = @"请输入内容";
            }
            cell.typeLab.text = @"维护记录";
            cell.dateLab.hidden = YES;
            cell.logDetilTv.text = self.logDetil.service_description;
            cell.nameLab.hidden = YES;
            cell.phoneLab.hidden = YES;
        }
        
        //返回cell
        return cell;
    }
    
    YXTextfiledCell *cell = [YXTextfiledCell cellWithTableView:tableView];
    cell.textLabel.font = FONT_15;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if ([self.is_dispose isEqualToString:@"已完成"]) {
        
        cell.textfield.hidden = YES;
        if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"人力资源:%@",self.logDetil.serivce_persons];
        } else if (indexPath.row == 3){
            cell.textLabel.text = [NSString stringWithFormat:@"工时耗损:%@",self.logDetil.service_hours];
        } else if (indexPath.row == 4){
            cell.textLabel.text = [NSString stringWithFormat:@"备件耗损:%@",self.logDetil.service_parts];
        }

    } else if ([self.is_dispose isEqualToString:@"未完成"]){
        cell.textfield.hidden = NO;
        if (indexPath.row == 2) {
            cell.textLabel.text = @"人力资源:";
        } else if (indexPath.row == 3){
            cell.textLabel.text = @"工时耗损:";
        } else if (indexPath.row == 4){
            cell.textLabel.text = @"备件耗损:";
        }

    }
    //取出模型赋值
    return cell;
}

#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 100;

    } else if (indexPath.row == 1){
        return 150;

    }
    return 30;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
