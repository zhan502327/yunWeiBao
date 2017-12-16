//
//  YWSataionDetilController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/21.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSataionDetilController.h"
#import "YWStationDeviceListController.h"
#import "YWSationHeadCell.h"
#import "YWStationDetilCell.h"
#import "YWMyStations.h"
#import "YWDeviceDetilInfo.h"
#import "YWDeviceDetil.h"

@interface YWSataionDetilController ()<YWSationHeadCellDelegate>

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/** 我的设备 */
@property(nonatomic, strong) NSMutableArray *myStations;

/** 我的设备 */
@property(nonatomic, strong) YWDeviceDetilInfo *deviceDetilnfo;

/** 我的设备 */
@property(nonatomic, strong) NSMutableArray *deviceDetils;

 

@end

@implementation YWSataionDetilController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的电站";
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
        self.myStations = [NSMutableArray array];
        [self getMyStation];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getMyStation];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getMyStation
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_station_info.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    if (self.s_id) {
        params[@"s_id"] = self.s_id;
    }else{
        params[@"s_id"] = self.station.station_id;
    }
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"getMyStations--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            YWDeviceDetilInfo *deviceInfo = [YWDeviceDetilInfo mj_objectWithKeyValues:dict];
            
            self.deviceDetilnfo = deviceInfo;
            NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
            for (YWDeviceDetil *deviceDetil in deviceInfo.data) {
                [deviceArr addObject:deviceDetil];
            }
            //添加的数组
            self.deviceDetils = deviceArr;
            //获得模型数据
            [self.tableView reloadData];

            
        }
        
        /**停止刷新*/
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
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
    
    
    return self.deviceDetils.count+1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    
    if (indexPath.row == 0) {
        YWSationHeadCell *cell = [YWSationHeadCell cellWithTableView:tableView];
        cell.collectBtnDidClick = ^{
            //发送请求
           
            YWLog(@"收藏按钮----");
        };
        cell.delegate = self;
        cell.titleLab.text = self.station.station_name;
        cell.detilInfo = self.deviceDetilnfo;
        return cell;
    }
    //电站详情cell
    YWStationDetilCell *cell = [YWStationDetilCell cellWithTableView:tableView];
    cell.deviceBtnDidClick = ^(NSInteger *status) {
        YWStationDeviceListController *stationDevice = [[YWStationDeviceListController alloc] init];
        if (self.s_id) {
            stationDevice.s_id = self.s_id;
        }else{
            stationDevice.s_id = self.station.station_id;
        }
        stationDevice.status = status;
        //取出设备码
        YWDeviceDetil *detilCode = self.deviceDetils[indexPath.row-1];
        stationDevice.deviceCode = detilCode.class_code;
        [self.navigationController pushViewController:stationDevice animated:YES];
    };
    
    //设置数据
    cell.deviceDetil = self.deviceDetils[indexPath.row-1];
    return cell;
}
#pragma mark-stationHeaderCelldelegate
- (void)collectionBtnClick:(YWSationHeadCell *)sationHeadCell
{
    sationHeadCell.collectView.selected = !sationHeadCell.collectView.selected;

    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_station_collect.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    if (self.s_id) {
        params[@"s_id"] = self.s_id;
    }else{
        params[@"s_id"] = self.station.station_id;
    }
  
    //判断当前电站是否收藏
    if ([self.deviceDetilnfo.is_collection isEqual:@1]) {
        params[@"act"] = @"del";
    }else{
        params[@"act"] = @"add";
    }
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        
        
        YWLog(@"getMyStations--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            //请求成功要做的事
            
            if (sationHeadCell.collectView.selected) {
                        [sationHeadCell.collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_yishouchang"] forState:UIControlStateSelected];
                    } else {
                        [sationHeadCell.collectView setBackgroundImage:[UIImage imageNamed:@"activity_wodedianzhan_shouchang"] forState:UIControlStateNormal];
                    }
            
            
            //[SVProgressHUD showInfoWithStatus:msg];
            //发出通知
            [YWNotificationCenter postNotificationName:YWCollectStateChangeNotification object:nil];
            
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


#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 80;
    }
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
