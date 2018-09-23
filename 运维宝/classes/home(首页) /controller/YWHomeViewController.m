//
//  YWHomeViewController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWHomeViewController.h"
#import "YWMyDeviceListController.h"
#import "YWStationListController.h"
#import "YWSataionDetilController.h"
#import "HCScanQRViewController.h"
#import "YWSerchViewController.h"
#import "HomeHedaerView.h"
#import "YWSerchViewCell.h"
#import "YWHomeCell.h"
#import "SCSearchBar.h"
#import "YWGridViewCell.h"
#import "YWDeviceStatusNum.h"
#import "YWMyStationCell.h"
#import "YWUser.h"
#import "YWMyStations.h"
#import "YWCurrentStationCell.h"
#import "LMLoginController.h"
#import "YWNavViewController.h"

@interface YWHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>


/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *myStations;
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *deviceNums;
/** 色标 */
@property(nonatomic, strong) NSArray *status;
/** 状态码 */
@property(nonatomic, strong) NSArray *statusCode;
/** 状态 */
@property(nonatomic, strong) NSArray *colors;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/** 我的电站*/
@property (nonatomic, strong) YWMyStations *currentStations;
/** 我的电站*/
@property (nonatomic, strong) YWMyStations *stations;
/** NSTimer */
@property (nonatomic, strong) YWDeviceStatusNum *statusNum;

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UICollectionView * collectionView;
/** MineHeadView */
@property (nonatomic,weak) UIView *headView;
/** NSTimer */
@property (nonatomic, strong) YWUser *user;
@end

static NSString *const GridCellID = @"GridCellID";

@implementation YWHomeViewController
/**懒加载*/
- (NSArray *)statusCode
{
    if (!_statusCode) {
        _statusCode = @[@"2",@"1",@"0",@"3"];
    }
    return _statusCode;
}
- (NSArray *)status
{
    if (!_status) {
        _status = @[@"设备",@"危险",@"关注",@"正常",@"离线"];
    }
    return _status;
}
- (NSArray *)colors
{
    if (!_colors) {
        _colors = @[@"fragment_main_blue_check",@"fragment_main_red_check",@"fragment_main_orange_check",@"fragment_main_green_check",@"fragment_main_gray_check"];
    }
    return _colors;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"运维宝";
    self.deviceNums = [NSMutableArray array];
    
    self.myStations = [NSMutableArray array];
    
    
    //头部view
    

    self.currentPage = 1;
    
    [self getDeviceList];
    [self getMyStations];
    
    //创建头部尾部
    [self setupFrenshHeaderandFooter];


    //删除系统分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //登陆成功通知
    [YWNotificationCenter addObserver:self selector:@selector(stationChange:) name:YWMystationChangeNotification object:nil];
    
    //登陆成功通知保存用户模型
    [YWNotificationCenter addObserver:self selector:@selector(logUser:) name:YWLogUserNotification object:nil];

}

- (void)postTokenToService{

    //发送登录请求
    NSMutableDictionary *param = [NSMutableDictionary  dictionary];
    //手机号
    param[@"mobile"] = kGetData(@"db_login_mobile");
    //密码
    param[@"password"] = kGetData(@"db_login_password");
    param[@"client_id"] = kGetData(@"token");
    
    NSString *shortStr = @"/user_login.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",shortStr];
    
    [HMHttpTool get:url params:param success:^(id responseObj) {
//        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        if ([status  isEqual:@1]){
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LMLoginController *login = [[LMLoginController alloc] init];
            YWNavViewController *nav = [[YWNavViewController alloc] initWithRootViewController:login];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
            [SVProgressHUD showErrorWithStatus:msg];

        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self autoRefresh];
    
    //进入首页调登录接口，传token给服务器，防止同一个账号，登录多台设备接收不到推送
    [self postTokenToService];


}
//用户模型数据
- (void)logUser:(NSNotification *)notifacation
{
    //取出用户模型
    YWUser *logUser = notifacation.userInfo[YWLogUser];
    self.user = logUser;
    //用户昵称
    
    //用户ID
    
    
    YWLog(@"首页用户数据-logUser%@",logUser);
    
}

//用户模型数据
- (void)stationChange:(NSNotification *)notifacation
{
    //取出用户模型
    YWMyStations *station = notifacation.userInfo[YWMystationChange];
    self.currentStations = station;
    //用户昵称
    
    
    //刷新页面
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

        [self getDeviceList];
        [self getMyStations];
    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.currentPage++;
//        [self getDeviceList];
//        [self getMyStations];
//    }];
    
}
/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取设备数量
- (void)getDeviceList
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/user_my_num.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //params[@"token"] = kGetData(@"token");
    params[@"token"] = self.user.token;
    //params[@"account_id"] = kGetData(@"account_id");
    params[@"account_id"] = self.user.account_id;
    //请求数据
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"homeResponseObj--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            YWDeviceStatusNum *statusNum = [YWDeviceStatusNum mj_objectWithKeyValues:dict];
            //添加数据到数组中
            self.statusNum = statusNum;
            NSMutableArray *statusArr = [[NSMutableArray alloc] init];
            [statusArr addObject:statusNum.asset];
            [statusArr addObject:statusNum.danger];
            [statusArr addObject:statusNum.attention];
            [statusArr addObject:statusNum.normal];
            [statusArr addObject:statusNum.offline];
            self.deviceNums = statusArr;
            //获得模型数据
            
            
            [self setUpHeaderView];

            [self.tableView reloadData];
            [self.collectionView reloadData];
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

//发送请求获取网络数据当前电站
- (void)getMyStations
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_my_stations.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        if ([status isEqual:@1]) { // 数据
            
            self.myStations = [YWMyStations mj_objectArrayWithKeyValuesArray:dict];
            YWMyStations *station = self.myStations[0];
            //存储用户当前电站station_id
            kDataPersistence(station.station_id,@"station_id");
            //保存当前电站名称
            kDataPersistence(station.station_name,@"station_name");
            
            self.stations = station;
            //获得模型数据
            [self.collectionView reloadData];
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

// 首页头部view
- (void)setUpHeaderView
{
    //头部view
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor redColor];
    UIImageView *headerPicView = [[UIImageView alloc] init];
    headerPicView.image = [UIImage imageNamed:@"banner"];
//    headerPicView.contentMode = UIViewContentModeScaleAspectFit;
    _headView = headView;
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT*0.37);
    [headView addSubview:headerPicView];
    //设置frame
    headerPicView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.39);

//    [headerPicView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(headView);
//        make.left.mas_equalTo(headView);
//        make.right.mas_equalTo(headView);
//        make.height.mas_equalTo(headView.height-85);
//    }];
    
    //状态按钮工具条
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = MAINBGCLOLOR;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.frame = CGRectMake(0,CGRectGetMaxY(headerPicView.frame), SCREEN_WIDTH,CGRectGetMaxY(headView.frame) - CGRectGetMaxY(headerPicView.frame));

    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    //注册
    [_collectionView registerClass:[YWGridViewCell class] forCellWithReuseIdentifier:GridCellID];
    [headView addSubview:_collectionView];
    self.tableView.tableHeaderView = headView;
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一行cell是搜索view
     if (indexPath.row == 0) {
        
        YWSerchViewCell *cell = [YWSerchViewCell cellWithTableView:tableView];
         cell.didTapScanView = ^{
             //扫一扫
             HCScanQRViewController *scan = [[HCScanQRViewController alloc] init];
             scan.fromeWhereStr = @"1";
             [self.navigationController pushViewController:scan animated:YES];
         };
         
         //放大镜点击
         cell.searchBar.didTapSearchbar = ^(NSString *textStr) {
             //搜索框
             YWSerchViewController *serch = [[YWSerchViewController alloc] init];
             serch.searchText = textStr;
             serch.type = @"1";
             [self.navigationController pushViewController:serch animated:YES];
         };
         
        return cell;
     }else  if (indexPath.row == 1) {
         static NSString *ID = @"stationListCell";
         
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
         if (cell == nil) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
         }
         cell.textLabel.x = 10;
         cell.textLabel.font = FONT_19;
         cell.textLabel.textColor = YWColor(70, 171, 211);
         
         cell.textLabel.text = [NSString stringWithFormat:@"【%@】",kGetData(@"app_title")];
         return cell;
     }

    //创建cell
    static NSString *ID = @"stationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.font = FONT_17;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.currentStations) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  当前电站: %@",self.currentStations.station_name]];
        cell.textLabel.textColor = [UIColor orangeColor];
        [str addAttribute:NSForegroundColorAttributeName value:YWColor(70, 171, 211) range:NSMakeRange(0, 7)];
        cell.textLabel.attributedText = str;
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  当前电站: %@",self.stations.station_name]];
        cell.textLabel.textColor = [UIColor orangeColor];
        [str addAttribute:NSForegroundColorAttributeName value:YWColor(70, 171, 211) range:NSMakeRange(0, 7)];
        cell.textLabel.attributedText = str;

    }
   return cell;
 }

#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 50;

    }else if (indexPath.row == 1){
        return 50;

    }
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //表格控件的点击处理
    
    if (indexPath.row == 0) {
        return;
        
    }else if (indexPath.row == 1) {
        
        //电站列表
        YWStationListController *stationList = [[YWStationListController alloc] init];
        
        [self.navigationController pushViewController:stationList animated:YES];
        
    }else{
        //电站详情
        YWSataionDetilController *stationDetil = [[YWSataionDetilController alloc] init];
        if (self.currentStations) {
            
            stationDetil.station = self.currentStations;
            if (self.currentStations.station_id.length > 0) {
                stationDetil.s_id = self.currentStations.station_id;
            }
            
            if (self.currentStations.s_id.length > 0) {
                stationDetil.s_id = self.currentStations.s_id;
            }
            
        }else{
            stationDetil.station = self.stations;
            
            if (self.stations.s_id.length > 0) {
                stationDetil.s_id = self.stations.s_id;
                
            }
            
            if (self.stations.station_id.length > 0) {
                stationDetil.s_id = self.stations.station_id;
            }
        }
        
   
        
      
        [self.navigationController pushViewController:stationDetil animated:YES];
    }
}
#pragma mark-CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建子控件
    YWGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridCellID forIndexPath:indexPath];
    //背景颜色
    [cell.statusBtn setBackgroundImage:[UIImage imageNamed:self.colors[indexPath.item]] forState:UIControlStateNormal];
    //数量
    [cell.statusBtn setTitle:self.deviceNums[indexPath.item] forState:UIControlStateNormal];
    //文字
    cell.statusLabel.text = self.status[indexPath.item];
    return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-12)/5 , 98);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(2,2,2,2);
        
}

//#pragma mark - <UICollectionViewDelegateFlowLayout>
//#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
     return  2 ;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return  2 ;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    //跳转到设备列表
    YWMyDeviceListController *devideList = [[YWMyDeviceListController alloc] init];
    
    //状态码
    if (indexPath.item ==1) {
        devideList.status = @"2";
    }else if (indexPath.item == 2) {
        devideList.status = @"1";
    }else if (indexPath.item == 3) {
        devideList.status = @"0";
    }else if (indexPath.item == 4) {
        devideList.status = @"3";
    }
    
    [self.navigationController pushViewController:devideList animated:YES];
    
    NSLog(@"首页点击了按钮:%ld--%ld",(long)indexPath.section,indexPath.item);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
