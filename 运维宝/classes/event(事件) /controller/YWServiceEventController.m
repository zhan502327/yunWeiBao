//
//  YWServiceEventController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWServiceEventController.h"
#import "YWDeviceDetilController.h"
#import "YWEventCell.h"
#import "YWEventModel.h"
#import "DBDataBaseManager.h"
#import "UITabBar+Badge.h"

@interface YWServiceEventController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *serviceEvents;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YWServiceEventController

/**懒加载*/
- (NSMutableArray *)serviceEvents
{
    if (!_serviceEvents) {
        _serviceEvents = [NSMutableArray array];
    }
    return _serviceEvents;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 首先自动刷新一次
    [self autoRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //创建头部尾部
    [self setupFrenshHeaderandFooter];

    //删除 表
//    [[DBDataBaseManager shareDataBaseManager] deleteTableWithtableName:kNotificationThree];

    //删除系统分割线
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
        self.serviceEvents = [NSMutableArray array];
        [self getServiceEvents];
    }];

}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServiceEvents
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/alert_service.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool get:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        //YWLog(@"getWarningEvent--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            
            //请求到的数据
            NSArray *dataArray = [YWEventModel mj_objectArrayWithKeyValuesArray:dict];
            
            //写入数据库
            if (dataArray.count > 0) {
                for (YWEventModel *model in dataArray) {
                    [[DBDataBaseManager shareDataBaseManager] insertNotificationModel:model tableName:kNotificationThree];
                }
            }
            
            //查询数据库 获取所有数据
            NSArray *dbArray = [[DBDataBaseManager shareDataBaseManager] queryAllNotificationModelWithtableName:kNotificationThree];
            
            
            //数据源
            [self.serviceEvents addObjectsFromArray:dbArray];
            
            //查询 isLooked 数据
            NSArray *isLookedArray = [[DBDataBaseManager shareDataBaseManager] queryIsLookedCountWithTableName:kNotificationThree];
            
            [[NSUserDefaults standardUserDefaults] setInteger:isLookedArray.count forKey:@"kNotificationThreeIsLookedCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //获得模型数据
            [self.tableView reloadData];
            /**停止刷新*/
            [self.tableView.mj_header endRefreshing];
            
        }
        
    } failure:^(NSError *error) {
        /**停止刷新*/
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    
    return self.serviceEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建cell
    YWEventCell *cell = [YWEventCell cellWithTableView:tableView];
    
    //传递模型
    cell.eventModel = self.serviceEvents[indexPath.row];
    
    cell.iconView.image = [UIImage imageNamed:@"fragment_four_fuwu"];
    return cell;
}


#pragma mark-代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //防止未请求数据崩溃
    if (self.serviceEvents.count > 0) {
        //执行跳转设备详情
        YWDeviceDetilController *deviceDetil = [[YWDeviceDetilController alloc] init];        
        YWEventModel *event = self.serviceEvents[indexPath.row];
        deviceDetil.a_id = event.a_id;
        [self.navigationController pushViewController:deviceDetil animated:YES];
        
        
        //点击cell 更新数据库 isLooked 为已读
        [[DBDataBaseManager shareDataBaseManager] updateNotificationModel:event tableName:kNotificationThree WithIsLooked:@"1"];
        
        //查询 isLooked 数据 未读
        NSArray *isLookedArray = [[DBDataBaseManager shareDataBaseManager] queryIsLookedCountWithTableName:kNotificationThree];
        [[NSUserDefaults standardUserDefaults] setInteger:isLookedArray.count forKey:@"kNotificationThreeIsLookedCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //添加事件页的角标
        if (isLookedArray.count > 0) {
            NSString *str = [NSString stringWithFormat:@"%ld",isLookedArray.count];
            [self.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:str];
        }else{
            [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
        if (_kNotificationThreeCountBlock) {
            _kNotificationThreeCountBlock(isLookedArray.count);
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
