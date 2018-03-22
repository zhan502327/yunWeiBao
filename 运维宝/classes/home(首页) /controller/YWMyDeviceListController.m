//
//  YWMyDeviceListController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWMyDeviceListController.h"
#import "YWDeviceDetilController.h"
#import "YWMyDeviceCell.h"
#import "YWMyDevice.h"

@interface YWMyDeviceListController ()
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *devices;
/** 当前页 */
@property(nonatomic, assign) NSInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation YWMyDeviceListController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.title = @" ";

    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    
    
    // 首先自动刷新一次
    [self autoRefresh];
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
        self.devices = [NSMutableArray array];
        [self getDeviceList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getDeviceList];
    }];
    
}

/*/Users/jiabin/Desktop/运维宝(测试版)/运维宝/classes/home(首页) /controller/YWMyDeviceListController.m*自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getDeviceList
{
    //组装参数
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_list.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"status"] = self.status;
    //请求数据
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"设备列表--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            self.devices = [YWMyDevice mj_objectArrayWithKeyValuesArray:dict];
         
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
    
    return self.devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YWMyDeviceCell *cell = [YWMyDeviceCell cellWithTableView:tableView];
    //传递模型数据
    YWMyDevice *device  = self.devices[indexPath.row];
//    device.status = self.status;
    cell.myDevice = device;
    return cell;
}

#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 36;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //执行跳转设备详情
    YWDeviceDetilController *deviceDetil = [[YWDeviceDetilController alloc] init];
    
    YWMyDevice *device  = self.devices[indexPath.row];
    deviceDetil.a_id = device.a_id;
    deviceDetil.colorStatus = device.status;
    deviceDetil.deviceInfo = device;
    
    deviceDetil.stationName = device.name;
    [self.navigationController pushViewController:deviceDetil animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
