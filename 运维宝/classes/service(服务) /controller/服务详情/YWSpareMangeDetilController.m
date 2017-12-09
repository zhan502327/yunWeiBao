//
//  YWSpareMangeDetilController.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSpareMangeDetilController.h"
#import "YWDeviceInfoCell.h"
#import "YWSpareMangeDetil.h"


@interface YWSpareMangeDetilController ()

@property(nonatomic, strong) NSMutableArray *mangeDetils;

@property(nonatomic, strong) NSArray *titles;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;
/** NSTimer */
@property (nonatomic, strong) UIWebView *webView;
/**设备信息*/
@property (nonatomic, strong) YWSpareMangeDetil *mangeDetil;

@end

@implementation YWSpareMangeDetilController
- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"备件名称",@"备件类型",@"备件规格",@"适配设备型号",@"适配设备规格",@"库存数量",@"库存地址",@"库存单位",@"备件管理",@"联系电话",@"适配设备厂家",@"备件供应商",@"备件编号",@"重量",@"包装尺寸",@"备注"];
    }
    return _titles;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"备件详情";
    // 首先自动刷新一次
    [self autoRefresh];
    //创建头部尾部
    [self setupFrenshHeaderandFooter];
    
    self.webView = [[UIWebView alloc] init];
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
        self.mangeDetils = [NSMutableArray array];
        [self getDeviceMangeDetil];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getDeviceMangeDetil];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}


//发送请求获取网络数据
- (void)getDeviceMangeDetil
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_bj_info.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"parts_id"] = self.part_id;    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        
        
        NSDictionary *mangeDetilDict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        YWLog(@"getDeviceMangeDetil--%@",mangeDetilDict);
        if ([status isEqual:@1]) { // 数据已经加载完毕, 没有更多数据了
            
            self.mangeDetil = [YWSpareMangeDetil mj_objectWithKeyValues:mangeDetilDict];
            NSMutableArray *detilArr = [[NSMutableArray alloc] init];
            [detilArr addObject:self.mangeDetil.parts_name];
            [detilArr addObject:self.mangeDetil.model];
            [detilArr addObject:self.mangeDetil.specification];
            [detilArr addObject:self.mangeDetil.model_name];
            [detilArr addObject:self.mangeDetil.specification_name];
            [detilArr addObject:self.mangeDetil.stock_num];
            [detilArr addObject:self.mangeDetil.stock_location];
            [detilArr addObject:self.mangeDetil.stock_company];
            [detilArr addObject:self.mangeDetil.employee_name];
            [detilArr addObject:self.mangeDetil.tel1];
            [detilArr addObject:self.mangeDetil.supplier_name];
            [detilArr addObject:self.mangeDetil.stock_company];
            [detilArr addObject:self.mangeDetil.parts_code];
            [detilArr addObject:@"不详"];
            [detilArr addObject:@"不详"];
            [detilArr addObject:@"不详"];
            

            
            self.mangeDetils = detilArr;
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
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //创建cell
    YWDeviceInfoCell *cell = [YWDeviceInfoCell cellWithTableView:tableView];
    //传递模型数据
    if (indexPath.row == 9) {
        cell.didNamePhoneLab = ^(UILabel *label) {
            //拨打电话处理
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",label.text]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        };
    }
    cell.titleLab.text = self.titles[indexPath.row];
    cell.detilLab.text = self.mangeDetils[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
