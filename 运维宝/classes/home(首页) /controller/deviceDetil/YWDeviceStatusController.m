//
//  YWDeviceStatusController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceStatusController.h"
#import "YWDeviceSatusCell.h"
#import "YWDeviceTempCell.h"
#import "YWMyDevice.h"
#import "YWDeviceStatusInfo.h"
#import "YWDeviceStatus.h"
#import "YWDeviceTemp.h"
#import "YWDeviceTempInfo.h"

@interface YWDeviceStatusController ()<UITableViewDelegate,UITableViewDataSource>

/**状态监测图*/
@property (nonatomic,weak) UIView *statusView;
/**温升历史曲线*/
@property (nonatomic,weak) UIView *temHistoryView;


/**状态监测*/
@property (nonatomic,strong) UITableView *statusTableView;
/**温升历史*/
@property (nonatomic,strong) UITableView *tempTableView;

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *devices;


/** 状态检测 */
@property(nonatomic, strong) YWDeviceStatus *deviceStatus;

/** 温度检测 */
@property(nonatomic, strong) YWDeviceTemp *deviceTemp;

@end

@implementation YWDeviceStatusController
//状态
//- (NSMutableArray*)devices
//{
//    if (!_devices) {
//        _devices = [[NSMutableArray  alloc] init];
//    }
//    return _devices;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取设备详情
    [self getDeviceDetil];
    
    //状态监测图
    [self setupStatusView];
    //温升历史曲线
    [self setupTemHostoryView];
    
    
}



//发送请求获取网络数据
- (void)getDeviceDetil
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_status_monitor.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"a_id"] = self.a_id;
    
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *statusDict = responseObj[@"data"][@"status"];
        
        NSArray *temperatureDict = responseObj[@"data"][@"temperature"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        //YWLog(@"设备列表--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            //状态
            self.deviceStatus = [YWDeviceStatus mj_objectWithKeyValues:statusDict];
            //温升
            self.deviceTemp = [YWDeviceTemp mj_objectWithKeyValues:temperatureDict];
            //获得模型数据
            [self.statusTableView reloadData];
            [self.tempTableView reloadData];
            /**停止刷新*/
            //[self.tableView.mj_header endRefreshing];
            //[self.tableView.mj_footer endRefreshing];
            
        }
        
    } failure:^(NSError *error) {
        /**停止刷新*/
        //[self.tableView.mj_header endRefreshing];
        //[self.tableView.mj_footer endRefreshing];
    }];
    
}


//状态监测
- (void)setupStatusView
{
    
    //创建状态监测view
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.33)];
    
    CGFloat statusBtnW = (SCREEN_WIDTH-40)/3;
    CGFloat statusTabViewW = SCREEN_WIDTH-40;
    CGFloat statusTabViewH = SCREEN_HEIGHT*0.33-50;
    // 设置左边色标和名称
    UIButton *statusBtn1 = [[UIButton alloc] init];
    statusBtn1.userInteractionEnabled = NO;
    statusBtn1.titleLabel.font = FONT_14;
    
    statusBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [statusBtn1 setTitle:@"状态监测" forState:UIControlStateNormal];
    [statusBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [statusBtn1 setImage:[UIImage imageNamed:@"icondyq1"] forState:UIControlStateNormal];
    statusBtn1.frame = CGRectMake(0,15,statusBtnW, 20);
    [statusView addSubview:statusBtn1];
    
    UIButton *statusBtn2 = [[UIButton alloc] init];
    statusBtn2.userInteractionEnabled = NO;
    statusBtn2.titleLabel.font = FONT_14;
    
    statusBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [statusBtn2 setTitle:@"合闸状态" forState:UIControlStateNormal];
    [statusBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [statusBtn2 setImage:[UIImage imageNamed:@"icondyq2"] forState:UIControlStateNormal];
    statusBtn2.frame = CGRectMake(statusBtnW-10,15,statusBtnW, 20);
    [statusView addSubview:statusBtn2];
    
    UIButton *statusBtn3 = [[UIButton alloc] init];
    statusBtn3.userInteractionEnabled = NO;
    statusBtn3.titleLabel.font = FONT_14;
    
    statusBtn3.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [statusBtn3 setTitle:@"带载合闸次数" forState:UIControlStateNormal];
    [statusBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [statusBtn3 setImage:[UIImage imageNamed:@"num"] forState:UIControlStateNormal];
    statusBtn3.frame = CGRectMake(statusBtnW*2-10,15,statusBtnW+20, 20);
    [statusView addSubview:statusBtn3];
    
    
    
    //表格控件
    self.statusTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 45,statusTabViewW, statusTabViewH) style:UITableViewStylePlain];
    self.statusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.statusTableView.backgroundColor = TABLEVIEWBGCLOLOR;
    self.statusTableView.dataSource = self;
    self.statusTableView.delegate = self;
    self.statusTableView.scrollEnabled = NO;
    self.statusTableView.layer.borderWidth = 4;
    self.statusTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    statusView.backgroundColor  = MAINBGCLOLOR;
    self.statusView = statusView;
    [self.statusView addSubview:self.statusTableView];
    [self.view addSubview:statusView];
    
}

//温升监测
- (void)setupTemHostoryView
{
    
    CGFloat temHistoryViewY = CGRectGetMaxY(self.statusView.frame)+10;
    UIView *temHistoryView = [[UIView alloc] initWithFrame:CGRectMake(10,temHistoryViewY, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.33)];
    
    CGFloat temHistoryBtnW = (SCREEN_WIDTH-40)/3;
    
    // 设置左边色标和名称
    UIButton *temHistoryBtn1 = [[UIButton alloc] init];
    temHistoryBtn1.userInteractionEnabled = NO;
    temHistoryBtn1.titleLabel.font = FONT_14;
    
    temHistoryBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [temHistoryBtn1 setTitle:@"温升监测" forState:UIControlStateNormal];
    [temHistoryBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [temHistoryBtn1 setImage:[UIImage imageNamed:@"icondyq1"] forState:UIControlStateNormal];
    temHistoryBtn1.frame = CGRectMake(0,15,temHistoryBtnW, 20);
    [temHistoryView addSubview:temHistoryBtn1];
    
    UIButton *temHistoryBtn2 = [[UIButton alloc] init];
    temHistoryBtn2.userInteractionEnabled = NO;
    temHistoryBtn2.titleLabel.font = FONT_14;
    
    temHistoryBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [temHistoryBtn2 setTitle:@"环境温度" forState:UIControlStateNormal];
    [temHistoryBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [temHistoryBtn2 setImage:[UIImage imageNamed:@"activity_wodedianzhan_wendu"] forState:UIControlStateNormal];
    temHistoryBtn2.frame = CGRectMake(temHistoryBtnW*2+10,15,temHistoryBtnW, 20);
    [temHistoryView addSubview:temHistoryBtn2];
    
    //表格控件
    CGFloat tempTabViewW = SCREEN_WIDTH-40;
    CGFloat tempTabViewH = SCREEN_HEIGHT*0.33-50;
    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 45,tempTabViewW, tempTabViewH) style:UITableViewStylePlain];
    self.tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tempTableView.backgroundColor = TABLEVIEWBGCLOLOR;
    self.tempTableView.dataSource = self;
    self.tempTableView.delegate = self;
    self.tempTableView.scrollEnabled = NO;
    self.tempTableView.layer.borderWidth = 4;
    self.tempTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [temHistoryView addSubview:self.tempTableView];
    
    temHistoryView.backgroundColor = MAINBGCLOLOR;
    self.temHistoryView = temHistoryView;
    [self.view addSubview:temHistoryView];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.statusTableView) {
        
        YWDeviceSatusCell *cell = [YWDeviceSatusCell cellWithTableView:tableView];
        
        //设置数据
        if (indexPath.row == 0) {
            
            cell.statusBtn.hidden = YES;
            
        }else if (indexPath.row == 1) {
            cell.statusInfo = self.deviceStatus.close;
            [cell.statusBtn setTitle:@"合闸" forState:UIControlStateNormal];
            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq2"] forState:UIControlStateNormal];
            
        }else if (indexPath.row == 2) {
            cell.statusInfo = self.deviceStatus.open;
            [cell.statusBtn setTitle:@"分闸" forState:UIControlStateNormal];
            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq3"] forState:UIControlStateNormal];
        }else if (indexPath.row == 3) {
            cell.statusInfo = self.deviceStatus.storage;
            [cell.statusBtn setTitle:@"储能" forState:UIControlStateNormal];
            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq4"] forState:UIControlStateNormal];
            
        }
        
        return cell;
        
    } else {
        
        YWDeviceTempCell *cell = [YWDeviceTempCell cellWithTableView:tableView];
        //设置数据
        if (indexPath.row == 0) {
            cell.statusBtn.hidden = YES;
        }else if (indexPath.row == 1) {
            cell.tempInfo = self.deviceTemp.up;
            [cell.statusBtn setTitle:@"上触指" forState:UIControlStateNormal];
            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq8"] forState:UIControlStateNormal];
        }else if (indexPath.row == 2) {
            cell.tempInfo = self.deviceTemp.down;
            [cell.statusBtn setTitle:@"下触指" forState:UIControlStateNormal];
            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq8"] forState:UIControlStateNormal];
        }else if (indexPath.row == 3) {
            cell.tempInfo = self.deviceTemp.connect;
            [cell.statusBtn setTitle:@"电缆头" forState:UIControlStateNormal];
            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq9"] forState:UIControlStateNormal];
        }

        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    
    return 30;

}
@end
