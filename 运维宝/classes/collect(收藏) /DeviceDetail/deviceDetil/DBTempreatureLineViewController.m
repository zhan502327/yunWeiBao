//
//  DBTempreatureLineViewController.m
//  运维宝
//
//  Created by zhandb on 2020/7/9.
//  Copyright © 2020 com.stlm. All rights reserved.
//

#import "DBTempreatureLineViewController.h"
#import "DBLineView.h"
#import "YWHistoryTempCell.h"
#import "YWDeviceTemp.h"
#import "JHChartHeader.h"
#import "SYLJDatePickerView.h"
#import "YWChartGroup.h"
#import "YXCustomDateView.h"
#import "YWChartLine.h"
#import "YXButtonViewCell.h"



/**
 A上254，124，0    A下250，181，26
 B上 0，100，0    B下50，205，50
 C上 139，0，0     C下255，0，0
 gray128,128,128
 */

@interface DBTempreatureLineViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

{
    

    
    
    //当前时间角标 年月日周季度
    NSInteger _currentYear;
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _weekIndex;
    NSInteger _quarterIndex;
    NSInteger _halfYearIndex;
}


/// 曲线图
@property (nonatomic, strong) DBLineView *lineView;


/**温升历史曲线*/
@property (nonatomic,weak) UIView *temHistoryView;
/** 温度检测 */
@property(nonatomic, strong) YWDeviceTemp *deviceTemp;
/**底部温度*/
@property (nonatomic,strong) UITableView *tempTableView;
/**遮盖*/
@property (weak, nonatomic) UIView *cover;

/**温升历史*/
@property (nonatomic,strong) YWChartGroup *chartData;

/// 记录需要展示的温度曲线
@property (nonatomic, strong) NSMutableArray *selectLineArray;




/// 环境温度button
@property (nonatomic, strong) UIButton *temButton;


/// x坐标轴数组
@property (nonatomic, strong) NSArray *xArray;


#pragma mark -- 平均
/**平均 最大值 最小值*/
@property (nonatomic,strong) NSArray *avgeArray;
/**参数数组 avg平均 max最大 min最小 */
@property (nonatomic,strong) NSArray *avgeKeyArray;
/**平均值*/
@property (nonatomic,copy) NSString *avgeStr;
/**平均button*/
@property (nonatomic,strong) UIButton *avgeBtn;
/**平均tableView*/
@property (nonatomic,strong) UITableView *avgeTableView;
/**遮盖*/
@property (weak, nonatomic) UIView *avgeLine;
/// 角标
@property (nonatomic, assign) NSInteger avgeSelectIndex;

#pragma mark -- 日期类型
/**时间类型*/
@property (nonatomic,copy) NSString *timeTypeStr;
/**时间类型数组  1小时 1天 1周 1月 3个月 6个月 1年*/
@property (nonatomic,strong) NSArray *timeTypeArray;
/**时间类型button*/
@property (nonatomic,strong) UIButton *timeTypeButton;
/**遮盖*/
@property (weak, nonatomic) UIView *timeTypeLine;
/**时间类型tableView*/
@property (nonatomic,strong) UITableView *timeTypeTableView;
/// 角标
@property (nonatomic, assign) NSInteger timeTypeSelectIndex;
/// 时间类型  参数数组
@property (nonatomic,retain) NSArray *timeTypeKeyArray;


#pragma mark -- 日期
/**日期button*/
@property (nonatomic,strong) UIButton *timeButton;
/**遮盖*/
@property (weak, nonatomic) UIView *timeLine;
/// 日期选择器
@property (nonatomic,retain) UIPickerView *datePickerView;


//日期数组
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSArray *halfYearArray;
@property (nonatomic, strong) NSArray *quartArray;



@end

@implementation DBTempreatureLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    //配置默认初始值 （此方法必须写在开始）
    [self configDefaultSetting];
    
    //获取曲线数据
    [self getHistorycharData];
    
    //获取设备温度信息 - 加载数据
    [self getDeviceDetil];
    
    //布局UI界面
    [self createUI];
    
    //状态监测图(button)
    [self setupTempView];

    //    初始化pickView表盘
    [self createPickerView];
    
    
    
    //监听通知
    [YWNotificationCenter addObserver:self selector:@selector(avegeChange:) name:YWAvegeValueDidChangeNotification object:nil];
    
    [YWNotificationCenter addObserver:self selector:@selector(timeTypeChange:) name:YWWeekValueDidChangeNotification object:nil];
    
    
}

#pragma mark -- 获取当前时间
- (void)getCurrentTime{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 指定获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | kCFCalendarUnitQuarter | NSCalendarUnitWeekOfYear | NSCalendarUnitQuarter;
    
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt];
    
    
    _currentYear = comp.year;
    _yearIndex = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld", (long)comp.year]];
    _monthIndex = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%.2ld", (long)comp.month]];
    _dayIndex = [self.dayArray indexOfObject:[NSString stringWithFormat:@"%.2ld", (long)comp.day]];
    _hourIndex = [self.hourArray indexOfObject:[NSString stringWithFormat:@"%.2ld", (long)comp.hour]];
    _weekIndex = [self.weekArray indexOfObject:[NSString stringWithFormat:@"%.2ld", (long)comp.weekOfYear]];
    if (_monthIndex >= 0 && _monthIndex < 3) {
        _quarterIndex = 0;
        _halfYearIndex = 0;
        
    }else if (_monthIndex >= 3 && _monthIndex < 6){
        _quarterIndex = 1;
        _halfYearIndex = 0;
        
    }else if (_monthIndex >= 6 && _monthIndex < 9){
        _quarterIndex = 2;
        _halfYearIndex = 1;
        
    }else{
        _quarterIndex = 3;
        _halfYearIndex = 1;
    }
    
}


#pragma mark -- 初始化数据
- (void)configDefaultSetting{
    //获取当前时间
    [self getCurrentTime];
    
    //默认平均值
    self.avgeSelectIndex = 0;
    //默认当天
    self.timeTypeSelectIndex = 1;
    
}

//发送请求获取曲线数据
- (void)getHistorycharData{
    
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_history.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"a_id"] = self.a_id;
    /**avg平均 max最大 min最小*/
    params[@"model"] = self.avgeKeyArray[self.avgeSelectIndex];
    /**h小时 d天 w周 m月  hy半年 y年*/
    params[@"type"] = self.timeTypeKeyArray[self.timeTypeSelectIndex];
    
   if (self.timeTypeSelectIndex == 0) {//h
       params[@"time"] = [NSString stringWithFormat:@"%@%@%@%@", [self currentYear], [self currentMonth], [self currentDay], [self currentHour]];
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        params[@"time"] = [NSString stringWithFormat:@"%@%@%@", [self currentYear], [self currentMonth], [self currentDay]];
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        params[@"time"] = [NSString stringWithFormat:@"%@%@", [self currentYear], [self currentWeek]];
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        params[@"time"] = [NSString stringWithFormat:@"%@%@", [self currentYear], [self currentMonth]];
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        params[@"time"] = [NSString stringWithFormat:@"%@%@", [self currentYear], [self currentQuart]];
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        params[@"time"] = [NSString stringWithFormat:@"%@%@", [self currentYear], [self currentHalfYear]];
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        params[@"time"] = [NSString stringWithFormat:@"%@", [self currentYear]];
    }
    
    
    //说明是哪条曲线
    params[@"num"] = [self.selectLineArray componentsJoinedByString:@","];
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    
    YWLog(@"曲线参数--%@",params);
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        
        NSMutableDictionary *chartDict = responseObj[@"data"];
        YWLog(@"数据曲线：%@", chartDict);
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        
        if ([status isEqual:@1]) { // 数据
            [SVProgressHUD dismiss];

            self.chartData = [YWChartGroup mj_objectWithKeyValues:chartDict];
            self.lineView.chartData = self.chartData;
  
        }else{
            
            [SVProgressHUD showInfoWithStatus:msg];
            self.lineView.chartData = [YWChartGroup mj_objectWithKeyValues:@{}];

        }
        self.lineView.xLabelTitleArray = self.xArray[self.timeTypeSelectIndex];

        

        
        [self.lineView setNeedsDisplay];

        
    } failure:^(NSError *error) {
             
        [SVProgressHUD dismiss];

        YWLog(@"历史曲线--%@",error);
        
    }];
    
}




//用户模型数据
- (void)avegeChange:(NSNotification *)notifacation
{
    //取出用户模型
    NSString *avgeStr = notifacation.userInfo[YWAvegeValueDidChange];
    self.avgeStr  = avgeStr;
    //用户昵称
    if (self.avgeStr) {
        
        [self getHistorycharData];
    }
    
}

#pragma mark -- 中间button的通知shi'jian
- (void)timeTypeChange:(NSNotification *)notifacation
{
    //取出用户模型
    NSString *timeTypeStr = notifacation.userInfo[YWWeekValueDidChange];
    self.timeTypeStr  = timeTypeStr;
        [self configTimeButtonTitle:self.timeButton];
 
    
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
        //        NSDictionary *statusDict = responseObj[@"data"][@"status"];
        
        NSArray *temperatureDict = responseObj[@"data"][@"temperature"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        //YWLog(@"设备列表--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            //温升
            self.deviceTemp = [YWDeviceTemp mj_objectWithKeyValues:temperatureDict];
            NSString *cstr = [NSString stringWithFormat:@"%@℃",self.deviceTemp.ambient];
            [self.temButton setTitle:cstr forState:UIControlStateNormal];
            
            //获得模型数据
            [self.tempTableView reloadData];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}



//布局UI界面
- (void)createUI{
    //曲线图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10,0, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.55)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.temHistoryView = bgView;
    
    //温升曲线
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.userInteractionEnabled = NO;
    titleButton.titleLabel.font = FONT_15;
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    //temHistoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [titleButton setTitle:@"温升曲线" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"icondyq1"] forState:UIControlStateNormal];
    titleButton.frame = CGRectMake(10,10, 100, 18);
    [bgView addSubview:titleButton];
    
    
    
    //选择栏
    UIView *dateBar = [[UIView alloc] init];
    CGFloat dateBarY = CGRectGetMaxY(titleButton.frame)+5;
    dateBar.frame = CGRectMake(0,dateBarY, bgView.width, 35);
    [bgView addSubview:dateBar];
    
    
    //平均 最大 最小
    UIButton *average = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avgeBtn = average;
    average.titleLabel.font = FONT_13;
    average.layer.borderWidth = 0.8;
    average.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [average setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [average addTarget:self action:@selector(averageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat averageW = SCREEN_WIDTH*0.20;
    average.frame = CGRectMake(YWMargin, 5, averageW, dateBar.height - 5);
    [average setTitle:self.avgeArray[self.avgeSelectIndex] forState:UIControlStateNormal];
    [average setTitle:@"确定" forState:UIControlStateSelected];
    UIView *line1 = [[UIView alloc] init];
    self.avgeLine = line1;
    line1.backgroundColor = [UIColor lightGrayColor];
    line1.frame = CGRectMake(0, 0, averageW, 5);
    [average addSubview:line1];
    [dateBar addSubview:average];
    
    
    
    //1小时 1天 1周 1一个月 3个月 6个月  1年
    UIButton *timeTypeButton = [[UIButton alloc] init];
    self.timeTypeButton = timeTypeButton;
    timeTypeButton.titleLabel.font = FONT_13;
    [timeTypeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [timeTypeButton addTarget:self action:@selector(timeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    timeTypeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    timeTypeButton.layer.borderWidth = 0.8;
    timeTypeButton.frame = CGRectMake(YWMargin+5+averageW, 5, averageW, dateBar.height - 5);
    [timeTypeButton setTitle:self.timeTypeArray[self.timeTypeSelectIndex] forState:UIControlStateNormal];
    [timeTypeButton setTitle:@"确定" forState:UIControlStateSelected];
    UIView *timeTypeLine = [[UIView alloc] init];
    self.timeTypeLine = timeTypeLine;
    timeTypeLine.backgroundColor = [UIColor lightGrayColor];
    timeTypeLine.frame = CGRectMake(0, 0,averageW, 5);
    [timeTypeButton addSubview:timeTypeLine];
    [dateBar addSubview:timeTypeButton];
    
    //具体时间
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.titleLabel.font = FONT_13;
    self.timeButton = timeButton;
    [timeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    timeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    timeButton.layer.borderWidth = 0.8;
    CGFloat allBtnW = dateBar.width-averageW*2-YWMargin*2-10;
    timeButton.frame = CGRectMake(YWMargin+10+averageW*2, 5, allBtnW, dateBar.height - 5);
    [timeButton addTarget:self action:@selector(timebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self configTimeButtonTitle:timeButton];
    [timeButton setTitle:@"确定" forState:UIControlStateSelected];
    UIView *timeLine = [[UIView alloc] init];
    timeLine.backgroundColor = [UIColor lightGrayColor];
    timeLine.frame = CGRectMake(0, 0, allBtnW, 5);
    self.timeLine = timeLine;
    [timeButton addSubview:timeLine];
    [dateBar addSubview:timeButton];
    
    
    //曲线图
    CGFloat lineChartY = CGRectGetMaxY(dateBar.frame)+15;
    CGFloat temButtonHeight = 25;
    
    CGRect rect = CGRectMake(0,lineChartY,SCREEN_WIDTH, bgView.height-lineChartY - temButtonHeight);
    
    DBLineView *lineView = [[DBLineView alloc] initWithFrame:rect];
    [self.temHistoryView addSubview:lineView];
    
    _lineView = lineView;
    
    
    
    //环境温度：
    UILabel *temlabel = [[UILabel alloc] init];
    temlabel.frame = CGRectMake(CGRectGetMinX(titleButton.frame)+10, CGRectGetMaxY(self.lineView.frame), 100, temButtonHeight);
    temlabel.font = [UIFont boldSystemFontOfSize:14];
    temlabel.text =@"环境温度：";
    temlabel.textAlignment = NSTextAlignmentCenter;
    temlabel.backgroundColor = [UIColor whiteColor];
    temlabel.textColor = [UIColor darkGrayColor];
    [self.temHistoryView addSubview:temlabel];
    
    UIButton *temButton = [[UIButton alloc] init];
    temButton.frame = CGRectMake(CGRectGetMaxX(temlabel.frame), CGRectGetMinY(temlabel.frame), kTemperatureButtonWidth, temButtonHeight);
    temButton.backgroundColor = YWColor(65,105,225);
    temButton.selected = YES;
    temButton.layer.masksToBounds = YES;
    temButton.layer.cornerRadius = 3;
    temButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [temButton addTarget:self action:@selector(temButtonCLicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.temHistoryView addSubview:temButton];
    self.temButton = temButton;
    
}

- (void)temButtonCLicked:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = YWColor(65,105,225);
        if ([self.selectLineArray containsObject:@"10"]) {
        }else{
            [self.selectLineArray addObject:@"10"];
        }
    } else {
        button.backgroundColor = YWColor(128,128,128);
        
        if ([self.selectLineArray containsObject:@"10"]) {
            [self.selectLineArray removeObject:@"10"];
        }else{
        }
        
    }
    [self getHistorycharData];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}



//状态监测图
- (void)setupTempView
{
    //创建状态监测view
    CGFloat tempTabViewY = CGRectGetMaxY(self.temHistoryView.frame);
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(10, tempTabViewY, SCREEN_WIDTH-20, SCREEN_HEIGHT*0.3)];
    //表格控件
    CGFloat tempTabViewW = SCREEN_WIDTH-40;
    CGFloat tempTabViewH = SCREEN_HEIGHT*0.3-40;
    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10,tempTabViewW, tempTabViewH) style:UITableViewStylePlain];
    self.tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tempTableView.dataSource = self;
    self.tempTableView.delegate = self;
    self.tempTableView.scrollEnabled = NO;
    [tempView addSubview:self.tempTableView];
    
    [self.view addSubview:tempView];
    
}

#pragma mark -- 平均值点击事项
- (void)averageBtnClick:(UIButton *)btn
{
    if (self.timeTypeButton.isSelected == YES) {//选中
        self.timeTypeButton.selected = NO;
        self.timeTypeLine.backgroundColor = [UIColor lightGrayColor];
        self.timeTypeTableView.hidden = YES;
        [self weekViewViewPop];
    }
    if (self.timeButton.selected == YES) {//选中年
        self.timeButton.selected = NO;
        self.timeLine.backgroundColor = [UIColor lightGrayColor];
        self.datePickerView.hidden = YES;
    }
    
    
    if (self.avgeStr.length == 0) {
        self.avgeStr = self.avgeArray[0];
    }
    UIButton *button = (UIButton *)btn;
    button.selected = !button.selected;
    if (button.isSelected == YES) {//选中
        self.avgeLine.backgroundColor = YWColor(28, 144, 231);
        self.avgeTableView.hidden = NO;
    }else{
        self.avgeLine.backgroundColor = [UIColor lightGrayColor];
        self.avgeTableView.hidden = YES;
    }
    [self avgeViewViewPop];
}
/**
 *  弹出view
 */
- (void)avgeViewViewPop
{
    CGFloat duration = 0.25;
    if (self.cover == nil) {
        // 1.添加遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0;
        [cover addTarget:self action:@selector(avgeViewViewPop) forControlEvents:UIControlEventTouchUpInside];
        self.cover = cover;
        self.avgeTableView.hidden = NO;
        // 2.添加loginView到最中间
        [self.view bringSubviewToFront:self.avgeTableView];
        [self.view insertSubview:cover belowSubview:self.avgeTableView];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.view addSubview:self.avgeTableView];
            
        }];
    } else {
        
        [self.cover removeFromSuperview];
        self.avgeTableView.hidden = YES;
        [self.avgeTableView removeFromSuperview];
        self.cover = nil;
    }
    
}
#pragma mark -- 时间类型点击事项
- (void)timeTypeButtonClick:(UIButton *)btn
{
    if (self.avgeBtn.isSelected == YES) {//选中
        self.avgeBtn.selected = NO;
        self.avgeLine.backgroundColor = [UIColor lightGrayColor];
        self.avgeTableView.hidden = YES;
        [self avgeViewViewPop];
        
    }
    
    if (self.timeButton.selected == YES) {//选中年
        self.timeButton.selected = NO;
        self.timeLine.backgroundColor = [UIColor lightGrayColor];
        self.datePickerView.hidden = YES;
    }
    
    
    
    if (self.timeTypeStr.length == 0) {
        self.timeTypeStr = self.timeTypeArray[0];
    }
    UIButton *button = (UIButton *)btn;
    button.selected = !button.selected;
    if (button.isSelected == YES) {//选中
        self.timeTypeLine.backgroundColor = YWColor(28, 144, 231);
        self.timeTypeTableView.hidden = NO;
    }else{
        self.timeTypeLine.backgroundColor = [UIColor lightGrayColor];
        self.timeTypeTableView.hidden = YES;
    }
    [self weekViewViewPop];
}
/**
 *  弹出view
 */
- (void)weekViewViewPop
{
    CGFloat duration = 0.25;
    if (self.cover == nil) {
        // 1.添加遮盖
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = self.view.bounds;
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0;
        [cover addTarget:self action:@selector(weekViewViewPop) forControlEvents:UIControlEventTouchUpInside];
        self.cover = cover;
        self.timeTypeTableView.hidden = NO;
        // 2.添加View到最中间
        [self.view bringSubviewToFront:self.timeTypeTableView];
        [self.view insertSubview:cover belowSubview:self.timeTypeTableView];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.view addSubview:self.timeTypeTableView];
            
        }];
    } else {
        
        [self.cover removeFromSuperview];
        self.timeTypeTableView.hidden = YES;
        [self.timeTypeTableView removeFromSuperview];
        self.cover = nil;
    }
}

#pragma mark -- 选择日期点击事项
- (void)timebuttonClick:(UIButton *)btn{
    if (self.timeTypeButton.isSelected == YES) {//选中
        self.timeTypeButton.selected = NO;
        self.timeTypeLine.backgroundColor = [UIColor lightGrayColor];
        self.timeTypeTableView.hidden = YES;
        [self weekViewViewPop];
        
    }
    if (self.avgeBtn.isSelected == YES) {//选中
        self.avgeBtn.selected = NO;
        self.avgeLine.backgroundColor = [UIColor lightGrayColor];
        self.avgeTableView.hidden = YES;
        [self avgeViewViewPop];
    }
    
    UIButton *button = (UIButton *)btn;
    [self configTimeButtonTitle: button];
    
    
    button.selected = !button.selected;
    if (button.isSelected == YES) {//选中
        self.timeLine.backgroundColor = YWColor(28, 144, 231);
        self.datePickerView.hidden = NO;
    }else{
        self.timeLine.backgroundColor = [UIColor lightGrayColor];
        self.datePickerView.hidden = YES;
        
        [self getHistorycharData];
        
    }
}






- (NSString *)currentYear{
    return self.yearArray[_yearIndex];
}

- (NSString *)currentMonth{
    return self.monthArray[_monthIndex];
}

- (NSString *)currentDay{
    return self.dayArray[_dayIndex];
}

- (NSString *)currentHour{
    return self.hourArray[_hourIndex];
}

- (NSString *)currentWeek{
    return self.weekArray[_weekIndex];
}

- (NSString *)currentQuart{
    return self.quartArray[_quarterIndex];
}

- (NSString *)currentHalfYear{
    return self.halfYearArray[_halfYearIndex];
}

#pragma mark -- 设置时间button 标题
- (void)configTimeButtonTitle: (UIButton *)button{
    
    if (self.timeTypeSelectIndex == 0) {//h
        NSString *h = [NSString stringWithFormat:@"%@-%@-%@ %@:00", [self currentYear], [self currentMonth], [self currentDay], [self currentHour]];
        [button setTitle:h forState:UIControlStateNormal];
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        NSString *d = [NSString stringWithFormat:@"%@-%@-%@", [self currentYear], [self currentMonth], [self currentDay]];
        [button setTitle:d forState:UIControlStateNormal];
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        NSString *w = [NSString stringWithFormat:@"%@年第%@周", [self currentYear], [self currentWeek]];
        [button setTitle:w forState:UIControlStateNormal];
        
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        NSString *m = [NSString stringWithFormat:@"%@年%@月", [self currentYear], [self currentMonth]];
        [button setTitle:m forState:UIControlStateNormal];
        
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        NSString *q = [NSString stringWithFormat:@"%@年第%@季度", [self currentYear], [self currentQuart]];
        [button setTitle:q forState:UIControlStateNormal];
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        
        NSString *str = ([[self currentHalfYear] intValue] > 0) ? @"下半年" : @"下半年";
        NSString *hy = [NSString stringWithFormat:@"%@年%@", [self currentYear], str];
        [button setTitle:hy forState:UIControlStateNormal];
        
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        NSString *y = [NSString stringWithFormat:@"%@年", [self currentYear]];
        [button setTitle:y forState:UIControlStateNormal];
    }
    
    
}






#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.avgeTableView) {
        return self.avgeArray.count;
    } else if (tableView == self.timeTypeTableView) {
        return self.timeTypeArray.count;
    }
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.avgeTableView) {
        //创建cell
        YXButtonViewCell *cell = [YXButtonViewCell cellWithTableView:tableView];
        [cell.titleBtn setTitle:self.avgeArray[indexPath.row] forState:UIControlStateNormal];
        cell.backgroundColor = BGCLOLOR;
        cell.didTapTimeBtn = ^(UIButton *timeBtn) {
            
        };
        return cell;
        
        
    } else if (tableView == self.timeTypeTableView) {
        
        //创建cell
        YXButtonViewCell *cell = [YXButtonViewCell cellWithTableView:tableView];
        cell.backgroundColor = BGCLOLOR;
        [cell.titleBtn setTitle:self.timeTypeArray[indexPath.row] forState:UIControlStateNormal];
        cell.didTapTimeBtn = ^(UIButton *timeBtn) {
            
        };
        return cell;
        
    }
    
    //创建cell  --- 9个button
    YWHistoryTempCell *cell = [YWHistoryTempCell cellWithTableView:tableView];
    
    if (indexPath.row == 1) {
        //调用A回调方法
        cell.didTapABtn = ^(UIButton *abtn) {
            if (abtn.selected) {
                abtn.backgroundColor = YWColor(254, 124, 0);
                if ([self.selectLineArray containsObject:@"1"]) {
                }else{
                    [self.selectLineArray addObject:@"1"];
                }
                
            } else {
                abtn.backgroundColor = YWColor(128, 128,128);
                if ([self.selectLineArray containsObject:@"1"]) {
                    [self.selectLineArray removeObject:@"1"];
                }else{
                }
            }
            
            [self getHistorycharData];
        };
        
        //调用B回调方法
        cell.didTapBBtn = ^(UIButton *bbtn) {
            if (bbtn.selected) {
                bbtn.backgroundColor = YWColor(0, 100, 0);
                if ([self.selectLineArray containsObject:@"2"]) {
                }else{
                    [self.selectLineArray addObject:@"2"];
                }
                
            } else {
                bbtn.backgroundColor = YWColor(128, 128,128);
                if ([self.selectLineArray containsObject:@"2"]) {
                    [self.selectLineArray removeObject:@"2"];
                }else{
                }
            }
            [self getHistorycharData];

        };
        
        //调用C回调方法
        cell.didTapCBtn = ^(UIButton *cbtn) {
            if (cbtn.selected) {
                cbtn.backgroundColor = YWColor(139, 0, 0);
                if ([self.selectLineArray containsObject:@"3"]) {
                }else{
                    [self.selectLineArray addObject:@"3"];
                }
            } else {
                cbtn.backgroundColor = YWColor(128, 128,128);
                if ([self.selectLineArray containsObject:@"3"]) {
                    [self.selectLineArray removeObject:@"3"];
                }else{
                }
                
            }
            [self getHistorycharData];

        };
    } else if (indexPath.row == 2){
        //调用A回调方法
        cell.didTapABtn = ^(UIButton *abtn) {
            if (abtn.selected) {
                abtn.backgroundColor = YWColor(250, 181, 26);
                if ([self.selectLineArray containsObject:@"4"]) {
                }else{
                    [self.selectLineArray addObject:@"4"];
                }
            } else {
                abtn.backgroundColor = YWColor(128, 128,128);
                
                if ([self.selectLineArray containsObject:@"4"]) {
                    [self.selectLineArray removeObject:@"4"];
                }else{
                }
                
            }
            [self getHistorycharData];

        };
        
        //调用B回调方法
        cell.didTapBBtn = ^(UIButton *bbtn) {
            if (bbtn.selected) {
                bbtn.backgroundColor = YWColor(50, 205, 50);
                if ([self.selectLineArray containsObject:@"5"]) {
                }else{
                    [self.selectLineArray addObject:@"5"];
                }
            } else {
                bbtn.backgroundColor = YWColor(128, 128,128);
                if ([self.selectLineArray containsObject:@"5"]) {
                    [self.selectLineArray removeObject:@"5"];
                }else{
                }
            }
            [self getHistorycharData];

        };
        
        //调用C回调方法
        cell.didTapCBtn = ^(UIButton *cbtn) {
            if (cbtn.selected) {
                cbtn.backgroundColor = YWColor(255, 0, 0);
                
                if ([self.selectLineArray containsObject:@"6"]) {
                }else{
                    [self.selectLineArray addObject:@"6"];
                }
            } else {
                cbtn.backgroundColor = YWColor(128, 128,128);
                if ([self.selectLineArray containsObject:@"6"]) {
                    [self.selectLineArray removeObject:@"6"];
                }else{
                }
            }
            [self getHistorycharData];

        };
    }
    //设置数据
    if (indexPath.row == 0) {
        
        cell.statusBtn.hidden = YES;
        [cell.tempBtn3 setTitle:@"A相" forState:UIControlStateNormal];
        [cell.tempBtn2 setTitle:@"B相" forState:UIControlStateNormal];
        [cell.tempBtn1 setTitle:@"C相" forState:UIControlStateNormal];
        [cell.tempBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cell.tempBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cell.tempBtn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
    }else if (indexPath.row == 1) {
        cell.tempInfo = self.deviceTemp.up;
        [cell.statusBtn setTitle:@"上触指" forState:UIControlStateNormal];
        [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq8"] forState:UIControlStateNormal];
        [cell.tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.tempBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.tempBtn3.backgroundColor = YWColor(254,124,0);
        cell.tempBtn2.backgroundColor = YWColor(0,100,0);
        cell.tempBtn1.backgroundColor = YWColor(139,0,0);
        
    }else if (indexPath.row == 2) {
        cell.tempInfo = self.deviceTemp.down;
        [cell.statusBtn setTitle:@"下触指" forState:UIControlStateNormal];
        [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq8"] forState:UIControlStateNormal];
        
        [cell.tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.tempBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        cell.tempBtn3.backgroundColor = YWColor(250,181,26);
        cell.tempBtn2.backgroundColor = YWColor(50,205,50);
        cell.tempBtn1.backgroundColor = YWColor(255,0,0);
        
    }else if (indexPath.row == 3) {
        cell.tempInfo = self.deviceTemp.connect;
        [cell.statusBtn setTitle:@"电缆头" forState:UIControlStateNormal];
        [cell.statusBtn setImage:[UIImage imageNamed:@"icondyq9"] forState:UIControlStateNormal];
        
        cell.tempBtn3.backgroundColor = YWColor(128, 128, 128);
        cell.tempBtn2.backgroundColor = YWColor(128, 128, 128);
        cell.tempBtn1.backgroundColor = YWColor(128, 128, 128);
        [cell.tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.tempBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.tempBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return cell;
    
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell的高度
    if (tableView == self.avgeTableView ||tableView == self.timeTypeTableView) {
        return 30;
    } else{
        if (indexPath.row == 0) {
            return 18;
        }
        return 28;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.avgeTableView) {//平均值
        
        self.avgeSelectIndex = indexPath.row;
        
        self.avgeBtn.selected = !self.avgeBtn.selected;
        if (self.avgeBtn.isSelected == YES) {//选中
            self.avgeLine.backgroundColor = YWColor(28, 144, 231);
            self.avgeTableView.hidden = NO;
        }else{
            self.avgeLine.backgroundColor = [UIColor lightGrayColor];
            self.avgeTableView.hidden = YES;
        }
        
        NSString *avgeStr = self.avgeArray[indexPath.row];
        [self.avgeBtn setTitle:avgeStr forState:UIControlStateNormal];
        self.avgeStr = avgeStr;
        
        [self avgeViewViewPop];
        
        //平均值改变
        [YWNotificationCenter postNotificationName:YWAvegeValueDidChangeNotification object:self userInfo:@{YWAvegeValueDidChange:avgeStr}];
        
        [self getHistorycharData];
        
    } else if (tableView == self.timeTypeTableView)  {//日期
        
        self.timeTypeSelectIndex = indexPath.row;
        
        self.timeTypeButton.selected = !self.timeTypeButton.selected;
        if (self.timeTypeButton.isSelected == YES) {//选中
            self.timeTypeLine.backgroundColor = YWColor(28, 144, 231);
            self.timeTypeTableView.hidden = NO;
        }else{
            self.timeTypeLine.backgroundColor = [UIColor lightGrayColor];
            self.timeTypeTableView.hidden = YES;
        }
        
        NSString *weakStr = self.timeTypeArray[indexPath.row];
        [self.timeTypeButton setTitle:weakStr forState:UIControlStateNormal];
        self.timeTypeStr = weakStr;
        
        [self weekViewViewPop];
        
        //创建pickView
        [self createPickerView];
        
        
        
        //日期改变
        [YWNotificationCenter postNotificationName:YWWeekValueDidChangeNotification object:self userInfo:@{YWWeekValueDidChange:weakStr}];
        
        [self getHistorycharData];
    }
    
}






- (UITableView *)timeTypeTableView
{
    CGFloat averageW = SCREEN_WIDTH*0.20;
    
    if (!_timeTypeTableView) {
        _timeTypeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _timeTypeTableView.delegate = self;
        _timeTypeTableView.hidden = YES;
        _timeTypeTableView.dataSource = self;
        _timeTypeTableView.scrollEnabled = NO;
        _timeTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _timeTypeTableView.backgroundColor = BGCLOLOR;
        _timeTypeTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_timeTypeTableView];
        _timeTypeTableView.frame = CGRectMake(20 + averageW + 5,68,averageW,210);
    }
    return _timeTypeTableView;
}

- (NSArray *)timeTypeArray{
    if (!_timeTypeArray) {
        _timeTypeArray = @[@"1小时",@"1天",@"1周",@"1个月",@"3个月",@"6个月",@"1年"];
    }
    return _timeTypeArray;
}

- (NSMutableArray *)selectLineArray{
    if (_selectLineArray == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NSArray *numarray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"10"];
        [array addObjectsFromArray:numarray];
        _selectLineArray = array;
    }
    return _selectLineArray;
}



#pragma mark -- 日期选择 UIPickerView 代理方法
-  (void)createPickerView{
    CGFloat pickerY = CGRectGetMaxY(self.timeButton.frame)+35;
    self.datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,pickerY, SCREEN_WIDTH,300)];
    self.datePickerView.backgroundColor = BGCLOLOR;
    self.datePickerView.dataSource = self;
    self.datePickerView.delegate = self;
    self.datePickerView.showsSelectionIndicator = YES;
    self.datePickerView.hidden = YES;
    
    [self configPickerViewDefaultDate];
    
    [self.view addSubview:self.datePickerView];
}

- (void)configPickerViewDefaultDate{
    
    if (self.timeTypeSelectIndex == 0) {//h 年月日 时
        
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        [self.datePickerView selectRow:_monthIndex inComponent:1 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_monthIndex inComponent:1];
        
        [self.datePickerView selectRow:_dayIndex inComponent:2 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_dayIndex inComponent:2];
        
        [self.datePickerView selectRow:_hourIndex inComponent:3 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_hourIndex inComponent:3];
        
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        [self.datePickerView selectRow:_monthIndex inComponent:1 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_monthIndex inComponent:1];
        
        [self.datePickerView selectRow:_dayIndex inComponent:2 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_dayIndex inComponent:2];
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        [self.datePickerView selectRow:_weekIndex inComponent:1 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_weekIndex inComponent:1];
        
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        [self.datePickerView selectRow:_monthIndex inComponent:1 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_monthIndex inComponent:1];
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        [self.datePickerView selectRow:_quarterIndex inComponent:1 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_quarterIndex inComponent:1];
        
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        [self.datePickerView selectRow:_halfYearIndex inComponent:1 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_halfYearIndex inComponent:1];
        
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        [self.datePickerView selectRow:_yearIndex inComponent:0 animated:YES];
        [self pickerView:self.datePickerView didSelectRow:_yearIndex inComponent:0];
        
        
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.timeTypeSelectIndex == 0) {//h
        
        if (component ==0) {//年
            _yearIndex = row;
         
        }
        if(component == 1){
            _monthIndex = row;
     
            
        }
        if(component == 2){//日
            _dayIndex = row;
        }
        if(component == 3){//小时
            _hourIndex = row;
        }
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        if (component ==0) {//年
            _yearIndex = row;
        }
        if(component == 1){
            _monthIndex = row;
        }
        if(component == 2){//日
            _dayIndex = row;
        }
        
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        if (component == 0) {
            _yearIndex = row;
        }
        if (component == 1) {
            _weekIndex = row;
        }
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        if (component == 0) {
            _yearIndex = row;
        }
        if (component == 1) {
            _monthIndex = row;
        }
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        if (component == 0) {
            _yearIndex = row;
        }
        if (component == 1) {
            _quarterIndex = row;
        }
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        if (component == 0) {
            _yearIndex = row;
        }
        if (component == 1) {
            _halfYearIndex = row;
        }
        
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        _yearIndex = row;
    }
    
    
    
    
    
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (self.timeTypeSelectIndex == 0) {//h
        return 75;
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        return 100;
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        return 150;
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        return 150;
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        return 150;
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        return 150;
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        return 300;
    }
    
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35.0;
}
//指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.timeTypeSelectIndex == 0) {//h
        
        if (component ==0) {//年
            return self.yearArray.count;
            
        }
        if(component == 1){//月
            return self.monthArray.count;
            
        }
        if(component == 2){//日
            return self.dayArray.count;
        }
        if(component == 3){//小时
            return self.hourArray.count;
        }
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        if (component ==0) {//年
            return self.yearArray.count;
            
        }
        if(component == 1){//月
            return self.monthArray.count;
            
        }
        if(component == 2){//日
            return self.dayArray.count;
        }
        
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        if (component == 0) {
            return self.yearArray.count;
        }
        if (component == 1) {
            return self.weekArray.count;
        }
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        if (component == 0) {
            return self.yearArray.count;
        }
        if (component == 1) {
            return self.monthArray.count;
        }
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        if (component == 0) {
            return self.yearArray.count;
        }
        if (component == 1) {
            return self.quartArray.count;
        }
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        if (component == 0) {
            return self.yearArray.count;
        }
        if (component == 1) {
            return self.halfYearArray.count;
            
        }
        
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        return self.yearArray.count;
    }
    
    return 0;
    
    
}
//指定pickerview有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.timeTypeSelectIndex == 0) {//h
        return 4;
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        return 3;
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        return 2;
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        return 2;
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        return 2;
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        return 2;
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        return 1;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    YXCustomDateView *dateView = [[YXCustomDateView alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
    
    if (self.timeTypeSelectIndex == 0) {//h
        switch (component)
              {
                  case 0://year
                      dateView.titleStr = [self.yearArray objectAtIndex:row];
                      break;
                  case 1://month
                      dateView.titleStr = [self.monthArray objectAtIndex:row];
                      break;
                  case 2://day
                      if (row == 0)
                          dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
                      else if (row == 1)
                          dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
                      else if (row == 2)
                          dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
                      else
                          dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%d", ""),row+1];
                      break;
                  case 3://h
                      dateView.titleStr = [NSString stringWithFormat:@"%ld:00",(long)row];
                      break;
                  default:
                      break;
              }
    }
    
    if (self.timeTypeSelectIndex == 1) {//d
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.yearArray objectAtIndex:row];
                break;
            case 1://month
                dateView.titleStr = [self.monthArray objectAtIndex:row];
                break;
            case 2://day
                if (row == 0)
                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%dst", ""),row+1];
                else if (row == 1)
                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%dnd", ""),row+1];
                else if (row == 2)
                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%drd", ""),row+1];
                else
                    dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"%dth", ""),row+1];
                break;
            default:
                break;
        }
    }
    
    if (self.timeTypeSelectIndex == 2) {//w
        switch (component)
               {
                   case 0://year
                       dateView.titleStr = [self.yearArray objectAtIndex:row];
                       break;
                   case 1://week
                       dateView.frame = CGRectMake(0, 0, 150,40);
                       dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"第%d周", ""),row+1];
                       break;
                   default:
                       break;
               }
    }
    
    if (self.timeTypeSelectIndex == 3) {//m
        switch (component)
              {
                  case 0://year
                      dateView.titleStr = [self.yearArray objectAtIndex:row];
                      break;
                  case 1://month
                      dateView.titleStr = [self.monthArray objectAtIndex:row];
                      break;
                  default:
                      break;
              }
    }
    
    if (self.timeTypeSelectIndex == 4) {//q
        switch (component)
               {
                   case 0://year
                       dateView.titleStr = [self.yearArray objectAtIndex:row];
                       break;
                   case 1://quarter
                   {
                       NSString *str =nil;
                       if (row ==0) {
                           str = NSLocalizedString(@"第一季度", "");
                       }
                       else if (row ==1)
                       {
                           str = NSLocalizedString(@"第二季度", "");
                       }
                       else if (row ==2)
                       {
                           str = NSLocalizedString(@"第三季度", "");
                       }
                       else
                       {
                           str = NSLocalizedString(@"第四季度", "");
                       }
                       dateView.frame = CGRectMake(0, 0, 150,40);
                       dateView.titleStr = str;
                       
                   }
                       break;
                   default:
                       break;
               }
    }
    
    if (self.timeTypeSelectIndex == 5) {//hy
        switch (component)
               {
                   case 0://year
                       dateView.titleStr = [self.yearArray objectAtIndex:row];
                       break;
                   case 1://半年
                   {
                       NSString *str =nil;
                       if (row ==0) {
                           str = NSLocalizedString(@"上半年", "");
                       }
                       else {
                           str = NSLocalizedString(@"下半年", "");
                       }
                       dateView.frame = CGRectMake(0, 0, 150,40);
                       dateView.titleStr = str;
                   }
                       break;
                   default:
                       break;
               }
    }
    
    if (self.timeTypeSelectIndex == 6) {//y
        dateView.titleStr = [self.yearArray objectAtIndex:row];
    }
 
    return dateView;
}





#pragma mark -- 初始化数据


- (NSArray *)timeTypeKeyArray{
    if (_timeTypeKeyArray == nil) {
        NSArray *array = [NSArray arrayWithObjects:@"h",@"d",@"w",@"m",@"q",@"hy",@"y",nil];
        _timeTypeKeyArray = array;
    }
    return _timeTypeKeyArray;
}



- (UITableView *)avgeTableView{
    CGFloat averageW = SCREEN_WIDTH*0.20;
    
    if (!_avgeTableView) {
        _avgeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _avgeTableView.delegate = self;
        _avgeTableView.hidden = YES;
        _avgeTableView.dataSource = self;
        _avgeTableView.scrollEnabled = NO;
        _avgeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _avgeTableView.backgroundColor = BGCLOLOR;
        _avgeTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_avgeTableView];
        _avgeTableView.frame = CGRectMake(20,68,averageW,90);
        
    }
    return _avgeTableView;
}

- (NSArray *)avgeArray{
    if (!_avgeArray) {
        _avgeArray = @[@"平均",@"最大值",@"最小值"];
    }
    return _avgeArray;
}

- (NSArray *)avgeKeyArray{
    if (_avgeKeyArray == nil) {//avg平均 max最大 min最小
        NSArray *array = @[@"avg",@"max",@"min"];
        _avgeKeyArray = array;
    }
    return _avgeKeyArray;;
}

//年份数组
- (NSArray *)yearArray{
    if (_yearArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i=_currentYear;i>2009;i--) {
            NSString *yearStr = [NSString stringWithFormat:@"%ld", (long)i];
            [array addObject:yearStr];
        }
        
        _yearArray = array;
    }
    return _yearArray;
}
//月份数组
- (NSArray *)monthArray{
    
    if (_monthArray == nil) {
        NSArray *array = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        _monthArray = array;
    }
    return _monthArray;
}

- (NSArray *)dayArray{
    if (_dayArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i<=31; i++) {
            [array addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        
        _dayArray = array;
    }
    return _dayArray;
}

- (NSArray *)weekArray{
    if (_weekArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i<=53; i++) {
            [array addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        _weekArray = array;
    }
    return _weekArray;
}

- (NSArray *)quartArray{
    if (_quartArray == nil) {
        NSArray *array = @[@"01",@"02",@"03",@"04"];
        _quartArray = array;
    }
    return _quartArray;
}

- (NSArray *)halfYearArray{
    if (_halfYearArray == nil) {
        NSArray *array = @[@"01",@"02"];
        _halfYearArray = array;
    }
    return _halfYearArray;
}

- (NSArray *)hourArray{
    if (_hourArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<24; i++) {
            [array addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        _hourArray = array;
    }
    return _hourArray;
}

- (NSArray *)xArray{
    if (_xArray == nil) {
//        NSArray *array = [NSArray arrayWithObjects:@"h",@"d",@"w",@"m",@"q",@"hy",@"y",nil];
        NSMutableArray *array = [NSMutableArray array];
     
        NSArray *harray = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60"];
        [array addObject:harray];
        
        NSMutableArray *dArray = [NSMutableArray array];
        for (int i = 0; i<=24; i++) {
            [dArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        [array addObject:dArray];
        
        NSArray *wArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        [array addObject:wArray];
        
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i<=30; i++) {
            if (i%2 == 0) {
                [mArray addObject:[NSString stringWithFormat:@"%d", i]];
            }
        }
        [array addObject:mArray];
        
        NSArray *qArray = @[@"0",@"1",@"2",@"3"];
        [array addObject:qArray];
        
        
        NSArray *hyArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
        [array addObject:hyArray];
        
        NSArray *yArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        [array addObject:yArray];
        
        _xArray = array;
        
    }
    return _xArray;
}


@end
