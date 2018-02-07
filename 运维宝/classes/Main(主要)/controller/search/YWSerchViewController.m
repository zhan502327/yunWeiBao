//
//  YWSerchViewController.m
//  运维宝
//
//  Created by 斌  on 2017/11/1.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSerchViewController.h"
#import "YWDeviceDetilController.h"
#import "SCSearchBar.h"
//搜索设备
#import "YWSerchResultCell.h"
//模型
#import "YWSerch.h"

#import "YWServiceDetilController.h"

@interface YWSerchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *resultDatas;

@property (weak, nonatomic) UISearchBar *searchBar;

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
@end

@implementation YWSerchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建搜索框
    [self setUpSerchbar];
    
    if (self.searchText.length>0) {
        
        //创建头部尾部
        [self setupFrenshHeaderandFooter];
        // 首先自动刷新一次
        [self autoRefresh];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setUpSerchbar

{
    // 1. 创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    self.searchBar.text = self.searchText;
    searchBar.height = 0;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键字";
    self.navigationItem.titleView = searchBar;
    
}


- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString;
    
    
    
    //    self.resultCities = [NSMutableArray array];
    //    // 根据关键字搜索想要的城市数据
    //    for (MTCity *city in self.cities) {
    //        // 城市的name中包含了searchText
    //        // 城市的pinYin中包含了searchText beijing
    //        // 城市的pinYinHead中包含了searchText
    //        if ([city.name containsString:searchText] || [city.pinYin containsString:searchText] || [city.pinYinHead containsString:searchText]) {
    //            [self.resultCities addObject:city];
    //        }
    //    }
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    //self.resultDatas = [[MTMetaTool cities] filteredArrayUsingPredicate:predicate];
    
    //[self.tableView reloadData];人
}

//创建刷新头部和尾部控件
- (void)setupFrenshHeaderandFooter
{
    // 默认当前页从1开始的
    self.currentPage = 1;
    // 设置header和footer
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.resultDatas = [NSMutableArray array];
        [self getDeviceInfo];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getDeviceInfo];
    }];
    
}

/**自动刷新一次*/
- (void)autoRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}
//发送请求获取网络数据
- (void)getDeviceInfo
{
    //组装参数
    if (!self.searchText.length) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_search.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"name"] = self.searchText;    //请求数据
    
    [self.resultDatas removeAllObjects];
    [HMHttpTool post:url params:params success:^(id responseObj) {
        /**停止刷新*/
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        YWLog(@"getDeviceDoc--%@",responseObj);
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        
        if ([status intValue] == 0) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }else{
            NSArray *deviceDict = responseObj[@"data"][@"asstes"];
            
            if ([status isEqual:@1]) { // 数据已经加载完毕, 没有更多数据了人庆丰
                
                self.resultDatas = [YWSerch mj_objectArrayWithKeyValuesArray:deviceDict];
                
                YWLog(@"self.resultDatas--%@",self.resultDatas);
                
                [self.tableView reloadData];
                /**停止刷新*/
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
            }
            
        }
        
        
    } failure:^(NSError *error) {
        
        /**停止刷新*/
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 搜索框代理方法
/**
 *  键盘弹出:搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4.显示遮盖
    //    [UIView animateWithDuration:0.5 animations:^{
    //        self.cover.alpha = 0.5;
    //    }];
}

/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    // 3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    
    //self.searchBar.text = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self.resultDatas removeAllObjects];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    
}

/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (!self.searchText.length) {
        
        [self.resultDatas removeAllObjects];
    }
    self.searchText = searchText;
    
    //发送请求
    [self getDeviceInfo];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSInteger *integer;
    //    if (self.resultDatas.count >0) {
    //         integer = self.resultDatas.count;
    //    };
    return self.resultDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YWSerchResultCell *cell = [YWSerchResultCell cellWithTableView:tableView];
    
    YWSerch *resultSerch = self.resultDatas[indexPath.row];
    
    cell.serch = resultSerch;
    
    return cell;
}

#pragma mark-delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = BGCLOLOR;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = FONT_16;
    titleLab.text = [NSString stringWithFormat:@"共有%lu个搜索结果", (unsigned long)self.resultDatas.count];
    [bgview addSubview:titleLab];
    return bgview;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"共有%lu个搜索结果", (unsigned long)self.resultDatas.count];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 35;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"1"]) {//首页
        //    //电站详情
        YWDeviceDetilController *deviceDetil = [[YWDeviceDetilController alloc] init];
        YWSerch *resultSerch = self.resultDatas[indexPath.row];
        deviceDetil.a_id = resultSerch.assets_id;
        deviceDetil.colorStatus = resultSerch.status;
        [self.navigationController pushViewController:deviceDetil animated:YES];
    }
    if ([self.type isEqualToString:@"2"]) {//服务页
        YWServiceDetilController *serviceDetil = [[YWServiceDetilController alloc] init];
        //传递模型数据
        YWSerch *search = self.resultDatas[indexPath.row];
        //    serviceDetil.deviceSercice = self.services[indexPath.row-2];
        serviceDetil.a_id = search.assets_id;
        [self.navigationController pushViewController:serviceDetil animated:YES];
    }
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
