//
//  YWServiceViewController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWServiceViewController.h"
#import "YWServiceDetilController.h"
#import "HCScanQRViewController.h"
#import "YWServiceCell.h"
#import "YWSerchViewCell.h"
#import "YWSercice.h"
#import "YWMyStations.h"
#import "SCSearchBar.h"
#import "YWSerchViewController.h"
#import "YWCurrentStationCell.h"
#import "YWSataionDetilController.h"

@interface YWServiceViewController ()
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *services;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) YWMyStations *myStations;
/**当前电站*/
@property (nonatomic, weak) UILabel *stationLab;
@end

@implementation YWServiceViewController

/**懒加载*/
- (NSMutableArray *)services
{
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YWNotificationCenter addObserver:self selector:@selector(myStation:) name:YWMystationChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    // 首先自动刷新一次
    [self autoRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //进页面发送请求
    [self getServices];
    
    //self.navigationItem.rightBarButtonItem  = [UIBarButtonItem itemWithImageName:@"scan_icon" highImageName:nil target:self action:@selector(scanIconClick)];
    //登陆成功通知

    
}

//个人资料页面
- (void)scanIconClick
{
    
    //扫一扫
    HCScanQRViewController *scan = [[HCScanQRViewController alloc] init];
    scan.fromeWhereStr = @"2";
    [self.navigationController pushViewController:scan animated:YES];
}

//用户模型数据
- (void)myStation:(NSNotification *)notifacation
{
    //取出用户模型
    YWMyStations *myStations = notifacation.userInfo[YWMystationChange];
    self.myStations = myStations;
    self.stationLab.text = [NSString stringWithFormat:@"当前电站:%@",myStations.station_name];
    //刷新页面
    
    //创建头部尾部
    [self autoRefresh];
    
    [self.tableView reloadData];
    
    
}

//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.services = [NSMutableArray array];
        [self getServices];
    }];

    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServices
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_list.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    //电站
    if (self.myStations) {
        params[@"s_id"] = self.myStations.station_id;
    }else{
        params[@"s_id"] = kGetData(@"station_id");
    }
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [self.services removeAllObjects];
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        //YWLog(@"getServices--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.services = [YWSercice mj_objectArrayWithKeyValuesArray:dict];
            
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
    
    return self.services.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //第一行cell是搜索view
    if (indexPath.row == 0) {
        
        YWSerchViewCell *cell = [YWSerchViewCell cellWithTableView:tableView];
        cell.didTapScanView = ^{
            //扫一扫
            HCScanQRViewController *scan = [[HCScanQRViewController alloc] init];
            scan.fromeWhereStr = @"2";
            [self.navigationController pushViewController:scan animated:YES];
        };
        
        //放大镜点击
        cell.searchBar.didTapSearchbar = ^(NSString *textStr) {
            //搜索框
            YWSerchViewController *serch = [[YWSerchViewController alloc] init];
            serch.searchText = textStr;
            serch.type = @"2";
            [self.navigationController pushViewController:serch animated:YES];
        };
        
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        //创建cell
        //创建cell
        static NSString *ID = @"stationCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.textLabel.font = FONT_17;
        cell.textLabel.textColor = [UIColor orangeColor];
        if (self.myStations) {
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前电站: %@",self.myStations.station_name]];
            cell.textLabel.textColor = [UIColor orangeColor];
            [str addAttribute:NSForegroundColorAttributeName value:YWColor(70, 171, 211) range:NSMakeRange(0, 5)];
            cell.textLabel.attributedText = str;
            
        }else{
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前电站: %@",kGetData(@"station_name")]];
            cell.textLabel.textColor = [UIColor orangeColor];
            [str addAttribute:NSForegroundColorAttributeName value:YWColor(70, 171, 211) range:NSMakeRange(0, 5)];
            cell.textLabel.attributedText = str;
            
        }
        
        return cell;
    }else{
        
        //创建cell
        YWServiceCell *cell = [YWServiceCell cellWithTableView:tableView];
        
        // Configure the cell...
        cell.services = self.services[indexPath.row-2];
        
        return cell;
        
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果点击的是其他行执行跳转到服务详情
    if (indexPath.row == 0) {
        return;
    }else if (indexPath.row == 1) {
        YWSataionDetilController *stationDetil = [[YWSataionDetilController alloc] init];
        //传递模型数据
        
        if (self.myStations) {
            stationDetil.station = self.myStations;

        }else{
            stationDetil.s_id = kGetData(@"station_id");
        }
        
        [self.navigationController pushViewController:stationDetil animated:YES];
        
    }else{
        YWServiceDetilController *serviceDetil = [[YWServiceDetilController alloc] init];
        //传递模型数据
        serviceDetil.deviceSercice = self.services[indexPath.row-2];
        [self.navigationController pushViewController:serviceDetil animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
        
    }
    return 35;
}

//移除通知
- (void)dealloc
{
    [YWNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建刷新头部和尾部控件
- (void)setUpHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 35)];
    self.stationLab = headerLab;
    headerView.backgroundColor = BGCLOLOR;
    headerLab.textColor = [UIColor orangeColor];
    headerLab.font = FONT_16;
    headerLab.textAlignment = NSTextAlignmentLeft;
    headerLab.text = [NSString stringWithFormat:@"当前电站是:%@",kGetData(@"station_name")];
    [headerView addSubview:headerLab];
    self.tableView.tableHeaderView = headerView;
    
}


@end
