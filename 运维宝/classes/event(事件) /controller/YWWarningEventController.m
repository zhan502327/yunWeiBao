
//
//  YWWarningEventController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWWarningEventController.h"
#import "YWDeviceDetilController.h"
#import "YWEventCell.h"
#import "YWEventModel.h"
#import "DBDataBaseManager.h"
#import "UITabBar+Badge.h"

@interface YWWarningEventController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *warningEvents;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/**预警事件*/
@property (nonatomic, strong) YWEventModel *eventModel;
@end

@implementation YWWarningEventController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 首先自动刷新一次
    [self autoRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //删除 表
//    [[DBDataBaseManager shareDataBaseManager] deleteTableWithtableName:kNotificationOne];

    //创建头部尾部
    [self setupFrenshHeaderandFooter];
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
        self.warningEvents = [NSMutableArray array];
        [self getWarningEvent];
    }];
    [self.tableView.mj_header beginRefreshing];

}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getWarningEvent
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/alert_warning.php";
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
                    [[DBDataBaseManager shareDataBaseManager] insertNotificationModel:model tableName:kNotificationOne];
                }
            }

            //查询数据库 获取所有数据
            NSArray *dbArray = [[DBDataBaseManager shareDataBaseManager] queryAllNotificationModelWithtableName:kNotificationOne];

            //数据源
            [self.warningEvents addObjectsFromArray:dbArray];
//            [self.warningEvents addObjectsFromArray:dataArray];

            //查询 isLooked 数据
            NSArray *isLookedArray = [[DBDataBaseManager shareDataBaseManager] queryIsLookedCountWithTableName:kNotificationOne];
            
            [[NSUserDefaults standardUserDefaults] setInteger:isLookedArray.count forKey:@"kNotificationOneIsLookedCount"];
        
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
    
    return self.warningEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建cell
    YWEventCell *cell = [YWEventCell cellWithTableView:tableView];
    
    //传递模型数据
    cell.iconView.image = [UIImage imageNamed:@"fragment_four_yujing"];
    cell.eventModel = self.warningEvents[indexPath.row];
    
    return cell;
}


#pragma mark-代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.warningEvents.count > 0) {
        //执行跳转设备详情
        YWDeviceDetilController *deviceDetil = [[YWDeviceDetilController alloc] init];
        YWEventModel *event = self.warningEvents[indexPath.row];
        deviceDetil.a_id = event.a_id;
        [self.navigationController pushViewController:deviceDetil animated:YES];
        
        //点击cell 更新数据库 isLooked 为已读
        [[DBDataBaseManager shareDataBaseManager] updateNotificationModel:event tableName:kNotificationOne WithIsLooked:@"1"];
        
        //查询 isLooked 数据 未读
        NSArray *isLookedArray = [[DBDataBaseManager shareDataBaseManager] queryIsLookedCountWithTableName:kNotificationOne];
        [[NSUserDefaults standardUserDefaults] setInteger:isLookedArray.count forKey:@"kNotificationOneIsLookedCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //添加事件页的角标
        NSInteger secondEventCount = [kGetData(@"kNotificationTwoIsLookedCount") integerValue];
        NSInteger thirdEventCount = [kGetData(@"kNotificationThreeIsLookedCount") integerValue];
        
        NSInteger allCount = isLookedArray.count + secondEventCount + thirdEventCount;
        
        if (allCount > 0) {
            NSString *str = [NSString stringWithFormat:@"%ld",allCount];
//            [self.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:str];
            [self.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:nil];

        }else{
            [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
        
        if (_kNotificationOneCountBlock) {
            _kNotificationOneCountBlock(isLookedArray.count);
        }
    }
    
}
/**懒加载*/
- (NSMutableArray *)warningEvents
{
    if (!_warningEvents) {
        _warningEvents = [NSMutableArray array];
    }
    return _warningEvents;
}

@end
