//
//  YWDeviceInfoController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceInfoController.h"
#import "YWDeviceInfoCell.h"
#import "YWMyDevice.h"
#import "YWDeviceInfo.h"

@interface YWDeviceInfoController ()
/** 最新主播列表 */
//@property(nonatomic, strong) NSMutableArray *deviceInfo;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/**设备信息*/
@property (nonatomic, strong) YWDeviceInfo *deviceInfo;

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *deviceDetils;
/** 色标 */
@property(nonatomic, strong) NSArray *titles;


@end

@implementation YWDeviceInfoController
- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"设备名称",@"设备类型",@"设备型号",@"设备规格",@"制造日期",@"出厂编号",@"制造商",@"核心组件",@"组件型号",@"组件规格",@"出厂编号",@"制造商",@"核心组件",@"组件型号",@"组件规格",@"出厂编号",@"制造商"];
    }
    return _titles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    设备信息

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
        //self.deviceDetils = [NSMutableArray array];
        [self getDeviceInfo];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getDeviceInfo];
    }];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}


//发送请求获取网络数据
- (void)getDeviceInfo
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_info.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"a_id"] = self.a_id;    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        
        YWLog(@"getDeviceInfo--%@",responseObj);
        NSArray *deviceInfoDict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];

        if ([status isEqual:@1]) { // 数据已经加载完毕, 没有更多数据了
            YWDeviceInfo *deviceInfo = [YWDeviceInfo mj_objectWithKeyValues:deviceInfoDict];
           
            NSMutableArray *detilArr = [[NSMutableArray alloc] init];
            [detilArr addObject:ADDOBJECT(deviceInfo.assets_name)];
            [detilArr addObject:ADDOBJECT(deviceInfo.class_name)];
            [detilArr addObject:ADDOBJECT(deviceInfo.assets_model)];
            [detilArr addObject:ADDOBJECT(deviceInfo.specification_name)];
            [detilArr addObject:ADDOBJECT(deviceInfo.core_date_1)];
            [detilArr addObject:ADDOBJECT(deviceInfo.assets_number)];
            [detilArr addObject:ADDOBJECT(deviceInfo.brand_name)];

            //核心组件1
            [detilArr addObject:ADDOBJECT(deviceInfo.core_name_1)];
            
            [detilArr addObject:ADDOBJECT(deviceInfo.core_model_1)];
            [detilArr addObject:ADDOBJECT(deviceInfo.core_specifications_1)];
            [detilArr addObject:ADDOBJECT(deviceInfo.core_id_1)];
            [detilArr addObject:ADDOBJECT(deviceInfo.com_1)];

            //核心组件2
            [detilArr addObject:ADDOBJECT(deviceInfo.core_name_2)];
            [detilArr addObject:ADDOBJECT(deviceInfo.core_model_2)];
            
#warning mark-TODO返回空数据
            if (deviceInfo.core_specifications_2) {
                [detilArr addObject:deviceInfo.core_specifications_2];
            }else{
                [detilArr addObject:@"null"];
            }

            [detilArr addObject:ADDOBJECT(deviceInfo.core_id_2)];
            [detilArr addObject:ADDOBJECT(deviceInfo.com_2)];
 
            self.deviceDetils = detilArr;
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
    return self.titles.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建cell
    YWDeviceInfoCell *cell = [YWDeviceInfoCell cellWithTableView:tableView];
    //设置数据
    cell.titleLab.text = self.titles[indexPath.row];
    cell.detilLab.text = self.deviceDetils[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 ||indexPath.row == 7 ||indexPath.row == 12) {
        
        return 40;
    }
    
    return 30;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
