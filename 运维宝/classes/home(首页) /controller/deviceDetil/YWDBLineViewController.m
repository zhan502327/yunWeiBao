//
//  YWDBLineViewController.m
//  运维宝
//
//  Created by zhandb on 2017/12/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDBLineViewController.h"
#import "YWHistoryTempCell.h"
#import "YWMyDevice.h"
#import "YWDeviceTemp.h"
#import "JHChartHeader.h"
#import "SYLJDatePickerView.h"
#import "YWChartGroup.h"
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

/**
 A上254，124，0    A下250，181，26
 B上 0，100，0    B下50，205，50
 C上 139，0，0     C下255，0，0
 gray128,128,128
 */

@interface YWDBLineViewController ()
<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource, UIWebViewDelegate>
{
    
    //pickerview的第一单元focus
    NSInteger pick0compentfocusIndex;
    NSInteger pick1compentfocusIndex;
    NSInteger pick2compentfocusIndex;
    NSInteger pick3compentfocusIndex;
    
    
    
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
/**遮盖*/
@property (weak, nonatomic) UIView *cover;
/**遮盖*/
@property (weak, nonatomic) UIView *avgeLine;
/**遮盖*/
@property (weak, nonatomic) UIView *weekLine;
/**遮盖*/
@property (weak, nonatomic) UIView *dataLine;
/**温升历史*/
@property (nonatomic,strong) UITableView *avgeTableView;
/**温升历史*/
@property (nonatomic,strong) NSArray *avgeData;
/**温升历史*/
@property (nonatomic,strong) UITableView *timeTableView;
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


//x轴数组
@property (nonatomic,strong) NSMutableArray *dataX;
//Y轴数组
@property (nonatomic,retain) NSArray *chartArr;


/** 曲线图webview */
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *selectLineArray;
//获取默认的时间（当前时间）
@property (nonatomic, copy) NSString *defaultTimeStr;

//    时间button显示的title
@property (nonatomic, copy) NSString *timeTitleStr;


@end

@implementation YWDBLineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];//此方法必须写在开始
//    趋势分析
    //温升历史曲线
    [self setupTopSelectButton];
    
    //状态监测图(button)
    [self setupTempView];
    
    //获取设备温度信息 - 加载数据
    [self getDeviceDetil];
    
    
    [self initSectionOneDate];
//    初始化pickView表盘
    [self initSectionThirdDate];
    [self initPickerViewDate];
    [self createPickerView];
    

    //监听通知
    [YWNotificationCenter addObserver:self selector:@selector(avegeChange:) name:YWAvegeValueDidChangeNotification object:nil];
    
    [YWNotificationCenter addObserver:self selector:@selector(weekChange:) name:YWWeekValueDidChangeNotification object:nil];
    
    
}

#pragma mark -- 初始化数据
- (void)initData{
    self.selectIndex = 0;//时间的初始值在h上
}

//用户模型数据
- (void)avegeChange:(NSNotification *)notifacation
{
    //取出用户模型
    NSString *avgeStr = notifacation.userInfo[YWAvegeValueDidChange];
    self.avgeStr  = avgeStr;
    //用户昵称
    if (self.avgeStr) {
        
        [self loadWebViewData];
    }
    
}
- (void)weekChange:(NSNotification *)notifacation
{
    //取出用户模型
    NSString *weekStr = notifacation.userInfo[YWWeekValueDidChange];
    self.weekStr  = weekStr;
    //用户昵称
    if (self.weekStr) {
        [self loadWebViewData];
    }
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
            //获得模型数据
            [self.tempTableView reloadData];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark -- 发送请求获取webview曲线图数据
- (void)loadWebViewData{
    
    /**h小时 d天 w周 m月  hy半年 y年*/
    NSString *type = [self.timekey objectAtIndex:self.selectIndex];
    
    if (type.length == 0) {
        type = @"h";
    }
    
    /**avg平均 max最大 min最小*/
    NSString *model;
    if ([self.avgeStr isEqualToString:@"平均"]) {
        model = @"avg";
    } else if ([self.avgeStr isEqualToString:@"最大"]){
        model = @"max";
    } else if ([self.avgeStr isEqualToString:@"最小"]){
        model = @"min";
    }
    if (model.length == 0) {
        model = @"avg";
    }
    
    //    type=hy&model=avg&num=1&time=201702&a_id=58
    
    //说明是哪条曲线
    NSString *num = [self.selectLineArray componentsJoinedByString:@","];
    
    
    /**h小时 d天 w周 m月  hy半年 y年*/
    
    
    NSString *urlStr = @"assets_history_html.php";
    NSString *baseurl = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?type=%@&model=%@&num=%@&time=%@&a_id=%@",baseurl, type, model, num, self.yearStr, self.a_id]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
}


//温升历史曲线
- (void)setupTopSelectButton
{
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
    [average setTitle:@"平均" forState:UIControlStateNormal];
    [average setTitle:@"确定" forState:UIControlStateSelected];
    UIView *line1 = [[UIView alloc] init];
    self.avgeLine = line1;
    line1.backgroundColor = [UIColor lightGrayColor];
    line1.frame = CGRectMake(0, 0, averageW, 5);
    [average addSubview:line1];
    [dateBar addSubview:average];
    
    
    
    //1小时 1天 1周 1一个月 3个月 6个月  1年
    UIButton *weekBtn = [[UIButton alloc] init];
    self.weekBtn = weekBtn;
    weekBtn.titleLabel.font = FONT_13;
    [weekBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [weekBtn addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    weekBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    weekBtn.layer.borderWidth = 0.8;
    weekBtn.frame = CGRectMake(YWMargin+5+averageW, 5, averageW, dateBar.height - 5);
    [weekBtn setTitle:@"1小时" forState:UIControlStateNormal];
    [weekBtn setTitle:@"确定" forState:UIControlStateSelected];
    UIView *line2 = [[UIView alloc] init];
    self.weekLine = line2;
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.frame = CGRectMake(0, 0,averageW, 5);
    [weekBtn addSubview:line2];
    [dateBar addSubview:weekBtn];
    
    //39周
    UIButton *yearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yearBtn.titleLabel.font = FONT_13;
    self.yearBtn = yearBtn;
    [yearBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    yearBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    yearBtn.layer.borderWidth = 0.8;
    CGFloat allBtnW = dateBar.width-averageW*2-YWMargin*2-10;
    yearBtn.frame = CGRectMake(YWMargin+10+averageW*2, 5, allBtnW, dateBar.height - 5);
    [yearBtn addTarget:self action:@selector(allYearClick:) forControlEvents:UIControlEventTouchUpInside];
    [yearBtn setTitle:self.defaultTimeStr forState:UIControlStateNormal];
    [yearBtn setTitle:@"确定" forState:UIControlStateSelected];
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = [UIColor lightGrayColor];
    line3.frame = CGRectMake(0, 0, allBtnW, 5);
    self.dataLine = line3;
    [yearBtn addSubview:line3];
    [dateBar addSubview:yearBtn];
    
    
    //曲线图 webview
    CGFloat lineChartY = CGRectGetMaxY(dateBar.frame)+15;
    
    CGRect rect = CGRectMake(0,lineChartY,SCREEN_WIDTH, bgView.height-lineChartY);
    UIWebView *webview = [[UIWebView alloc] init];
    webview.backgroundColor = [UIColor clearColor];
    webview.opaque = NO;
    webview.frame = rect;
    webview.scalesPageToFit = YES;
    webview.scrollView.scrollEnabled = NO;
    webview.delegate = self;
    [self.temHistoryView addSubview:webview];
    self.webView = webview;
    NSString *timeStr = [self.defaultTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.yearStr = timeStr;
    NSString *urlStr = @"assets_history_html.php";
    NSString *baseurl = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?type=%@&model=%@&num=%@&time=%@&a_id=%@",baseurl, @"h", @"avg", @"1,2,3,4,5,6", timeStr, self.a_id]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
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
    if (self.weekBtn.isSelected == YES) {//选中
        self.weekBtn.selected = NO;
        self.weekLine.backgroundColor = [UIColor lightGrayColor];
        self.timeTableView.hidden = YES;
        [self weekViewViewPop];
    }
    if (self.yearBtn.selected == YES) {//选中年
        self.yearBtn.selected = NO;
        self.dataLine.backgroundColor = [UIColor lightGrayColor];
        self.datePickerView.hidden = YES;
    }
    
    
    if (self.avgeStr.length == 0) {
        self.avgeStr = self.avgeData[0];
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
#pragma mark -- 时间点击事项
- (void)weekBtnClick:(UIButton *)btn
{
    if (self.avgeBtn.isSelected == YES) {//选中
        self.avgeBtn.selected = NO;
        self.avgeLine.backgroundColor = [UIColor lightGrayColor];
        self.avgeTableView.hidden = YES;
        [self avgeViewViewPop];
        
    }
    
    if (self.yearBtn.selected == YES) {//选中年
        self.yearBtn.selected = NO;
        self.dataLine.backgroundColor = [UIColor lightGrayColor];
        self.datePickerView.hidden = YES;
    }
    
    
    
    if (self.weekStr.length == 0) {
        self.weekStr = self.weakData[0];
    }
    UIButton *button = (UIButton *)btn;
    button.selected = !button.selected;
    if (button.isSelected == YES) {//选中
        self.weekLine.backgroundColor = YWColor(28, 144, 231);
        self.timeTableView.hidden = NO;
    }else{
        self.weekLine.backgroundColor = [UIColor lightGrayColor];
        self.timeTableView.hidden = YES;
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
        self.timeTableView.hidden = NO;
        // 2.添加View到最中间
        [self.view bringSubviewToFront:self.timeTableView];
        [self.view insertSubview:cover belowSubview:self.timeTableView];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.view addSubview:self.timeTableView];
            
        }];
    } else {
        
        [self.cover removeFromSuperview];
        self.timeTableView.hidden = YES;
        [self.timeTableView removeFromSuperview];
        self.cover = nil;
    }
}

#pragma mark -- 选择日期点击事项
- (void)allYearClick:(UIButton *)btn{
    if (self.weekBtn.isSelected == YES) {//选中
        self.weekBtn.selected = NO;
        self.weekLine.backgroundColor = [UIColor lightGrayColor];
        self.timeTableView.hidden = YES;
        [self weekViewViewPop];
        
    }
    if (self.avgeBtn.isSelected == YES) {//选中
        self.avgeBtn.selected = NO;
        self.avgeLine.backgroundColor = [UIColor lightGrayColor];
        self.avgeTableView.hidden = YES;
        [self avgeViewViewPop];
    }
    
    UIButton *button = (UIButton *)btn;
    [self setTimeButtonInfo: button];
    NSString *str = [button.currentTitle stringByReplacingOccurrencesOfString:@"-"withString:@""];
    self.yearStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    //获取选中的时间
    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"]){//小时
        self.yearStr = [self.yearStr substringToIndex:10];;
    } else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"]){//天
        self.yearStr = [self.yearStr substringToIndex:8];
    } else  if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]) {//周
        self.yearStr = [self.yearStr substringToIndex:6];
    } else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]){//月
        self.yearStr = [self.yearStr substringToIndex:6];
    }else  if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]){//季度
        self.yearStr = [self.yearStr substringToIndex:6];
    }else  if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"]){//半年
        self.yearStr = [self.yearStr substringToIndex:6];
    }else  if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]){//年
        self.yearStr = [self.yearStr substringToIndex:4];
    }else{
        
    }
    
    [self loadWebViewData];
    
    button.selected = !button.selected;
    if (button.isSelected == YES) {//选中
        self.dataLine.backgroundColor = YWColor(28, 144, 231);
        self.datePickerView.hidden = NO;
    }else{
        self.dataLine.backgroundColor = [UIColor lightGrayColor];
        self.datePickerView.hidden = YES;
    }
}



#pragma mark Initialization

- (void)dataserverinit
{
    self.dataserver = nil;
    self.dataserver = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    for (NSInteger i =0; i<6; i++) {
        NSMutableArray *strarray =[[NSMutableArray alloc] initWithObjects:@"",@"",@"",nil];
        [self.dataserver setObject:strarray forKey:[NSString stringWithFormat:@"%ld",(long)i]];
        
    }
    NSMutableArray *temparray = nil;
    temparray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",nil];
    [self.dataserver setObject:temparray forKey:@"6"];
    
    temparray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    [self.dataserver setObject:temparray forKey:@"7"];
    
    //温度的状态
    self.temperature = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil];
    NSLog(@"self.dataserver %@",self.dataserver);
}

#pragma mark - ABC相选中或未选
- (void)initSectionOneDate
{
    //选择的button，未选择的button，绘制的线的颜色，绘制的string
    self.sectionOneArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"temp-wire-color1.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(58, 178, 0),NSLocalizedString(@"A Upper", ""),
                            [UIImage imageNamed:@"temp-wire-color2.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(152, 219, 56),NSLocalizedString(@"A Lower", ""),
                            [UIImage imageNamed:@"temp-wire-color3.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(238, 206, 35),NSLocalizedString(@"B Upper", ""),//需要提供实心的蓝色图片
                            [UIImage imageNamed:@"temp-wire-color4.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(244, 238, 127),NSLocalizedString(@"B Lower", ""),
                            [UIImage imageNamed:@"temp-wire-color5.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(218, 61, 99),NSLocalizedString(@"C Upper", ""),
                            [UIImage imageNamed:@"temp-wire-color6.png"],[UIImage imageNamed:@"temp-wire-color7.png"],YWColor(230, 155, 180),NSLocalizedString(@"C Lower", ""),nil];
    
    self.bOpenArray = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",nil];
}


- (void)initSectionThirdDate
{
    [self dataserverinit];
    self.timeArray = [NSMutableArray arrayWithArray:self.weakData];
    
}

//初始化日期选择器数据
- (void)initpickerViewCompontSelectIndex
{
    self.pick0compentfocusIndex = 0;
    self.pick1compentfocusIndex = 0;
    self.pick2compentfocusIndex = 0;
    self.pick3compentfocusIndex = 0;
}

- (void)initPickerViewDate
{
    [self initpickerViewCompontSelectIndex];
    
    NSDate *today = nil;
    NSTimeZone* GMT8zone = nil;
    NSDateFormatter *dateFormater = nil;
    int year;
    today = [NSDate date]; //默认获得GMT0的时间
    GMT8zone = [NSTimeZone timeZoneForSecondsFromGMT:28800]; //获取GMT8中国时差
    dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.timeZone = GMT8zone;
    [dateFormater setDateFormat:@"YYYY"];
    year = [[dateFormater stringFromDate:today] intValue];
    
    self.pickviewYearArray = [[NSMutableArray alloc] init];
    
    for (int i=year;i>2009;i--) {
        NSString *yearStr = [NSString stringWithFormat:@"%d", i];
        [self.pickviewYearArray addObject:yearStr];
    }

}

-  (void)createPickerView
{
    CGFloat pickerY = CGRectGetMaxY(self.yearBtn.frame)+35;
    self.datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,pickerY, SCREEN_WIDTH,300)];
    self.datePickerView.backgroundColor = BGCLOLOR;
    self.datePickerView.dataSource = self;
    self.datePickerView.delegate = self;
    self.datePickerView.showsSelectionIndicator = YES;
    self.datePickerMode = YXDatePickerModeHour;
    self.datePickerView.hidden = YES;
    [self.view addSubview:self.datePickerView];
}

- (void)setTimeButtonInfo: (UIButton *)button
{
    if ([self.pickviewYearArray count]>0){
        NSString *year = [[self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex] substringToIndex:4];
        
        NSString *timeStr;
        if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"]) {//一小时
            timeStr = [NSString stringWithFormat:@"%@-%.2ld-%.2ld %.2ld",year,self.pick1compentfocusIndex+1,self.pick2compentfocusIndex+1, self.pick3compentfocusIndex];
            
        }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]) {//一年
            timeStr = [NSString stringWithFormat:@"%@",year];  //年的时标显示
        }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"]) {//一天
            timeStr = [NSString stringWithFormat:@"%@-%.2ld-%.2ld",year,
                       self.pick1compentfocusIndex+1,
                       self.pick2compentfocusIndex+1];  //天的时标显示
            
        }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]) {//一周
            timeStr = [NSString stringWithFormat:@"%@ %.2ld" ,year,
                       self.pick1compentfocusIndex+1];  //周的时标显示
            
        }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]) {//一月
            timeStr = [NSString stringWithFormat:@"%@-%.2ld",year,
                       self.pick1compentfocusIndex+1];  //月的时标显示
            
        }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]) {//一季度
            NSString *str;
            switch (self.pick1compentfocusIndex) {
                case 0:
                    str = @"01";
                    break;
                case 1:
                    str = @"02";
                    break;
                case 2:
                    str = @"03";
                    break;
                default:
                    str = @"04";
                    break;
            }
            timeStr = [NSString stringWithFormat:@"%@ %@",year, str];
            
        }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"]) {//六个月
            if (self.pick1compentfocusIndex ==0) {
                timeStr = [NSString stringWithFormat:@"%@ 01",year];
            }
            else {
                timeStr = [NSString stringWithFormat:@"%@ 02",year];
            }
            
        }
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:timeStr forState:UIControlStateNormal];
    }
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 0.0;
    
    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"]) {
        
        componentWidth =75;
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]) {
        
        componentWidth =300;
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"]) {
        
        componentWidth =100;
    }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"]
              ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]
              ) {
        componentWidth = 150;
    }else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]
              ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]
              ) {
        componentWidth =150;
    }
    else {
        
    }
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0;
}
//指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    if (self.pickviewYearArray==nil) {
        return 0;
    }
    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
    {
        //年
        if (component == 0) {
            count = [self.pickviewYearArray count];
        }
        else if(component==1){//月
            count = self.pickviewMonthArray.count;
        }
        else if(component ==2){//日，初始月分在1月份
            if (self.pick1compentfocusIndex +1==1
                ||self.pick1compentfocusIndex+1 ==3
                ||self.pick1compentfocusIndex +1==5
                ||self.pick1compentfocusIndex +1==7
                ||self.pick1compentfocusIndex +1==8
                ||self.pick1compentfocusIndex +1==10
                ||self.pick1compentfocusIndex +1==12) {
                count = 31;
            }
            else if(self.pick1compentfocusIndex +1==2){
                NSArray *yd = [(NSString *)[self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex] componentsSeparatedByString:@"年"];
                NSInteger y = [(NSString *)[yd objectAtIndex:0] intValue];
                if(y%4==0 && y%100!=0)
                    count = 29;
                else
                    count = 28;
            }
            else {
                count = 30;
            }
        }
        else {//时
            count =24;
        }
    }
    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]){
        count = [self.pickviewYearArray count];
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
    {
        //年
        if (component == 0) {
            count = [self.pickviewYearArray count];
        }
        else if(component==1){//月
            count = self.pickviewMonthArray.count;
        }
        else{//日，初始月分在1月份
            if (self.pick1compentfocusIndex +1==1
                ||self.pick1compentfocusIndex+1 ==3
                ||self.pick1compentfocusIndex +1==5
                ||self.pick1compentfocusIndex +1==7
                ||self.pick1compentfocusIndex +1==8
                ||self.pick1compentfocusIndex +1==10
                ||self.pick1compentfocusIndex +1==12) {
                count = 31;
            }
            else if(self.pick1compentfocusIndex +1==2){
                NSArray *yd = [(NSString *)[self.pickviewYearArray objectAtIndex:self.pick0compentfocusIndex] componentsSeparatedByString:@"年"];
                NSInteger y = [(NSString *)[yd objectAtIndex:0] intValue];
                if(y%4==0 && y%100!=0)
                    count = 29;
                else
                    count = 28;
            }
            else {
                count = 30;
            }
        }
    }
    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]){
        //年
        if (component == 0) {
            count = [self.pickviewYearArray count];
        }
        else if(component==1){//周
            count = 52;
        }
    }
    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]){
        //年
        if (component == 0) {
            count = [self.pickviewYearArray count];
        }
        else if(component==1){//月
            count = self.pickviewMonthArray.count;
        }
    }
    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]){
        //年
        if (component == 0) {
            count = [self.pickviewYearArray count];
        }
        else if(component==1){//季度
            count = 4;
        }
    }
    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"]){
        //年
        if (component == 0) {
            count = [self.pickviewYearArray count];
        }
        else if(component==1){//上半年
            count = 2;
        }
    }
    
    return count;
}
//指定pickerview有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger number = 0;
    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
    {
        number = 4;
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"])
    {
        number = 1;
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
    {
        number = 3;
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]
             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]
             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]
             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"])
    {
        number = 2;
    }
    return number;
    return 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    YXCustomDateView *dateView = [[YXCustomDateView alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
    //cView.fontdisplay=[GlobalInfo getFont:18];
    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
    {
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
                break;
            case 1://month
                dateView.titleStr = [self.pickviewMonthArray objectAtIndex:row];
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
    else if([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"]){
        dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
    {
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
                break;
            case 1://month
                dateView.titleStr = [self.pickviewMonthArray objectAtIndex:row];
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
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"])
    {
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
                break;
            case 1://week
                dateView.frame = CGRectMake(0, 0, 150,40);
                dateView.titleStr = [NSString stringWithFormat:NSLocalizedString(@"第%d周", ""),row+1];
                break;
            default:
                break;
        }
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"])
    {
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
                break;
            case 1://month
                dateView.titleStr = [self.pickviewMonthArray objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"])
    {
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
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
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"])
    {
        switch (component)
        {
            case 0://year
                dateView.titleStr = [self.pickviewYearArray objectAtIndex:row];
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
    return dateView;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"h"])
    {
        if (component ==0) {//年
            self.pick0compentfocusIndex = row;
            self.pick1compentfocusIndex  = 0;
            [self.datePickerView  reloadComponent:1];//重新load日
            [self.datePickerView selectRow:self.pick1compentfocusIndex inComponent:1 animated:YES];

        }
        else if(component ==1)
        {
            self.pick1compentfocusIndex = row;
            self.pick2compentfocusIndex  = 0;
            [self.datePickerView  reloadComponent:2];//重新load日
            [self.datePickerView selectRow:self.pick2compentfocusIndex inComponent:2 animated:YES];
        }
        else if(component ==2){//日
            self.pick2compentfocusIndex = row;
        }
        else if(component ==3){//小时
            self.pick3compentfocusIndex = row;
        }
        
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"y"])
    {
        self.pick0compentfocusIndex = row;
        //[self.tempTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"d"])
    {
        if (component ==0) {//年
            self.pick0compentfocusIndex = row;
            self.pick1compentfocusIndex  = 0;
            [self.datePickerView  reloadComponent:1];//重新load日
            [self.datePickerView selectRow:self.pick1compentfocusIndex inComponent:1 animated:YES];
            
        }
        else if(component ==1)
        {
            self.pick1compentfocusIndex = row;
            self.pick2compentfocusIndex  = 0;
            [self.datePickerView  reloadComponent:2];//重新load日
            [self.datePickerView selectRow:self.pick2compentfocusIndex inComponent:2 animated:YES];
        }
        else{//日
            self.pick2compentfocusIndex = row;
        }
        //[self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else if ([[self.timekey objectAtIndex:self.selectIndex] isEqual: @"w"]
             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m"]
             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"m3"]
             ||[[self.timekey objectAtIndex:self.selectIndex] isEqual: @"hy"])
    {
        if (component ==0) {//年
            self.pick0compentfocusIndex = row;
        }
        else//week
        {
            self.pick1compentfocusIndex = row;
        }
        
        
    }
}


#pragma mark ---------------------------------------------initloading----------------------------------------------

- (void)removeActiveIndictor:(NSString *)aletmsg
{
    
    
}

- (NSString*) getTimeButtonBG:(NSString *)title
{
    NSString * timeButtonBg;
    if ([NSLocalizedString(@"Language", "") isEqualToString: @"Chinese"]) {
        switch ([title length]) {
            case 4:
                timeButtonBg = @"temp-4c-bg.png";
                break;
            case 5:
                timeButtonBg = @"temp-5c-bg.png";
                break;
            default:
                timeButtonBg = @"temp-4c-bg.png";
                break;
        }
    }else{
        switch ([title length]) {
            case 4:
                timeButtonBg = @"temp-4c-bg.png";
                break;
            case 5:
                timeButtonBg = @"temp-5c-bg.png";
                break;
            default:
                timeButtonBg = @"temp-6c-bg.png";
                break;
        }
    }
    return timeButtonBg;
}

#pragma mark buttonclick
-(void)timebuttonClick:(id)obj
{
    UIButton *bt =(UIButton *)obj;
    NSInteger tag =bt.tag -500;
    if (tag == self.selectIndex) {//和之前相等
        return;
    }
    else {
        [obj setBackgroundImage:[UIImage imageNamed:[self getTimeButtonBG:bt.titleLabel.text]] forState:UIControlStateNormal];
        [obj setTitleColor:YWColor(51,71,114)  forState:UIControlStateNormal];
        bt.titleLabel.shadowColor = [UIColor clearColor];
        bt.titleLabel.shadowOffset = CGSizeMake(0, 0);
        
        UIButton *preBtn = (UIButton *)[self.timeArray objectAtIndex:self.selectIndex];
        [preBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        preBtn.titleLabel.shadowColor = [UIColor grayColor];
        preBtn.titleLabel.shadowOffset = CGSizeMake(1, 1);
        
        self.selectIndex = tag;
        
        
        if (self.bg.hidden)
        {
            self.bg.hidden = NO;
            [self.loading startAnimating];
        }
    }
    
    
}
#pragma mark-picSet
- (void)imagebuttonclicked:(id)obj
{
    //设置选中对号图片按钮
    NSInteger tag = ((UIButton *)obj).tag - 0;
    if ([[self.bOpenArray objectAtIndex:tag] isEqual:@"0"]) {
        [((UIButton *)obj) setBackgroundImage:[self.sectionOneArray objectAtIndex:tag*4] forState:UIControlStateNormal];
        [self.bOpenArray replaceObjectAtIndex:tag withObject:@"1"];
    }
    else {
        [((UIButton *)obj) setBackgroundImage:[self.sectionOneArray objectAtIndex:tag*4+1] forState:UIControlStateNormal];
        [self.bOpenArray replaceObjectAtIndex:tag withObject:@"0"];
    }
    self.bg.hidden = NO;
    [self.loading startAnimating];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.avgeTableView) {
        return self.avgeData.count;
    } else if (tableView == self.timeTableView) {
        return self.weakData.count;
    }
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.avgeTableView) {
        //创建cell
        YXButtonViewCell *cell = [YXButtonViewCell cellWithTableView:tableView];
        [cell.titleBtn setTitle:self.avgeData[indexPath.row] forState:UIControlStateNormal];
        cell.backgroundColor = BGCLOLOR;
        cell.didTapTimeBtn = ^(UIButton *timeBtn) {
            
        };
        return cell;
        
        
    } else if (tableView == self.timeTableView) {
        
        //创建cell
        YXButtonViewCell *cell = [YXButtonViewCell cellWithTableView:tableView];
        cell.backgroundColor = BGCLOLOR;
        [cell.titleBtn setTitle:self.weakData[indexPath.row] forState:UIControlStateNormal];
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
            
            [self loadWebViewData];
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
            [self loadWebViewData];
            
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
            [self loadWebViewData];
            
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
            [self loadWebViewData];
            
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
            [self loadWebViewData];
            
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
            [self loadWebViewData];
            
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
    if (tableView == self.avgeTableView ||tableView == self.timeTableView) {
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
        self.avgeBtn.selected = !self.avgeBtn.selected;
        if (self.avgeBtn.isSelected == YES) {//选中
            self.avgeLine.backgroundColor = YWColor(28, 144, 231);
            self.avgeTableView.hidden = NO;
        }else{
            self.avgeLine.backgroundColor = [UIColor lightGrayColor];
            self.avgeTableView.hidden = YES;
        }
        
        NSString *avgeStr = self.avgeData[indexPath.row];
        [self.avgeBtn setTitle:avgeStr forState:UIControlStateNormal];
        self.avgeStr = avgeStr;
        
        [self avgeViewViewPop];
        
        //平均值改变
        [YWNotificationCenter postNotificationName:YWAvegeValueDidChangeNotification object:self userInfo:@{YWAvegeValueDidChange:avgeStr}];
        
        
    } else if (tableView == self.timeTableView)  {//日期
        self.weekBtn.selected = !self.weekBtn.selected;
        if (self.weekBtn.isSelected == YES) {//选中
            self.weekLine.backgroundColor = YWColor(28, 144, 231);
            self.timeTableView.hidden = NO;
        }else{
            self.weekLine.backgroundColor = [UIColor lightGrayColor];
            self.timeTableView.hidden = YES;
        }
        
        NSString *weakStr = self.weakData[indexPath.row];
        [self.weekBtn setTitle:weakStr forState:UIControlStateNormal];
        self.weekStr = weakStr;
        
        [self weekViewViewPop];
        
        
        //日期选择器模式
        //        if (indexPath.row == 0) {
        //            self.datePickerMode = YXDatePickerModeHour;
        //        } else  if (indexPath.row == 1){
        //            self.datePickerMode = YXDatePickerModeDay;
        //        }else  if (indexPath.row == 2){
        //            self.datePickerMode = YXDatePickerModeWeek;
        //        }else  if (indexPath.row == 3){
        //            self.datePickerMode = YXDatePickerModeMonth;
        //        }else  if (indexPath.row == 4){
        //            self.datePickerMode = YXDatePickerModeQuarter;
        //        }else  if (indexPath.row == 5){
        //            self.datePickerMode = YXDatePickerModeHalfYear;
        //        }else if (indexPath.row == 6){
        //            self.datePickerMode = YXDatePickerModeYear;
        //        }
        //根据 selectIndex 判断选择第二个条件
        self.selectIndex = indexPath.row;
        //创建pickView
        [self createPickerView];
        
        //日期改变
        [YWNotificationCenter postNotificationName:YWWeekValueDidChangeNotification object:self userInfo:@{YWWeekValueDidChange:weakStr}];
    }
    
}

- (UITableView *)avgeTableView
{
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

- (NSArray *)avgeData
{
    if (!_avgeData) {
        _avgeData = @[@"平均",@"最大",@"最小"];
    }
    return _avgeData;
}



- (UITableView *)timeTableView
{
    CGFloat averageW = SCREEN_WIDTH*0.20;
    
    if (!_timeTableView) {
        _timeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _timeTableView.delegate = self;
        _timeTableView.hidden = YES;
        _timeTableView.dataSource = self;
        _timeTableView.scrollEnabled = NO;
        _timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _timeTableView.backgroundColor = BGCLOLOR;
        _timeTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_timeTableView];
        _timeTableView.frame = CGRectMake(20 + averageW + 5,68,averageW,210);
    }
    return _timeTableView;
}

- (NSArray *)weakData
{
    if (!_weakData) {
        _weakData = @[@"1小时",@"1天",@"1周",@"1个月",@"3个月",@"6个月",@"1年"];
    }
    return _weakData;
}

- (NSMutableArray *)selectLineArray{
    if (_selectLineArray == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NSArray *numarray = @[@"1",@"2",@"3",@"4",@"5",@"6"];
        [array addObjectsFromArray:numarray];
        _selectLineArray = array;
    }
    return _selectLineArray;
}

- (NSString *)defaultTimeStr{
    if (_defaultTimeStr == nil) {
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        // 指定获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |  NSCalendarUnitDay |
        NSCalendarUnitHour |  NSCalendarUnitMinute |
        NSCalendarUnitSecond | NSCalendarUnitWeekday;
        
        // 获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
        NSInteger year =comp.year;
        NSInteger month =comp.month;
        NSInteger day =comp.day;
        NSInteger hour =comp.hour;
        
        NSString *defaultTimeStr = [NSString stringWithFormat:@"%.2ld-%.2ld-%.2ld %.2ld",(long)year, month, day, hour];
        
        
        _defaultTimeStr = defaultTimeStr;
    }
    return _defaultTimeStr;
}

- (NSArray *)pickviewMonthArray{
    
    if (_pickviewMonthArray == nil) {
        NSArray *array = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
        _pickviewMonthArray = array;
    }
    return _pickviewMonthArray;
}

- (NSArray *)timekey{
    if (_timekey == nil) {
        NSArray *array = [NSArray arrayWithObjects:@"h",@"d",@"w",@"m",@"m3",@"hy",@"y",nil];
        _timekey = array;
    }
    return _timekey;
}

#pragma mark -- 获取时间
- (void)getDate{
//    NSDate *today = [NSDate date];
    NSTimeZone* GMT8zone = [NSTimeZone timeZoneForSecondsFromGMT:28800]; //获取GMT8中国时差
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.timeZone = GMT8zone;
    
    [dateFormater setDateFormat:@"YYYY"];
//    int year = [[dateFormater stringFromDate:today] intValue];
    [dateFormater setDateFormat:@"MM"];
//    int month = [[dateFormater stringFromDate:today] intValue];
    [dateFormater setDateFormat:@"dd"];
//    int day = [[dateFormater stringFromDate:today] intValue];
    [dateFormater setDateFormat:@"HH"];
//    int hour = [[dateFormater stringFromDate:today] intValue];
}
@end
