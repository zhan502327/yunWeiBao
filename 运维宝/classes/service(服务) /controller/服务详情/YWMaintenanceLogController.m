//
//  YWMaintenanceLogController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWMaintenanceLogController.h"
#import "YWMaintenanceLogDetilController.h"
#import "YWMaintenancelLogCell.h"
#import "YWSercice.h"
#import "YWMaintenanceLog.h"
@interface YWMaintenanceLogController ()
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *maintenanceLogs;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YWMaintenanceLogController

/**懒加载*/
- (NSMutableArray *)maintenanceLogs
{
    if (!_maintenanceLogs) {
        _maintenanceLogs = [NSMutableArray array];
    }
    return _maintenanceLogs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        self.maintenanceLogs = [NSMutableArray array];
        [self getServiceMaintenanceLog];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getServiceMaintenanceLog];
    }];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServiceMaintenanceLog{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/service_record.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    if (self.a_id) {
        params[@"a_id"] = self.a_id;
    } else {
        params[@"a_id"] = self.deviceSercice.a_id;
    };
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceMaintenanceLog--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.maintenanceLogs = [YWMaintenanceLog mj_objectArrayWithKeyValuesArray:dict];
            
            //获得模型数据
            [self.tableView reloadData];
            /**停止刷新*/
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }else{
            
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
    
    return self.maintenanceLogs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    YWMaintenancelLogCell *cell = [YWMaintenancelLogCell cellWithTableView:tableView];
    //传递模型
    cell.maintenanceLog = self.maintenanceLogs[indexPath.row];
    //返回cell
    return cell;
}

#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到日志详情
    YWMaintenanceLogDetilController *maintenanceLogDetil = [[YWMaintenanceLogDetilController alloc] init];
    YWMaintenanceLog *maintenanceLog = self.maintenanceLogs[indexPath.row];
    maintenanceLogDetil.is_dispose = maintenanceLog.is_dispose;
    maintenanceLogDetil.r_id = maintenanceLog.r_id;
    
    [self.navigationController pushViewController:maintenanceLogDetil animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
