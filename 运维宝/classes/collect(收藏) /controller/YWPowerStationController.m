//
//  YWPowerStationController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWPowerStationController.h"
#import "YWSataionDetilController.h"
#import "YWMyStationCell.h"
#import "YWMyStations.h"

@interface YWPowerStationController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *myStations;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

/** NSTimer */
@property (nonatomic, strong) YWMyStations *stations;
@end

@implementation YWPowerStationController
/**懒加载*/
- (NSMutableArray *)myStations
{
    if (!_myStations) {
        _myStations = [NSMutableArray array];
    }
    return _myStations;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 首先自动刷新一次
    [self autoRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的电站";
    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    // 监听收藏状态改变的通知

    [YWNotificationCenter addObserver:self selector:@selector(collectStateChange) name:YWCollectStateChangeNotification object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)collectStateChange
{
    //收藏变化时通知刷新页面
    
    [self autoRefresh];
    
    [self.myStations removeAllObjects];
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
    NSString *urlStr = @"/user_collection_station.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"收藏getMyStations--%@",responseObj);
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
    //创建cell
    YWMyStationCell *cell = [YWMyStationCell cellWithTableView:tableView];
    //传递模型数据
    cell.stations = self.myStations[indexPath.row];
    
    return cell;
}

#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 36;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //电站详情
    YWSataionDetilController *stationDetil = [[YWSataionDetilController alloc] init];
    
    YWMyStations *stataion = self.myStations[indexPath.row];
    stationDetil.s_id = stataion.s_id;
    stationDetil.station = stataion;
    [self.navigationController pushViewController:stationDetil animated:YES];
    
}


@end
