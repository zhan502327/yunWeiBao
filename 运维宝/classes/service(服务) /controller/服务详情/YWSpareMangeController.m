//
//  YWSpareMangeController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSpareMangeController.h"
#import "YWSpareMangeDetilController.h"
#import "YWSpareHeadCell.h"
#import "YWSpareDetilCell.h"
#import "YWSercice.h"
#import "YWSpareMange.h"
@interface YWSpareMangeController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *spareMange;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YWSpareMangeController

/**懒加载*/
- (NSMutableArray *)spareMange
{
    if (!_spareMange) {
        _spareMange = [NSMutableArray array];
    }
    return _spareMange;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 首先自动刷新一次
    [self autoRefresh];
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
        self.spareMange = [NSMutableArray array];
        [self getServiceSpareMange];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getServiceSpareMange];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getServiceSpareMange{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/service_parts_supplier_info.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    if (self.a_id) {
        params[@"a_id"] = self.a_id;
    } else {
        params[@"a_id"] = self.deviceSercice.a_id;
    };
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSArray *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        //NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceSpareMange--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            
            self.spareMange = [YWSpareMange mj_objectArrayWithKeyValuesArray:dict];
            
            //获得模型数据
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
    
    return self.spareMange.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        YWSpareHeadCell *cell = [YWSpareHeadCell cellWithTableView:tableView];
        
        return cell;
    }
    //创建cell
    YWSpareDetilCell *cell = [YWSpareDetilCell cellWithTableView:tableView];
    //传递模型
    cell.spareMange = self.spareMange[indexPath.row-1];
    
    return cell;
}

#pragma mark-delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转备件详情
    YWSpareMangeDetilController *spareMangeDetil = [[YWSpareMangeDetilController alloc] init];
    YWSpareMange *spareMange = self.spareMange[indexPath.row-1];
    spareMangeDetil.part_id = spareMange.parts_id;
    [self.navigationController pushViewController:spareMangeDetil animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
