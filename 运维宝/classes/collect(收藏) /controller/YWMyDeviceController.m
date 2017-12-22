//
//  YWMyDeviceController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWMyDeviceController.h"
#import "YWDeviceDetilController.h"
#import "YWMyDeviceCell.h"
#import "YWMyDevice.h"
@interface YWMyDeviceController ()

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/** 我的设备 */
@property(nonatomic, strong) NSMutableArray *myDevices;

/** NSTimer */
@property (nonatomic, strong) YWMyDevice *myDevice;

@end

@implementation YWMyDeviceController

/**懒加载*/
- (NSMutableArray *)myDevices
{
    if (!_myDevices) {
        _myDevices = [NSMutableArray array];
    }
    return _myDevices;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 首先自动刷新一次
    [self autoRefresh];
    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    
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
        self.myDevices = [NSMutableArray array];
        [self getMyDevices];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getMyDevices];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getMyDevices
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/user_collection_assets.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"getMyStations--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.myDevices = [YWMyDevice mj_objectArrayWithKeyValuesArray:dict];
            
            YWLog(@"getDeviceList-%@",self.myDevices);
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
    
    return self.myDevices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //创建cell
    YWMyDeviceCell *cell = [YWMyDeviceCell cellWithTableView:tableView];
    
    //传递模型数据
    cell.myDevice = self.myDevices[indexPath.row];
    //返回cell
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
    //传递当前行的模型数据
    YWMyDevice *device  = self.myDevices[indexPath.row];
    deviceDetil.a_id = device.a_id;

    deviceDetil.colorStatus = device.status;
    
    //deviceDetil.is_collection = device.
    deviceDetil.stationName = device.name;
    [self.navigationController pushViewController:deviceDetil animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
