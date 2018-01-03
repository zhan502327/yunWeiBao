//
//  YWLineHistoryController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/22.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWLineHistoryController.h"
#import "CBChartView.h"
#import "YWHistoryTempCell.h"
#import "YWMyDevice.h"
#import "YWDeviceTemp.h"
#import "JHChartHeader.h"
#import "SYLJDatePickerView.h"
#import "WSLineChartView.h"
#import "YWChartGroup.h"
#import "YXLineChartView.h"
#import "YXCustomDateView.h"
#import "YWChartLine.h"
#import "YXButtonViewCell.h"
//日期选择枚举
typedef NS_ENUM(NSInteger, YXDatePickerMode) {
    
        YXDatePickerModeHour, //年月日时
        YXDatePickerModeDay, //年月日
        YXDatePickerModeWeek, //第几周
        YXDatePickerModeMonth, //年月
        YXDatePickerModeQuarter, //季度
        YXDatePickerModeHalfYear, //半年
        YXDatePickerModeYear, //年

};

@interface YWLineHistoryController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,YXLineChartViewDataSource>
{
    
    
//    //connection
//    NSString *_urlInfo;
//    NSMutableString *_paraInfo;
//    NSMutableData *_listData;
//    NSOperationQueue *_queue;
//    NSURLConnection *_connection;
//    BOOL parsingError;
//    
//    //pickerview
//    NSMutableArray *_pickviewYearArray;
//    NSMutableArray *_pickviewMonthArray;
//    //pickerview的第一单元focus
//    NSInteger pick0compentfocusIndex;
//    NSInteger pick1compentfocusIndex;
//    NSInteger pick2compentfocusIndex;
//    NSInteger pick3compentfocusIndex;
//    
//    NSString *_NewbaseUrl;
    
    
}
/**日期枚举*/
@property (nonatomic,assign) YXDatePickerMode datePickerMode;
/**状态监测图*/
@property (nonatomic,weak) UIView *statusView;
/**温升历史曲线*/
@property (nonatomic,weak) UIView *temHistoryView;
/** 温度检测 */
@property(nonatomic, strong) YWDeviceTemp *deviceTemp;
/**温升历史*/
@property (nonatomic,strong) UITableView *tempTableView;
/**温升历史曲线*/
@property (strong, nonatomic) CBChartView *temChartView;
/**遮盖*/
@property (weak, nonatomic) UIView *cover;
/**遮盖*/
@property (weak, nonatomic) UIView *avgeLine;
/**遮盖*/
@property (weak, nonatomic) UIView *weekLine;
/**遮盖*/
@property (weak, nonatomic) UIView *dataLine;
/**温升历史*/
@property (nonatomic,strong) UITableView *avgeView;
/**温升历史*/
@property (nonatomic,strong) NSArray *avgeData;
/**温升历史*/
@property (nonatomic,strong) UITableView *weekView;
/**温升历史*/
@property (nonatomic,strong) NSArray *weakData;

/**温升历史*/
@property (nonatomic,strong) UIButton *avgeBtn;
/**温升历史*/
@property (nonatomic,strong) UIButton *weekBtn;
/**温升历史*/
@property (nonatomic,strong) UIButton *yearBtn;

/**平均值*/
@property (nonatomic,copy) NSString *avgeStr;
/**每周*/
@property (nonatomic,copy) NSString *weekStr;
/**每年*/
@property (nonatomic,copy) NSString *yearStr;

/**温升历史*/
@property (nonatomic,strong) NSMutableArray *charts;
/**温升历史*/
@property (nonatomic,strong) YWChartGroup *chartData;

/**曲线图的属性*/
@property (nonatomic,strong) NSMutableArray *colorArr;

//x轴数组
@property (nonatomic,strong) NSMutableArray *dataX;
//Y轴数组
@property (nonatomic,retain) NSArray *chartArr;

/**每年*/
@property (nonatomic,copy) NSString *strX;

/**每年*/
@property (nonatomic,assign) NSInteger index;


@end

@implementation YWLineHistoryController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.firststartsign = 0;
//
//    //温升历史曲线
//    [self setupTemHostoryView];
//    
//    //状态监测图
//    [self setupTempView];
//    
//    //获取设备温度信息
//    [self getDeviceDetil];
//  
//    [self.chartView refreshData];
//    
//    [self initSectionOneDate];
//    [self initSectionThirdDate];
//    [self initPickerViewDate];
//    [self createPickerView];
//    
//    NSDate *today = [NSDate date];
//    NSTimeZone* GMT8zone = [NSTimeZone timeZoneForSecondsFromGMT:28800]; //获取GMT8中国时差
//    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
//    dateFormater.timeZone = GMT8zone;
//    [dateFormater setDateFormat:@"YYYY"];
//    int year = [[dateFormater stringFromDate:today] intValue];
//    [dateFormater setDateFormat:@"MM"];
//    int month = [[dateFormater stringFromDate:today] intValue];
//    [dateFormater setDateFormat:@"dd"];
//    int day = [[dateFormater stringFromDate:today] intValue];
//    [dateFormater setDateFormat:@"HH"];
//    int hour = [[dateFormater stringFromDate:today] intValue];
//    
//    self.dateParams = [NSString stringWithFormat:@"&year=%d&month=%d&day=%d&hour=%d",year, month, day, hour];
//    self.preDateParams = [NSString stringWithString:self.dateParams];
//    
//    
//    //测试用的，需要修改参数的
//    self.getolddatasign = @"1"; //第一次进入设为1，读取最近有数据的日期的温度曲线
//    //[self begeinNetConnection:@"h"];
//    self.getolddatasign = @"2"; //随后设为2，码盘选择时间为所要读取的日期的温度曲线
//    //监听通知
//    [YWNotificationCenter addObserver:self selector:@selector(avegeChange:) name:YWAvegeValueDidChangeNotification object:nil];
//    
//    [YWNotificationCenter addObserver:self selector:@selector(weekChange:) name:YWWeekValueDidChangeNotification object:nil];
//    
//     [YWNotificationCenter addObserver:self selector:@selector(yearChange:) name:YWYearValueDidChangeNotification object:nil];
//
}
//
////用户模型数据
//- (void)avegeChange:(NSNotification *)notifacation
//{
//    //取出用户模型
//    NSString *avgeStr = notifacation.userInfo[YWAvegeValueDidChange];
//    self.avgeStr  = avgeStr;
//    //用户昵称
//    if (self.avgeStr) {
//        
//        [self getHistorycharData];
//        }
//    [self.chartView refreshData];
//
//    //[self.chartView reloadData];
//    //用户ID
//    YWLog(@"用户曲线数据-logUser%@",avgeStr);
//}
//- (void)weekChange:(NSNotification *)notifacation
//{
//    //取出用户模型
//    NSString *weekStr = notifacation.userInfo[YWWeekValueDidChange];
//    self.weekStr  = weekStr;
//    //用户昵称
//    
//    if (self.weekStr) {
//        
//        [self getHistorycharData];
//        
//        
//    }
//    [self.chartView refreshData];
//    //[self.chartView reloadData];
//    //用户ID
//    YWLog(@"用户曲线数据-logUser%@",weekStr);
//}
//
//- (void)yearChange:(NSNotification *)notifacation
//{
//    //取出用户模型
//    NSString *yearStr = notifacation.userInfo[YWYearValueDidChange];
//    self.yearStr  = yearStr;
//    //用户昵称
//    if (self.yearStr) {
//        
//        [self getHistorycharData];
//        
//            }
//    [self.chartView refreshData];
//
//    //[self.chartView reloadData];
//    //用户ID
//    YWLog(@"用户曲线数据-logUser%@",yearStr);
//}
//
////发送请求获取网络数据
//- (void)getDeviceDetil
//{
//    //组装参数
//    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
//    NSString *urlStr = @"/assets_status_monitor.php";
//    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
//    params[@"token"] = kGetData(@"token");
//    params[@"account_id"] = kGetData(@"account_id");
//    params[@"a_id"] = self.a_id;
//    
//    //请求数据
//    [HMHttpTool post:url params:params success:^(id responseObj) {
//        NSDictionary *statusDict = responseObj[@"data"][@"status"];
//        
//        NSArray *temperatureDict = responseObj[@"data"][@"temperature"];
//        NSString *status = responseObj[@"code"];
//        //NSString *msg = responseObj[@"tip"];
//        //YWLog(@"设备列表--%@",responseObj);
//        if ([status isEqual:@1]) { // 数据
//            
//            //温升
//            self.deviceTemp = [YWDeviceTemp mj_objectWithKeyValues:temperatureDict];
//            //获得模型数据
//            [self.tempTableView reloadData];
//            /**停止刷新*/
//            //[self.tableView.mj_header endRefreshing];
//            //[self.tableView.mj_footer endRefreshing];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        /**停止刷新*/
//        //[self.tableView.mj_header endRefreshing];
//        //[self.tableView.mj_footer endRefreshing];
//    }];
//
//    
//}
//
////发送请求获取曲线数据
//- (void)getHistorycharData
//{
//    //组装参数
//    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
//    NSString *urlStr = @"/assets_history.php";
//    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
//    params[@"a_id"] = self.a_id;
//    //说明是哪条曲线
//    params[@"num"] = @"1,2,3,4,5,6";
//    params[@"time"] = self.yearStr;
//    /**h小时 d天 w周 m月  hy半年 y年*/
//    //params[@"time"] = @"20171113";
//
//    YWLog(@"选中的时间getHistorycharData -- %@",self.yearStr);
//
//    /**avg平均 max最大 min最小*/
//    if ([self.avgeStr isEqualToString:@"平均"]) {
//        params[@"model"] = @"avg";
//    } else if ([self.avgeStr isEqualToString:@"最大"]){
//        params[@"model"] = @"max";
//    } else if ([self.avgeStr isEqualToString:@"最小"]){
//        params[@"model"] = @"min";
//    }
//    
//    /**h小时 d天 w周 m月  hy半年 y年*/
//    if ([self.weekStr isEqualToString:@"1小时"]){
//        params[@"type"] = @"h";
//    } else if ([self.weekStr isEqualToString:@"1天"]){
//        params[@"type"] = @"d";
//    } else  if ([self.weekStr isEqualToString:@"1周"]) {
//        params[@"type"] = @"w";
//    } else if ([self.weekStr isEqualToString:@"1个月"]){
//        params[@"type"] = @"m";
//    }else  if ([self.weekStr isEqualToString:@"3个月"]){
//        params[@"type"] = @"q";
//    }else  if ([self.weekStr isEqualToString:@"6个月"]){
//        params[@"type"] = @"hy";
//    }else  if ([self.weekStr isEqualToString:@"1年"]){
//        params[@"type"] = @"y";
//    }
//   
//     YWLog(@"曲线参数--%@",params);
//    //请求数据
//    [HMHttpTool post:url params:params success:^(id responseObj) {
//       
//        NSMutableDictionary *chartDict = responseObj[@"data"];
//        NSString *status = responseObj[@"code"];
//        NSString *msg = responseObj[@"tip"];
//        [SVProgressHUD showWithStatus:@"正在加载"];
//
//                if ([status isEqual:@1]) { // 数据
//                          //历史曲线数据
//            [self.charts removeAllObjects];
//            self.chartData = [YWChartGroup mj_objectWithKeyValues:chartDict];
//                    
//                NSMutableArray *chatArr = [[NSMutableArray alloc] init];
//                NSMutableArray *chatXArr = [[NSMutableArray alloc] init];
//
//                    //数组数据
//                    NSMutableArray  *chartArr1 = [[NSMutableArray  alloc] init];
//                    NSMutableArray  *chartXArr1 = [[NSMutableArray  alloc] init];
//
//                    for (YWChartLine *chart1 in self.chartData.chart1) {
//                       [chartArr1 addObject:chart1.y];
//                       [chartXArr1 addObject:chart1.x];
//
//                    }
//                    
//                    NSMutableArray  *chartArr2 = [[NSMutableArray  alloc] init];
//                    NSMutableArray  *chartXArr2 = [[NSMutableArray  alloc] init];
//
//                    for (YWChartLine *chart2 in self.chartData.chart2) {
//                       [chartArr2 addObject:chart2.y];
//                       [chartXArr2 addObject:chart2.x];
//
//                    }
//                    
//                    NSMutableArray  *chartArr3 = [[NSMutableArray  alloc] init];
//                    NSMutableArray  *chartXArr3 = [[NSMutableArray  alloc] init];
//
//                    for (YWChartLine *chart3 in self.chartData.chart3) {
//                       [chartArr3 addObject:chart3.y];
//                        [chartXArr3 addObject:chart3.x];
//
//                    }
//                    
//                    NSMutableArray  *chartArr4 = [[NSMutableArray  alloc] init];
//                    NSMutableArray  *chartXArr4 = [[NSMutableArray  alloc] init];
//                    for (YWChartLine *chart4 in self.chartData.chart4) {
//                       [chartArr4 addObject:chart4.y];
//                        [chartXArr4 addObject:chart4.x];
//
//                    }
//                    
//                    NSMutableArray  *chartArr5 = [[NSMutableArray  alloc] init];
//                    NSMutableArray  *chartXArr5 = [[NSMutableArray  alloc] init];
//                    for (YWChartLine *chart5 in self.chartData.chart5) {
//                        [chartArr5 addObject:chart5.y];
//                        [chartXArr5 addObject:chart5.x];
//
//                       
//                    }
//                    NSMutableArray  *chartArr6 = [[NSMutableArray  alloc] init];
//                    NSMutableArray  *chartXArr6 = [[NSMutableArray  alloc] init];
//
//                    for (YWChartLine *chart6 in self.chartData.chart6) {
//                        [chartArr6 addObject:chart6.y];
//                        [chartXArr6 addObject:chart6.x];
//
//                        
//                    }
//
//                //从后台取数据
//                    
//                    
//                    
//                [chatArr addObject:chartArr1];
//                [chatArr addObject:chartArr2];
//                [chatArr addObject:chartArr3];
//                [chatArr addObject:chartArr4];
//                [chatArr addObject:chartArr5];
//                [chatArr addObject:chartArr6];
//                    
// 
//                    
//                [chatXArr addObject:chartXArr1];
//                [chatXArr addObject:chartXArr2];
//                [chatXArr addObject:chartXArr3];
//                [chatXArr addObject:chartXArr4];
//                [chatXArr addObject:chartXArr5];
//                [chatXArr addObject:chartXArr6];
//                    
//            //六组线的数组
//            
//            self.charts = chatArr;
//            self.dataX = chatXArr;
//                    
//            self.chartView.chartYArr = self.charts;
//            self.chartView.chartXArr = self.dataX;
//                    
//            [self.chartView reloadData];
//            [self.chartView refreshData];
//                    
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [SVProgressHUD dismiss];
//                    
//                });
//                    
//            YWLog(@"曲线数据--%@",self.chartData);
//            YWLog(@"chartDict--%@",chartDict);
//                }else{
//            
//                    [SVProgressHUD showInfoWithStatus:msg];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [SVProgressHUD dismiss];
//
//                });
//                
//            }
//        
//    } failure:^(NSError *error) {
//        
//        YWLog(@"历史曲线--%@",error);
//        
//    }];
//    
//}
////温升历史曲线
//- (void)setupTemHostoryView
//{
//    //曲线图
//    UIView *temHistoryView = [[UIView alloc] initWithFrame:CGRectMake(10,0, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.48)];
//    temHistoryView.userInteractionEnabled = YES;
//    UIButton *temHistoryBtn = [[UIButton alloc] init];
//    temHistoryBtn.userInteractionEnabled = NO;
//    temHistoryBtn.titleLabel.font = FONT_14;
//    temHistoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
//    //temHistoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
//    [temHistoryBtn setTitle:@"温升曲线" forState:UIControlStateNormal];
//    [temHistoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [temHistoryBtn setImage:[UIImage imageNamed:@"icondyq1"] forState:UIControlStateNormal];
//    temHistoryBtn.frame = CGRectMake(10,10, 100, 18);
//    [temHistoryView addSubview:temHistoryBtn];
//    
//    //日期栏
//    UIView *dateBar = [[UIView alloc] init];
//    //dateBar.backgroundColor = [UIColor lightGrayColor];
//    CGFloat dateBarY = CGRectGetMaxY(temHistoryBtn.frame)+5;
//    dateBar.frame = CGRectMake(0,dateBarY, temHistoryView.width, 30);
//    //平均
//    UIButton *average = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.avgeBtn = average;
//    average.titleLabel.font = FONT_12;
//    average.layer.borderWidth = 0.8;
//    average.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [average setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [average addTarget:self action:@selector(averageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    CGFloat averageW = SCREEN_WIDTH*0.20;
//    average.frame = CGRectMake(YWMargin, 5, averageW, dateBar.height);
//    [average setTitle:@"平均" forState:UIControlStateNormal];
//    [average setTitle:@"确定" forState:UIControlStateSelected];
//    UIView *line1 = [[UIView alloc] init];
//    self.avgeLine = line1;
//    line1.backgroundColor = [UIColor lightGrayColor];
//    line1.frame = CGRectMake(0, 0, averageW, 3);
//    [average addSubview:line1];
//    [dateBar addSubview:average];
//    //每周
//    UIButton *weekBtn = [[UIButton alloc] init];
//    self.weekBtn = weekBtn;
//    weekBtn.titleLabel.font = FONT_12;
//    [weekBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
// 
//    [weekBtn addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    weekBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    weekBtn.layer.borderWidth = 0.8;
//    weekBtn.frame = CGRectMake(YWMargin+5+averageW, 5, averageW, dateBar.height);
//    [weekBtn setTitle:@"1小时" forState:UIControlStateNormal];
//    [weekBtn setTitle:@"确定" forState:UIControlStateSelected];
//    UIView *line2 = [[UIView alloc] init];
//    self.weekLine = line2;
//    line2.backgroundColor = [UIColor lightGrayColor];
//    line2.frame = CGRectMake(0, 0,averageW, 3);
//    [weekBtn addSubview:line2];
//    [dateBar addSubview:weekBtn];
//
//    //39周
//    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    allBtn.titleLabel.font = FONT_12;
//    self.yearBtn = allBtn;
//    [allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    allBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    allBtn.layer.borderWidth = 0.8;
//    CGFloat allBtnW = dateBar.width-averageW*2-YWMargin*2-10;
//    allBtn.frame = CGRectMake(YWMargin+10+averageW*2, 5, allBtnW, dateBar.height);
//    [allBtn addTarget:self action:@selector(allYearClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [allBtn setTitle:@"(UTC+8)2017 39周" forState:UIControlStateNormal];
//    [allBtn setTitle:@"确定" forState:UIControlStateSelected];
//    UIView *line3 = [[UIView alloc] init];
//    line3.backgroundColor = [UIColor lightGrayColor];
//    line3.frame = CGRectMake(0, 0, allBtnW, 3);
//    self.dataLine = line3;
//    [allBtn addSubview:line3];
//    [dateBar addSubview:allBtn];
//    [temHistoryView addSubview:dateBar];
//    
//    //加载曲线图
//    CGFloat lineChartY = CGRectGetMaxY(dateBar.frame)+15;
//    
//    CGRect rect = CGRectMake(-5,lineChartY,SCREEN_WIDTH-10, temHistoryView.height-lineChartY);
//    YXLineChartView *chartView = [[YXLineChartView alloc]initWithFrame:rect withYarr:self.charts andXarr:self.dataX];
//    self.chartView = chartView;
//    chartView.xValuesColor = [UIColor lightGrayColor];
//    chartView.yValuesColor = [UIColor lightGrayColor];
//    self.chartView.backgroundColor = [UIColor whiteColor];
//    chartView.dataSource = self;
//    [temHistoryView addSubview:chartView];
//    self.temHistoryView = temHistoryView;
//    [self.view addSubview:temHistoryView];
//    
//}
//
//#pragma mark - chartViewDatasource
//- (NSUInteger)chartViewNumberOfPlots:(YXLineChartView *)chartView
//{
//    return 6;
//}
////返回arm的六组数据数组，数组中的每个内容又是一个数组，表示几条线
////每条线上的y坐标是什么
////array里面存储这subarray，subarray 以0表示y1，1表示y1
//- (NSArray *)chartViewYPointArray:(YXLineChartView *)chartView
//{
//    return  self.charts;
//}
////返回X轴的坐标点数据，只取其中的一个数组的元素分割组成新的数组，和Y轴数据进行匹配
//- (NSArray *)chartViewxPointArray:(YXLineChartView *)chartView
//{
//   return  self.dataX;
//}
////返回每条线的颜色
//- (UIColor *)chartViewcolor:(YXLineChartView *)chartView shouldFillPlot:(NSUInteger)plotIndex
//{
//    self.index = plotIndex;
//    return [self.colorArr objectAtIndex:plotIndex];
//    
//    
//}
//
//#warning mark - TODO-需调试参数
////取得x方向的描述数据
//- (NSString *)chartViewGetXinfo:(YXLineChartView *)chartView
//{
//    //return [[self.dataserver objectForKey:@"6"] objectAtIndex:0];
//    
//    return self.strX;
//    
//}
//
//- (NSArray *)getReturnDate
//{
//    NSString *ReturnDate = [[self.dataserver objectForKey:@"6"] objectAtIndex:3];
//    NSArray *ReturnDateList = [ReturnDate componentsSeparatedByString:@"-"];
//    return ReturnDateList;
//}
//
////状态监测图
//- (void)setupTempView
//{
//    //创建状态监测view
//    CGFloat tempTabViewY = CGRectGetMaxY(self.temHistoryView.frame);
//    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(10, tempTabViewY, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.3)];
//    //表格控件
//    CGFloat tempTabViewW = SCREEN_WIDTH-40;
//    CGFloat tempTabViewH = SCREEN_HEIGHT*0.3-40;
//    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10,tempTabViewW, tempTabViewH) style:UITableViewStylePlain];
//    self.tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    //self.tempTableView.backgroundColor = TABLEVIEWBGCLOLOR;
//    self.tempTableView.dataSource = self;
//    self.tempTableView.delegate = self;
//    self.tempTableView.scrollEnabled = NO;
//    //self.tempTableView.layer.borderWidth = 4;
//    //self.tempTableView.layer.borderColor = [UIColor cyanColor].CGColor;
//    //tempView.backgroundColor = REDCLOLOR;
//    [tempView addSubview:self.tempTableView];
//    
//    [self.view addSubview:tempView];
//    
//}
//
////平均值
//- (void)averageBtnClick:(UIButton *)button
//{
//   
//    if (self.avgeView.hidden) {
//        self.avgeLine.backgroundColor = YWColor(28, 144, 231);
//        [button setTitle:@"平均" forState:UIControlStateNormal];
//        self.avgeView.hidden = NO;
//    } else {
//        [button setTitle:@"确定" forState:UIControlStateSelected];
//        self.avgeLine.backgroundColor = [UIColor lightGrayColor];
//        self.avgeView.hidden = YES;
//    }
//    
//    button.selected = !button.selected;
//    [self avgeViewViewPop];
//}
///**
// *  弹出view
// */
//- (void)avgeViewViewPop
//{
//    CGFloat duration = 0.25;
//    if (self.cover == nil) {
//        // 1.添加遮盖
//        UIButton *cover = [[UIButton alloc] init];
//        cover.frame = self.view.bounds;
//        cover.backgroundColor = [UIColor blackColor];
//        cover.alpha = 0;
//        [cover addTarget:self action:@selector(avgeViewViewPop) forControlEvents:UIControlEventTouchUpInside];
//        self.cover = cover;
//       
//        // 2.添加loginView到最中间
//        [self.view bringSubviewToFront:self.avgeView];
//        [self.view insertSubview:cover belowSubview:self.avgeView];
//        
//        [UIView animateWithDuration:duration animations:^{
//            
//            [self.view addSubview:self.avgeView];
//            
//        }];
//    } else {
//        
//        [self.cover removeFromSuperview];
//        [self.avgeView removeFromSuperview];
//        self.cover = nil;
//    }
//    
//}
//
////每周
//- (void)weekBtnClick:(UIButton *)button
//{
//    if (self.weekView.hidden) {
//        self.weekLine.backgroundColor = YWColor(28, 144, 231);
//        [button setTitle:@"1小时" forState:UIControlStateNormal];
//        self.weekView.hidden = NO;
//    } else {
//        [button setTitle:@"确定" forState:UIControlStateSelected];
//        self.weekLine.backgroundColor = [UIColor lightGrayColor];
//        self.weekView.hidden = YES;
//    }
//    //按钮的状态取反
//    button.selected = !button.selected;
//    [self weekViewViewPop];
//}
///**
// *  弹出view
// */
//- (void)weekViewViewPop
//{
//    CGFloat duration = 0.25;
//    if (self.cover == nil) {
//        // 1.添加遮盖
//        UIButton *cover = [[UIButton alloc] init];
//        cover.frame = self.view.bounds;
//        cover.backgroundColor = [UIColor blackColor];
//        cover.alpha = 0;
//        [cover addTarget:self action:@selector(weekViewViewPop) forControlEvents:UIControlEventTouchUpInside];
//        self.cover = cover;
//        // 2.添加View到最中间
//        [self.view bringSubviewToFront:self.weekView];
//        [self.view insertSubview:cover belowSubview:self.weekView];
//        
//        [UIView animateWithDuration:duration animations:^{
//            
//            [self.view addSubview:self.weekView];
//            
//        }];
//    } else {
//        
//        [self.cover removeFromSuperview];
//        [self.weekView removeFromSuperview];
//        self.cover = nil;
//    }
//}
//
//- (void)allYearClick:(UIButton *)button
//{
//   
//     [self setTimeButtonInfo: button];
//    NSString *str = [button.currentTitle stringByReplacingOccurrencesOfString:@"-"withString:@""];
//    NSString *s = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    self.yearStr = [s substringFromIndex:7];
//
//   //获取选中的时间
//    if ([self.weekStr isEqualToString:@"1小时"]){
//        self.yearStr = [self.yearStr substringToIndex:10];;
//    } else if ([self.weekStr isEqualToString:@"1天"]){
//        self.yearStr = [self.yearStr substringToIndex:8];
//    } else  if ([self.weekStr isEqualToString:@"1周"]) {
//        self.yearStr = [self.yearStr substringToIndex:6];
//        
//    } else if ([self.weekStr isEqualToString:@"1个月"]){
//       self.yearStr = [self.yearStr substringToIndex:6];
//        
//    }else  if ([self.weekStr isEqualToString:@"3个月"]){
//        self.yearStr = [self.yearStr substringToIndex:6];
//        
//    }else  if ([self.weekStr isEqualToString:@"6个月"]){
//        self.yearStr = [self.yearStr substringToIndex:6];
//    }else  if ([self.weekStr isEqualToString:@"1年"]){
//        self.yearStr = [self.yearStr substringToIndex:4];
//        
//    }
//    
//    YWLog(@"选中的时间allYearClick -- %@",self.yearStr);
//    //选择年月发生变化发出通知
//    [YWNotificationCenter postNotificationName:YWYearValueDidChangeNotification object:self userInfo:@{YWYearValueDidChange:self.yearStr}];
//    
//    if (self.datePickerView.hidden) {
//        self.dataLine.backgroundColor = YWColor(28, 144, 231);
//        [button setTitle:@"(UTC+8)2017 39周" forState:UIControlStateNormal];
//        self.datePickerView.hidden = NO;
//    } else {
//        [button setTitle:@"确定" forState:UIControlStateSelected];
//        self.dataLine.backgroundColor = [UIColor lightGrayColor];
//        self.datePickerView.hidden = YES;
//    }
//    YWLog(@"dayBtnClick");
//    [self.chartView refreshData];
//     
//    button.selected = !button.selected;
//    //刷新数据
//    [self.chartView reloadData];
//}
//
//- (void)reloadsectionOne
//{
//    for (NSInteger i = 0; i<6; i++) {
//        UITableViewCell *cell = (UITableViewCell *)[self.table viewWithTag:800+i];
//        NSLog(@"cell %lu",(unsigned long)[[cell subviews] count]);
//        UILabel *strtext = (UILabel *)[cell viewWithTag:300+i];
//        NSString *str = [NSString stringWithFormat:@"%@°C",[[self.dataserver objectForKey:@"7"] objectAtIndex:i]];
//        /*CGSize strsize =[str sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
//         [strtext setFrame:CGRectMake(strtext.frame.origin.x,
//         strtext.frame.origin.y,strsize.width,strsize.height)];*/
//        strtext.text =str;
//        
//        UIImageView *icon = (UIImageView *)[cell viewWithTag:400+i];
//        if ([[self.temperature objectAtIndex:i] isEqual:@"00"]){              //等于绿
//            icon.image = [UIImage imageNamed:@"temp-arrow-green-fix.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"01"]){              //等于橙
//            icon.image = [UIImage imageNamed:@"temp-arrow-orange-fix.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"02"]){              //等于红
//            icon.image = [UIImage imageNamed:@"temp-arrow-red-fix.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"10"]){              //大于绿
//            icon.image = [UIImage imageNamed:@"temp-arrow-green-up.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"11"]){              //大于橙
//            icon.image = [UIImage imageNamed:@"temp-arrow-orange-up.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"12"]){              //大于红
//            icon.image = [UIImage imageNamed:@"temp-arrow-red-up.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"20"]){              //小于绿
//            icon.image = [UIImage imageNamed:@"temp-arrow-green-down.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"21"]){              //小于橙
//            icon.image = [UIImage imageNamed:@"temp-arrow-orange-down.png"];
//        }else if([[self.temperature objectAtIndex:i] isEqual:@"22"]){              //大于红
//            icon.image = [UIImage imageNamed:@"temp-arrow-red-down.png"];
//        }
//        icon.hidden = NO;
//    }
//}
//
//#pragma mark -
//#pragma mark Initialization
//
//- (void)dataserverinit
//{
//    self.dataserver = nil;
//    self.dataserver = [[NSMutableDictionary alloc] initWithCapacity:7];
//    
//    for (NSInteger i =0; i<6; i++) {
//        NSMutableArray *strarray =[[NSMutableArray alloc] initWithObjects:@"",@"",@"",nil];
//        [self.dataserver setObject:strarray forKey:[NSString stringWithFormat:@"%ld",(long)i]];
//        
//    }
//    NSMutableArray *temparray = nil;
//    temparray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",nil];
//    [self.dataserver setObject:temparray forKey:@"6"];
//    
//    temparray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
//    [self.dataserver setObject:temparray forKey:@"7"];
//    
//    //温度的状态
//    self.temperature = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil];
//    NSLog(@"self.dataserver %@",self.dataserver);
//}
//
//#pragma mark - ABC相选中或未选
//- (void)initSectionOneDate
//{
//    //选择的button，未选择的button，绘制的线的颜色，绘制的string
//    self.sectionOneArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"temp-wire-color1.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(58, 178, 0),NSLocalizedString(@"A Upper", ""),
//                       [UIImage imageNamed:@"temp-wire-color2.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(152, 219, 56),NSLocalizedString(@"A Lower", ""),
//                       [UIImage imageNamed:@"temp-wire-color3.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(238, 206, 35),NSLocalizedString(@"B Upper", ""),//需要提供实心的蓝色图片
//                       [UIImage imageNamed:@"temp-wire-color4.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(244, 238, 127),NSLocalizedString(@"B Lower", ""),
//                       [UIImage imageNamed:@"temp-wire-color5.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(218, 61, 99),NSLocalizedString(@"C Upper", ""),
//                       [UIImage imageNamed:@"temp-wire-color6.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(230, 155, 180),NSLocalizedString(@"C Lower", ""),nil];
//    
//    self.bOpenArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",nil];
//}
//
//
//- (void)initSectionThirdDate
//{
//    self.timekey = [NSArray arrayWithObjects:@"h",@"d",@"w",@"m",@"m3",@"m6",@"y",nil];
//    self.selectIndex = 0;//时间的初始值在h上
//    [self dataserverinit];
//    self.timeArray = [NSMutableArray arrayWithArray:self.weakData];
//    
//}
//
////初始化日期选择器数据
//- (void)initpickerViewCompontSelectIndex
//{
//    self.pick1compentfocusIndex = 0;
//    self.pick2compentfocusIndex = 0;
//    self.pick3compentfocusIndex = 0;
//    self.pick0compentfocusIndex = 0;
//}
//
//- (void)initPickerViewDate
//{
//    [self initpickerViewCompontSelectIndex];
//    
//    NSDate *today = nil;
//    NSTimeZone* GMT8zone = nil;
//    NSDateFormatter *dateFormater = nil;
//    int year;
//    today = [NSDate date]; //默认获得GMT0的时间
//    GMT8zone = [NSTimeZone timeZoneForSecondsFromGMT:28800]; //获取GMT8中国时差
//    dateFormater = [[NSDateFormatter alloc]init];
//    dateFormater.timeZone = GMT8zone;
//    [dateFormater setDateFormat:@"YYYY"];
//    year = [[dateFormater stringFromDate:today] intValue];
//    
//    self.pickviewYearArray = [[NSMutableArray alloc] init];
//    
//    for (int i=year;i>2009;i--) {
//        NSString *yearStr = [NSString stringWithFormat:@"%d", i];
//        [self.pickviewYearArray addObject:yearStr];
//    }
//    self.pickviewMonthArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"一月", ""),NSLocalizedString(@"二月", ""),NSLocalizedString(@"三月", ""),NSLocalizedString(@"四月", ""),NSLocalizedString(@"五月", ""),NSLocalizedString(@"六月", ""),NSLocalizedString(@"七月", ""),NSLocalizedString(@"八月", ""),NSLocalizedString(@"九月", ""),NSLocalizedString(@"十月", ""),NSLocalizedString(@"十一月", ""),NSLocalizedString(@"十二月", ""),nil];
//    //[self.pickviewYearArray ];
//    
//   
//    NSLog(@"pickviewYearArray %@",self.pickviewYearArray);
//    NSLog(@"pickviewMonthArray %@",self.pickviewMonthArray);
//}
//
//-  (void)createPickerView
//{
//    CGFloat pickerY = CGRectGetMaxY(self.yearBtn.frame)+35;
//    self.datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,pickerY, 0,0)];
//    self.datePickerView.backgroundColor = BGCLOLOR;
//    self.datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.datePickerView.dataSource = self;
//    self.datePickerView.delegate = self;
//    self.datePickerView.showsSelectionIndicator = YES;
//    self.datePickerMode = YXDatePickerModeHour;
//    self.datePickerView.hidden = YES;
//    [self.view addSubview:self.datePickerView];
//    
//}
//
//#pragma mark- pickerview
////选择年
//- (NSString *)getselectyear
//{
//    return [self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex];
//}
////选择月
//- (NSString *)getselectMonth
//{
//    return [self.pickviewMonthArray objectAtIndex:self.pick0compentfocusIndex];
//}
////选择天
//- (NSString *)getselectDay
//{
//
//    return [NSString stringWithFormat:@"%ld",self.pick2compentfocusIndex+1];
//}
////获取周
//- (NSInteger)getWeek
//{
//    //return [[[self.dataserver objectForKey:@"6"] objectAtIndex:2] intValue];
//    return 2;
//    
//}
//
///**
// A上254，124，0    A下250，181，26
// B上 0，100，0    B下50，205，50
// C上 139，0，0     C下255，0，0
// gray128,128,128
// */
//- (void)setTimeButtonInfo: (UIButton *)button
//{
//    if ([self.pickviewYearArray count]>0)
//    {
//        NSString *year = [[self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex] substringToIndex:4];
//        if (self.datePickerMode == YXDatePickerModeHour) {
//            
//            NSString *str = [NSString stringWithFormat:@"(UTC+8) %@-%.2ld-%.2ld %.2ld:00",year,self.pick1compentfocusIndex+1,self.pick2compentfocusIndex+1,
//                             (long)self.pick3compentfocusIndex];
//            [button setTitle:str forState:UIControlStateNormal];//小时的时标显示
//            
//            self.dateParams = [NSString stringWithFormat:@"&year=%@&month=%ld&day=%ld&hour=%ld", year,
//                               self.pick1compentfocusIndex+1,
//                               self.pick2compentfocusIndex+1,
//                               (long)self.pick3compentfocusIndex];
//        }
//        else if ([[self.timekey objectAtIndex:self.selectIndex] isEqualToString:@"y"]) {
//            button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@",year];  //年的时标显示
//            self.dateParams = [NSString stringWithFormat:@"&year=%@",year];
//        }
//        else if ([[self.timekey objectAtIndex:self.selectIndex] isEqualToString:@"d"]) {
//            button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@-%ld-%ld",year,
//                                      self.pick1compentfocusIndex+1,
//                                      self.pick2compentfocusIndex+1];  //天的时标显示
//            self.dateParams = [NSString stringWithFormat:@"&year=%@&month=%ld&day=%ld",year,
//                               self.pick1compentfocusIndex+1,
//                               self.pick2compentfocusIndex+1];
//        }
//        else if ([[self.timekey objectAtIndex:self.selectIndex] isEqualToString:@"w"]) {
//            button.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(UTC+8) %@ week %d", "") ,year,
//                                      self.pick1compentfocusIndex+1];  //周的时标显示
//            self.dateParams = [NSString stringWithFormat:@"&year=%@&week=%ld",year,
//                               self.pick1compentfocusIndex+1];
//        }
//        else if ([[self.timekey objectAtIndex:self.selectIndex] isEqualToString:@"m"]) {
//            button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@-%ld",year,
//                                      self.pick1compentfocusIndex+1];  //月的时标显示
//            self.dateParams = [NSString stringWithFormat:@"&year=%@&month=%ld",year,
//                               self.pick1compentfocusIndex+1];
//        }
//        else if ([[self.timekey objectAtIndex:self.selectIndex] isEqualToString:@"m3"]) {
//            NSString *str;
//            switch (self.pick1compentfocusIndex) {
//                case 0:
//                    str = NSLocalizedString(@"1st quarter", "");
//                    break;
//                case 1:
//                    str = NSLocalizedString(@"2nd quarter", "");
//                    break;
//                case 2:
//                    str = NSLocalizedString(@"3rd quarter", "");
//                    break;
//                default:
//                    str = NSLocalizedString(@"4th quarter", "");
//                    break;
//            }
//            if ([NSLocalizedString(@"Language", "") isEqualToString: @"Chinese"]) {
//                button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@ %@",year,
//                                          str]; //3个月的时标显示
//            }else{
//                button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@ of %@",str,
//                                          year]; //3个月的时标显示
//            }
//            self.dateParams = [NSString stringWithFormat:@"&year=%@&quarter=%ld",year,
//                               (self.pick1compentfocusIndex+1)];
//        }
//        else if ([[self.timekey objectAtIndex:self.selectIndex] isEqualToString:@"m6"]) {
//            NSString *str = nil;
//            NSString *annual = nil;
//            if (self.pick1compentfocusIndex ==0) {
//                str =NSLocalizedString(@"1st half year", "");
//                annual = @"1";
//            }
//            else {
//                str =NSLocalizedString(@"2nd half year", "");
//                annual = @"2";
//            }
//            if ([NSLocalizedString(@"Language", "") isEqualToString: @"Chinese"]) {
//                button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@ %@",year,
//                                          str]; //6个月的时标显示
//            }else{
//                button.titleLabel.text = [NSString stringWithFormat:@"(UTC+8) %@ of %@",str,
//                                          year]; //6个月的时标显示
//            }
//            self.dateParams = [NSString stringWithFormat:@"&year=%@&annual=%@",year,
//                               annual];
//        }
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    }
//}
//
//#warning mark-重新加载pickerview
//- (void)resetWhenLoadPickview
//{
//    if (self.firststartsign == 2) {
//        return;
//    }
//    NSArray *RetunDateList = [self getReturnDate];
//    NSDate *today = nil;
//    NSTimeZone* GMT8zone = nil;
//    NSDateFormatter *dateFormater = nil;
//    int year,currentyear,month = 0,day = 0,week = 0,hour = 0,annual = 0,quarter = 0;
//    today = [NSDate date]; //默认获得GMT0的时间
//    GMT8zone = [NSTimeZone timeZoneForSecondsFromGMT:28800]; //获取GMT8中国时差
//    dateFormater = [[NSDateFormatter alloc]init];
//    dateFormater.timeZone = GMT8zone;
//    [dateFormater setDateFormat:@"YYYY"];
//    currentyear = [[dateFormater stringFromDate:today] intValue];
//    
//    
//    if ([[RetunDateList objectAtIndex:(0)] isEqualToString:@"0000"]) {
//        year=currentyear-currentyear;
//        [dateFormater setDateFormat:@"MM"];
//        month = [[dateFormater stringFromDate:today] intValue];
//        [dateFormater setDateFormat:@"dd"];
//        day = [[dateFormater stringFromDate:today] intValue];
//        [dateFormater setDateFormat:@"HH"];
//        hour = [[dateFormater stringFromDate:today] intValue];
//        annual = month>6?2:1;
//        quarter = (month + 2)/3;
//        week = [self getWeek];
//    }else {
//        year = currentyear - [[RetunDateList objectAtIndex:(0)] intValue];
//        if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"]){
//            month=[[RetunDateList objectAtIndex:(1)] intValue];
//            day=[[RetunDateList objectAtIndex:(2)] intValue];
//            hour=[[RetunDateList objectAtIndex:(3)] intValue];
//            annual = month>6?2:1;
//            quarter = (month + 2)/3;
//            
//        }else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"]){
//            month=[[RetunDateList objectAtIndex:(1)] intValue];
//            day=[[RetunDateList objectAtIndex:(2)] intValue];
//            annual = month>6?2:1;
//            quarter = (month + 2)/3;
//        }else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]){
//            week=[[RetunDateList objectAtIndex:(1)] intValue];
//        }else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]){
//            month=[[RetunDateList objectAtIndex:(1)] intValue];
//        }else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]){
//            month=[[RetunDateList objectAtIndex:(1)] intValue];
//        }else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"]){
//            month=[[RetunDateList objectAtIndex:(1)] intValue];
//        }
//    }
//    
//    
//    
//    [self initpickerViewCompontSelectIndex];
//    [self.datePickerView reloadAllComponents];
//    
//    pick0compentfocusIndex = year;
//    [self.datePickerView selectRow:pick0compentfocusIndex inComponent:0 animated:YES];
//    
//    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"])
//    {
//        pick1compentfocusIndex = annual-1;
//        [self.datePickerView selectRow:pick1compentfocusIndex inComponent:1 animated:YES];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"])
//    {
//        pick1compentfocusIndex = quarter-1;
//        [self.datePickerView selectRow:pick1compentfocusIndex inComponent:1 animated:YES];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"])
//    {
//        pick1compentfocusIndex = month-1;
//        [self.datePickerView selectRow:pick1compentfocusIndex inComponent:1 animated:YES];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
//    {
//        pick1compentfocusIndex = month-1;
//        pick2compentfocusIndex = day-1;
//        [self.datePickerView selectRow:pick1compentfocusIndex inComponent:1 animated:YES];
//        [self.datePickerView selectRow:pick2compentfocusIndex inComponent:2 animated:YES];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
//    {
//        pick1compentfocusIndex = month-1;
//        pick2compentfocusIndex = day-1;
//        pick3compentfocusIndex = hour;
//        [self.datePickerView selectRow:pick1compentfocusIndex inComponent:1 animated:YES];
//        [self.datePickerView selectRow:pick2compentfocusIndex inComponent:2 animated:YES];
//        [self.datePickerView selectRow:pick3compentfocusIndex inComponent:3 animated:YES];
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"])
//    {
//        pick1compentfocusIndex = week-1;
//        [self.datePickerView selectRow:pick1compentfocusIndex inComponent:1 animated:YES];
//    }
//    else {
//        pick1compentfocusIndex = 0;
//    }
//    //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    CGFloat componentWidth = 0.0;
//    
//    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"]) {
//        
//        componentWidth =75;
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]) {
//        
//        componentWidth =300;
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"]) {
//        
//        componentWidth =100;
//    }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"]
//              ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]
//              ) {
//        if (component == 0)
//            componentWidth = 150;
//        else
//            componentWidth = 150;
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]
//             ) {
//        componentWidth =150;
//    }
//    else {
//        
//    }
//    return componentWidth;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 35.0;
//}
////指定每个表盘上有几行数据
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    NSInteger count = 0;
//    if (self.pickviewYearArray==nil) {
//        return 0;
//    }
//    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
//    {
//        //年
//        if (component == 0) {
//            count = [self.pickviewYearArray count];
//        }
//        else if(component==1){//月
//            count = 12;
//        }
//        else if(component ==2){//日，初始月分在1月份
//            if (self.pick1compentfocusIndex +1==1
//                ||self.pick1compentfocusIndex+1 ==3
//                ||self.pick1compentfocusIndex +1==5
//                ||self.pick1compentfocusIndex +1==7
//                ||self.pick1compentfocusIndex +1==8
//                ||self.pick1compentfocusIndex +1==10
//                ||self.pick1compentfocusIndex +1==12) {
//                count = 31;
//            }
//            else if(self.pick1compentfocusIndex +1==2){
//                NSArray *yd = [(NSString *)[self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex] componentsSeparatedByString:@"年"];
//                NSInteger y = [(NSString *)[yd objectAtIndex:0] intValue];
//                if(y%4==0 && y%100!=0)
//                    count = 29;
//                else
//                    count = 28;
//            }
//            else {
//                count = 30;
//            }
//        }
//        else {//时
//            count =24;
//        }
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]){
//        count = [self.pickviewYearArray count];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
//    {
//        //年
//        if (component == 0) {
//            count = [self.pickviewYearArray count];
//        }
//        else if(component==1){//月
//            count = 12;
//        }
//        else{//日，初始月分在1月份
//            if (self.pick1compentfocusIndex +1==1
//                ||self.pick1compentfocusIndex+1 ==3
//                ||self.pick1compentfocusIndex +1==5
//                ||self.pick1compentfocusIndex +1==7
//                ||self.pick1compentfocusIndex +1==8
//                ||self.pick1compentfocusIndex +1==10
//                ||self.pick1compentfocusIndex +1==12) {
//                count = 31;
//            }
//            else if(self.pick1compentfocusIndex +1==2){
//                NSArray *yd = [(NSString *)[self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex] componentsSeparatedByString:@"年"];
//                NSInteger y = [(NSString *)[yd objectAtIndex:0] intValue];
//                if(y%4==0 && y%100!=0)
//                    count = 29;
//                else
//                    count = 28;
//            }
//            else {
//                count = 30;
//            }
//        }
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]){
//        //年
//        if (component == 0) {
//            count = [self.pickviewYearArray count];
//        }
//        else if(component==1){//周
//            count = 52;
//        }
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]){
//        //年
//        if (component == 0) {
//            count = [self.pickviewYearArray count];
//        }
//        else if(component==1){//月
//            count = 12;
//        }
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]){
//        //年
//        if (component == 0) {
//            count = [self.pickviewYearArray count];
//        }
//        else if(component==1){//季度
//            count = 4;
//        }
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"]){
//        //年
//        if (component == 0) {
//            count = [self.pickviewYearArray count];
//        }
//        else if(component==1){//上半年
//            count = 2;
//        }
//    }
//    
//    return count;
//}
////指定pickerview有几个表盘
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
////    YWLog(@"有几个表盘%ld",(long)self.selectIndex);
//    NSInteger number = 0;
//    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
//    {
//        number = 4;
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"])
//    {
//        number = 1;
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
//    {
//        number = 3;
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"])
//    {
//        number = 2;
//    }
//    return number;
//    return 2;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
//          forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//    YXCustomDateView *dateView = [[YXCustomDateView alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
//    //cView.fontdisplay=[GlobalInfo getFont:18];
//    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
//    {
//        switch (component)
//        {
//            case 0://year
//                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//                break;
//            case 1://month
//                dateView.titleStr = [self.pickviewMonthArray objectAtIndex:row];
//                break;
//            case 2://day
//                if (row == 0)
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
//                else if (row == 1)
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
//                else if (row == 2)
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
//                else
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
//                break;
//            case 3://h
//                dateView.titleStr = [NSString stringWithFormat:@"%ld:00",(long)row];
//                break;
//            default:
//                break;
//        }
//    }
//    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]){
//        dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
//    {
//        switch (component)
//        {
//            case 0://year
//                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//                break;
//            case 1://month
//                dateView.titleStr = [self.pickviewMonthArray objectAtIndex:row];
//                break;
//            case 2://day
//                if (row == 0)
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%dst", ""),row+1];
//                else if (row == 1)
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%dnd", ""),row+1];
//                else if (row == 2)
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%drd", ""),row+1];
//                else
//                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%dth", ""),row+1];
//                break;
//            default:
//                break;
//        }
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"])
//    {
//        switch (component)
//        {
//            case 0://year
//                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//                break;
//            case 1://week
//                dateView.frame = CGRectMake(0, 0, 150,40);
//                dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"第　 %d周", ""),row+1];
//                break;
//            default:
//                break;
//        }
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"])
//    {
//        switch (component)
//        {
//            case 0://year
//                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//                break;
//            case 1://month
//                dateView.titleStr = [self.pickviewMonthArray objectAtIndex:row];
//                break;
//            default:
//                break;
//        }
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"])
//    {
//        switch (component)
//        {
//            case 0://year
//                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//                break;
//            case 1://quarter
//            {
//                NSString *str =nil;
//                if (row ==0) {
//                    str = NSLocalizedString(@"第一季度", "");
//                }
//                else if (row ==1)
//                {
//                    str = NSLocalizedString(@"第二季度", "");
//                }
//                else if (row ==2)
//                {
//                    str = NSLocalizedString(@"第三季度", "");
//                }
//                else
//                {
//                    str = NSLocalizedString(@"第四季度", "");
//                }
//                dateView.frame = CGRectMake(0, 0, 150,40);
//                dateView.titleStr = str;
//                
//                //cView.frame = CGRectMake(0, 0, 150,40);
//                //cView.title = [NSString stringWithFormat:@"Quarter %d",row+1];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"])
//    {
//        switch (component)
//        {
//            case 0://year
//                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
//                break;
//            case 1://半年
//            {
//                NSString *str =nil;
//                if (row ==0) {
//                    str = NSLocalizedString(@"上半年", "");
//                }
//                else {
//                    str = NSLocalizedString(@"下半年", "");
//                }
//                dateView.frame = CGRectMake(0, 0, 150,40);
//                dateView.titleStr = str;
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    return dateView;
//}
//
//- (void)pickerView:(UIPickerView *)pickerView
//      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
//    {
//        if (component ==0) {//年
//            self.pick0compentfocusIndex = row;
//            self.pick1compentfocusIndex  = 0;
//            [self.datePickerView  reloadComponent:1];//重新load日
//            [self.datePickerView selectRow:self.pick1compentfocusIndex inComponent:1 animated:YES];
//            
//        }
//        else if(component ==1)
//        {
//            self.pick1compentfocusIndex = row;
//            self.pick2compentfocusIndex  = 0;
//            [self.datePickerView  reloadComponent:2];//重新load日
//            [self.datePickerView selectRow:self.pick2compentfocusIndex inComponent:2 animated:YES];
//        }
//        else if(component ==2){//日
//            self.pick2compentfocusIndex = row;
//        }
//        else if(component ==3){//小时
//            self.pick3compentfocusIndex = row;
//        }
//        //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//        
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"])
//    {
//        self.pick0compentfocusIndex = row;
//        //[self.tempTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
//    {
//        if (component ==0) {//年
//            self.pick0compentfocusIndex = row;
//            self.pick1compentfocusIndex  = 0;
//            [self.datePickerView  reloadComponent:1];//重新load日
//            [self.datePickerView selectRow:self.pick1compentfocusIndex inComponent:1 animated:YES];
//            
//        }
//        else if(component ==1)
//        {
//            self.pick1compentfocusIndex = row;
//            self.pick2compentfocusIndex  = 0;
//            [self.datePickerView  reloadComponent:2];//重新load日
//            [self.datePickerView selectRow:self.pick2compentfocusIndex inComponent:2 animated:YES];
//        }
//        else{//日
//            self.pick2compentfocusIndex = row;
//        }
//        //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//        
//    }
//    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]
//             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m6"])
//    {
//        if (component ==0) {//年
//            self.pick0compentfocusIndex = row;
//        }
//        else//week
//        {
//            self.pick1compentfocusIndex = row;
//        }
//        
//        
//    }
//}
//
//
//#pragma mark ---------------------------------------------initloading----------------------------------------------
//
//- (void)removeActiveIndictor:(NSString *)aletmsg
//{
//
//    
//}
//
//- (NSString*) getTimeButtonBG:(NSString *)title
//{
//    NSString * timeButtonBg;
//    if ([NSLocalizedString(@"Language", "") isEqualToString: @"Chinese"]) {
//        switch ([title length]) {
//            case 4:
//                timeButtonBg = @"temp-4c-bg.png";
//                break;
//            case 5:
//                timeButtonBg = @"temp-5c-bg.png";
//                break;
//            default:
//                timeButtonBg = @"temp-4c-bg.png";
//                break;
//        }
//    }else{
//        switch ([title length]) {
//            case 4:
//                timeButtonBg = @"temp-4c-bg.png";
//                break;
//            case 5:
//                timeButtonBg = @"temp-5c-bg.png";
//                break;
//            default:
//                timeButtonBg = @"temp-6c-bg.png";
//                break;
//        }
//    }
//    return timeButtonBg;
//}
//
//#pragma mark buttonclick
//-(void)timebuttonClick:(id)obj
//{
//    UIButton *bt =(UIButton *)obj;
//    NSInteger tag =bt.tag -500;
//    if (tag == self.selectIndex) {//和之前相等
//        return;
//    }
//    else {
//        [obj setBackgroundImage:[UIImage imageNamed:[self getTimeButtonBG:bt.titleLabel.text]] forState:UIControlStateNormal];
//        [obj setTitleColor:YWColor(51,71,114)  forState:UIControlStateNormal];
//        bt.titleLabel.shadowColor = [UIColor clearColor];
//        bt.titleLabel.shadowOffset = CGSizeMake(0, 0);
//        
//        UIButton *preBtn = (UIButton *)[self.timeArray objectAtIndex:self.selectIndex];
//        [preBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        preBtn.titleLabel.shadowColor = [UIColor grayColor];
//        preBtn.titleLabel.shadowOffset = CGSizeMake(1, 1);
//        
//        self.selectIndex = tag;
//        
//        
//        if (self.bg.hidden)
//        {
//            self.bg.hidden = NO;
//            [self.loading startAnimating];
//        }
//        //这里重新初始pickerview的index
//        //        [self resetWhenLoadPickview];  //去掉，改为begeinNetConnection间接调用，放在didFinishParsing里面
//    }
//    self.firststartsign =0;
//    self.getolddatasign = @"1"; //第一次进入设为1，读取最近有数据的日期的温度曲线
//    //[self begeinNetConnection:[self.timekey objectAtIndex:self.selectIndex]];
//    self.getolddatasign = @"2"; //随后设为2，码盘选择时间为所要读取的日期的温度曲线
//    
//    
//}
//#pragma mark-picSet
//- (void)imagebuttonclicked:(id)obj
//{
//    //设置选中对号图片按钮
//    NSInteger tag = ((UIButton *)obj).tag - 0;
//    if ([[self.bOpenArray objectAtIndex:tag] isEqual:@"0"]) {
//        [((UIButton *)obj) setBackgroundImage:[self.sectionOneArray objectAtIndex:tag*4] forState:UIControlStateNormal];
//        [self.bOpenArray replaceObjectAtIndex:tag withObject:@"1"];
//    }
//    else {
//        [((UIButton *)obj) setBackgroundImage:[self.sectionOneArray objectAtIndex:tag*4+1] forState:UIControlStateNormal];
//        [self.bOpenArray replaceObjectAtIndex:tag withObject:@"0"];
//    }
//    self.bg.hidden = NO;
//    [self.loading startAnimating];
//    //重新绘制
//    [self.chartView refreshData];
//}
//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    if (tableView == _avgeView) {
//        return self.avgeData.count;
//    } else if (tableView == _weekView) {
//        return self.weakData.count;
//    }
//    return 4;
//}
///**
// A上254，124，0    A下250，181，26
// B上 0，100，0    B下50，205，50
// C上 139，0，0     C下255，0，0
// gray128,128,128
// */
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (tableView == _avgeView) {
//        //创建cell
//        YXButtonViewCell *cell = [YXButtonViewCell cellWithTableView:tableView];
//        [cell.titleBtn setTitle:self.avgeData[indexPath.row] forState:UIControlStateNormal];
//        cell.backgroundColor = BGCLOLOR;
//        cell.didTapTimeBtn = ^(UIButton *timeBtn) {
//            
//            YWLog(@"调用啦平均值按钮");
//             [self avgeViewViewPop];
//        };
//        return cell;
//        
//        
//    } else if (tableView == _weekView) {
//        
//        //创建cell
//        YXButtonViewCell *cell = [YXButtonViewCell cellWithTableView:tableView];
//        cell.backgroundColor = BGCLOLOR;
//        [cell.titleBtn setTitle:self.weakData[indexPath.row] forState:UIControlStateNormal];
//        cell.didTapTimeBtn = ^(UIButton *timeBtn) {
//            //[self timebuttonClick:timeBtn];
//        };
//        return cell;
//        
//    }
//    
//    //创建cell
//    YWHistoryTempCell *cell = [YWHistoryTempCell cellWithTableView:tableView];
//    
//        if (indexPath.row == 1) {
//            //调用A回调方法
//            cell.didTapABtn = ^(UIButton *abtn) {
//                
//                //self.index = 0;
//                UIColor *acolor = self.colorArr[self.index];
//
//                if (abtn.selected) {
//                    abtn.backgroundColor = YWColor(254, 124, 0);
//                    self.colorArr[self.index] = YWColor(254, 124, 0);
//                 
//                } else {
//                    abtn.backgroundColor = YWColor(128, 128,128);
//                    self.colorArr[self.index] = [UIColor clearColor];
//                    
//                    //隐藏对应的曲线
//             
//                }
//                [self.chartView reloadData];
//            };
//            
//            //调用B回调方法
//            cell.didTapBBtn = ^(UIButton *bbtn) {
//                //self.index = 2;
//                UIColor *bcolor = self.colorArr[self.index];
//                if (bbtn.selected) {
//                    bbtn.backgroundColor = YWColor(0, 100, 0);
//                    self.colorArr[self.index] = YWColor(0, 100, 0);
//
//                } else {
//                    bbtn.backgroundColor = YWColor(128, 128,128);
//                    self.colorArr[self.index] = [UIColor clearColor];
//                    
//                    
//                    //隐藏对应的曲线
//                
//                }
//                [self.chartView reloadData];
//            };
//            
//            //调用C回调方法
//            cell.didTapCBtn = ^(UIButton *cbtn) {
//                //self.index = 4;
//                UIColor *ccolor = self.colorArr[self.index];
//                if (cbtn.selected) {
//                    cbtn.backgroundColor = YWColor(139, 0, 0);
//                    self.colorArr[self.index] = YWColor(139, 0, 0);
//
//                } else {
//                    cbtn.backgroundColor = YWColor(128, 128,128);
//                    self.colorArr[self.index] = [UIColor clearColor];
//                    
//                    //隐藏对应的曲线
//                  
//                }
//                [self.chartView reloadData];
//            };
//        } else if (indexPath.row == 2){
//            //调用A回调方法
//            //调用A回调方法
//            cell.didTapABtn = ^(UIButton *abtn) {
//                //self.index = 1;
//                UIColor *acolor = self.colorArr[self.index];
//                if (abtn.selected) {
//                    abtn.backgroundColor = YWColor(250, 181, 26);
//                    self.colorArr[self.index] = YWColor(250, 181, 26);
//                } else {
//                    abtn.backgroundColor = YWColor(128, 128,128);
//                    self.colorArr[self.index] = [UIColor clearColor];
//                    
//                    //隐藏对应的曲线
//                    
//                }
//                [self.chartView reloadData];
//            };
//            
//            //调用B回调方法
//            /**
//            A上254，124，0    A下250，181，26
//            B上 0，100，0    B下50，205，50
//            C上 139，0，0     C下255，0，0
//            gray128,128,128
//            */
//            cell.didTapBBtn = ^(UIButton *bbtn) {
//                //self.index = 3;
//                UIColor *bcolor = self.colorArr[self.index];
//                if (bbtn.selected) {
//                    bbtn.backgroundColor = YWColor(50, 205, 50);
//                    self.colorArr[self.index] = YWColor(50, 205, 50);
//                } else {
//                    bbtn.backgroundColor = YWColor(128, 128,128);
//                    self.colorArr[self.index] = [UIColor clearColor];
//                    //隐藏对应的曲线
//                    
//                }
//                 [self.chartView reloadData];
//            };
//            
//            //调用C回调方法
//            cell.didTapCBtn = ^(UIButton *cbtn) {
//                //self.index = 5;
//                UIColor *ccolor = self.colorArr[self.index];
//                if (cbtn.selected) {
//                    cbtn.backgroundColor = YWColor(255, 0, 0);
//                    self.colorArr[self.index] = YWColor(255, 0, 0);
//
//                } else {
//                    cbtn.backgroundColor = YWColor(128, 128,128);
//                    self.colorArr[self.index] = [UIColor clearColor];
//                    //隐藏对应的曲线
//                    
//                }
//                [self.chartView reloadData];
//            };
//        }
//        //设置数据
//        if (indexPath.row == 0) {
//            
//            cell.statusBtn.hidden = YES;
//            [cell.tempBtn3 setTitle:@"A相" forState:UIControlStateNormal];
//            [cell.tempBtn2 setTitle:@"B相" forState:UIControlStateNormal];
//            [cell.tempBtn1 setTitle:@"C相" forState:UIControlStateNormal];
//            [cell.tempBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            [cell.tempBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            [cell.tempBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            
//            
//        }else if (indexPath.row == 1) {
//            cell.tempInfo = self.deviceTemp.up;
//            [cell.statusBtn setTitle:@"上触指" forState:UIControlStateNormal];
//            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq8"] forState:UIControlStateNormal];
//            [cell.tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cell.tempBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cell.tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.tempBtn3.backgroundColor = YWColor(254,124,0);
//            cell.tempBtn2.backgroundColor = YWColor(0,100,0);
//            cell.tempBtn1.backgroundColor = YWColor(139,0,0);
//            
//            /**
//             A上254，124，0    A下250，181，26
//             B上 0，100，0    B下50，205，50
//             C上 139，0，0     C下255，0，0
//             gray128,128,128
//             */
//            
//        }else if (indexPath.row == 2) {
//            cell.tempInfo = self.deviceTemp.down;
//            [cell.statusBtn setTitle:@"下触指" forState:UIControlStateNormal];
//            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq8"] forState:UIControlStateNormal];
//            
//            [cell.tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cell.tempBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cell.tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            
//            cell.tempBtn3.backgroundColor = YWColor(250,181,26);
//            cell.tempBtn2.backgroundColor = YWColor(50,205,50);
//            cell.tempBtn1.backgroundColor = YWColor(255,0,0);
//            
//        }else if (indexPath.row == 3) {
//            cell.tempInfo = self.deviceTemp.connect;
//            [cell.statusBtn setTitle:@"电缆头" forState:UIControlStateNormal];
//            [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq9"] forState:UIControlStateNormal];
// 
//            cell.tempBtn3.backgroundColor = YWColor(128, 128, 128);
//            cell.tempBtn2.backgroundColor = YWColor(128, 128, 128);
//            cell.tempBtn1.backgroundColor = YWColor(128, 128, 128);
//            [cell.tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cell.tempBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cell.tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            
//        }
//        return cell;
//    
//}
///**
// A上254，124，0    A下250，181，26
// B上 0，100，0    B下50，205，50
// C上 139，0，0     C下255，0，0
// gray128,128,128
// */
// 
//- (NSMutableArray *)colorArr
//{
//    if (!_colorArr) {
//        _colorArr = [NSMutableArray arrayWithObjects:YWColor(254, 124, 0),YWColor(250, 181, 26),YWColor(0, 100, 0),YWColor(50, 205, 50),YWColor(139, 0, 0),YWColor(255, 0, 0), nil];
//        
//    }
//    return _colorArr;
//}
//
//
//#pragma mark - Table view delegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //cell的高度
//    if (tableView == self.avgeView ||tableView == self.weekView) {
//         return 30;
//    } else{
//        if (indexPath.row == 0) {
//            return 18;
//        }
//        return 28;
//        
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.avgeView) {
//        //[self avgeViewViewPop];
//        NSString *avgeStr = self.avgeData[indexPath.row];
//        [self.avgeBtn setTitle:avgeStr forState:UIControlStateNormal];
//        self.avgeStr = avgeStr;
//        
//        
//        YWLog(@"allavgeStr--%@",self.avgeStr);
//        //平均值改变
//        [YWNotificationCenter postNotificationName:YWAvegeValueDidChangeNotification object:self userInfo:@{YWAvegeValueDidChange:avgeStr}];
//        
//        
//    } else if (tableView == self.weekView)  {
//        
//         //[self resetWhenLoadPickview];
//         //[self weekViewViewPop];
//         NSString *weekStr = self.weakData[indexPath.row];
//        self.weekStr = weekStr;
//        [self.weekBtn setTitle:weekStr forState:UIControlStateNormal];
//        //日期选择器模式
//        if (indexPath.row == 0) {
//            self.datePickerMode = YXDatePickerModeHour;
//            self.strX = @"0,5,10,15,20,25,30,35,40,45,50,55,60";
//            self.selectIndex = 0;
//            [self createPickerView];
//        } else  if (indexPath.row == 1){
//            self.datePickerMode = YXDatePickerModeDay;
//            self.strX = @"0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24";
//            self.selectIndex = 1;
//            [self createPickerView];
//        }else  if (indexPath.row == 2){
//            self.datePickerMode = YXDatePickerModeWeek;
//            self.strX = @"0,1,2,3,4,5,6,7";
//            self.selectIndex = 2;
//            [self createPickerView];
//        }else  if (indexPath.row == 3){
//            self.datePickerMode = YXDatePickerModeMonth;
//            self.strX = @"0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30";
//            self.selectIndex = 3;
//            [self createPickerView];
//        }else  if (indexPath.row == 4){
//            self.datePickerMode = YXDatePickerModeQuarter;
//            self.strX = @"0,1,2,3";
//            self.selectIndex = 4;
//            [self createPickerView];
//        }else  if (indexPath.row == 5){
//            self.datePickerMode = YXDatePickerModeHalfYear;
//            self.strX = @"0,1,2,3,4,5,6";
//            self.selectIndex = 5;
//            [self createPickerView];
//        }else if (indexPath.row == 6){
//            self.datePickerMode = YXDatePickerModeYear;
//            self.strX = @"0,1,2,3,4,5,6,7,8,9,10,11,12";
//            self.selectIndex = 6;
//            [self createPickerView];
//        }
//        
//        YWLog(@"allweekStr--%@",self.weekStr);
//        //平均值改变
//        [YWNotificationCenter postNotificationName:YWWeekValueDidChangeNotification object:self userInfo:@{YWWeekValueDidChange:weekStr}];
//    }
//    
//}
//
//- (UITableView *)avgeView
//{
//    if (!_avgeView) {
//        _avgeView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _avgeView.delegate = self;
//        _avgeView.hidden = YES;
//        _avgeView.dataSource = self;
//        _avgeView.scrollEnabled = NO;
//        _avgeView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _avgeView.backgroundColor = BGCLOLOR;
//        _avgeView.showsVerticalScrollIndicator = NO;
//        [self.view addSubview:_avgeView];
//        _avgeView.frame = CGRectMake(20,68,65,90);
//    }
//    return _avgeView;
//}
//
//- (NSArray *)avgeData
//{
//    if (!_avgeData) {
//        _avgeData = @[@"平均",@"最大",@"最小"];
//    }
//    return _avgeData;
//}
//
//
//
//- (UITableView *)weekView
//{
//    if (!_weekView) {
//        _weekView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _weekView.delegate = self;
//        _weekView.hidden = YES;
//        _weekView.dataSource = self;
//        _weekView.scrollEnabled = NO;
//        _weekView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _weekView.backgroundColor = BGCLOLOR;
//        _weekView.showsVerticalScrollIndicator = NO;
//        [self.view addSubview:_weekView];
//        _weekView.frame = CGRectMake(89,68,65,210);
//    }
//    return _weekView;
//}
//
//- (NSArray *)weakData
//{
//    if (!_weakData) {
//        _weakData = @[@"1小时",@"1天",@"1周",@"1个月",@"3个月",@"6个月",@"1年"];
//    }
//    return _weakData;
//}
//
@end
