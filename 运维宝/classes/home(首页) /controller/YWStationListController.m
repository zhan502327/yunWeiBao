//
//  YWStationListController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/21.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWStationListController.h"
#import "YWSataionDetilController.h"
#import "YWMyStations.h"

@interface YWStationListController ()
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *myStations;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

/** NSTimer */
@property (nonatomic, strong) YWMyStations *stations;
@end

@implementation YWStationListController
/**懒加载*/
- (NSMutableArray *)myStations
{
    if (!_myStations) {
        _myStations = [NSMutableArray array];
    }
    return _myStations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电站列表";
    
    // 首先自动刷新一次
    [self autoRefresh];
    //创建头部尾部
    [self setupFrenshHeaderandFooter];

}
//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.myStations = [NSMutableArray array];
        [self getMyStations];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getMyStations];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getMyStations
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/my_stations.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        //YWLog(@"getMyStations--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.myStations = [YWMyStations mj_objectArrayWithKeyValuesArray:dict];
            
            //YWLog(@"getDeviceList-%@",self.myStations);
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
    return self.myStations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"stationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //取出模型赋值
    YWMyStations *station = self.myStations[indexPath.row];
    cell.textLabel.font = FONT_15;
    cell.textLabel.text = station.station_name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //电站详情
    YWSataionDetilController *stationDetil = [[YWSataionDetilController alloc] init];
    YWMyStations *station = self.myStations[indexPath.row];
    //发出通知保存用户电站信息
    [YWNotificationCenter postNotificationName:YWMystationChangeNotification object:nil userInfo:@{YWMystationChange:station}];
    stationDetil.s_id = station.s_id;
    stationDetil.station = station;
    
    [self.navigationController pushViewController:stationDetil animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
