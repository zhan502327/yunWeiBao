//
//  YWStationDeviceListController.m
//  运维宝
//
//  Created by 斌  on 2017/11/6.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWStationDeviceListController.h"
#import "YWDeviceDetilController.h"
#import "YWServiceCell.h"
#import "YWMyStations.h"
#import "YWSercice.h"
#import "YWMyDevice.h"

@interface YWStationDeviceListController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *services;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) YWSercice *service;
@end

@implementation YWStationDeviceListController

/**懒加载*/
- (NSMutableArray *)services
{
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设备列表";

    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    // 首先自动刷新一次
    [self autoRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //进页面发送请求
}

//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.services = [NSMutableArray array];
        [self getServices];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getServices];
    }];
    
}
/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServices
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_list.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    if (self.s_id) {
         params[@"s_id"] = self.s_id;
    }else{
        //如果SID没值，就从模型里面取
        params[@"s_id"] = self.station.station_id;
    }
    
    params[@"class_code"] = self.deviceCode;
    
    NSString *statusStr = [NSString stringWithFormat:@"%d",self.status];
    //状态码
    params[@"status"] = statusStr;
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [self.services removeAllObjects];
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        //YWLog(@"getServices--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.services = [YWSercice mj_objectArrayWithKeyValuesArray:dict];
            
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
    return self.services.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建cell
    YWServiceCell *cell = [YWServiceCell cellWithTableView:tableView];
    
    // Configure the cell...
    YWSercice *service = self.services[indexPath.row];
    service.status = self.status;
    cell.services = service;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果点击的是其他行执行跳转到服务详情
    YWDeviceDetilController *deviceDetil = [[YWDeviceDetilController alloc] init];
    //传递模型数据
    YWSercice *sevice  = self.services[indexPath.row];
    deviceDetil.a_id = sevice.a_id;
    deviceDetil.stationName = sevice.name;
    
#warning mark_TODO
    //deviceDetil.deviceInfo = sevice;
 
    
    //deviceDetil.stationName = device.name;
    [self.navigationController pushViewController:deviceDetil animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 36;
}

//移除通知
- (void)dealloc
{
    [YWNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
