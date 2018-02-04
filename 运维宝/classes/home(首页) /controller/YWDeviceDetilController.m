//
//  YWDeviceDetilController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceDetilController.h"
#import "YWDeviceStatusController.h"
#import "YWDeviceInfoController.h"
#import "YWServiceDetilController.h"
#import "YWDocInfoController.h"
#import "YWServiceDetilController.h"
#import "YWMyStations.h"
#import "YWLineHistoryController.h"//
#import "YWDBLineViewController.h"//
#import "YWDeviceInfo.h"
#import "YWSataionDetilController.h"

@interface YWDeviceDetilController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

/** 颜色块 */
@property (nonatomic,weak) UIImageView *colorView;
/** 设备名 */
@property (nonatomic,weak) UILabel *titleLab;
/** 收藏标记 */
@property (nonatomic,weak) UIButton *collectView;

/**是否收藏 */
@property (nonatomic, assign) BOOL  is_collection;

/**设备模型*/
@property (nonatomic, strong) YWMyStations *station;

@end

@implementation YWDeviceDetilController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设备";
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    
    BOOL contain = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[YWServiceDetilController class]]) {
            contain = YES;
        }
    }
    
    if (contain == NO) {
        self.navigationItem.rightBarButtonItem  = [UIBarButtonItem itemWithImageName:@"fuwu_right" highImageName:nil target:self action:@selector(serviceDetil)];

    }
    
    
    
    
    //获取设备详情
    [self getDeviceInfo];
    
    [self addChildrenVc];
    
    
}


//个人资料页面
- (void)serviceDetil
{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[YWServiceDetilController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    //跳转到服务详情页面
    YWServiceDetilController *service = [[YWServiceDetilController alloc] init];
    service.a_id = self.a_id;
    [self.navigationController pushViewController:service animated:YES];
    
}

- (void)getDeviceInfo
{
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_is_collection.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    //安全码（登录返回的token
    params[@"token"] = kGetData(@"token");
    //电站
    params[@"a_id"] = self.a_id;
    //用户id
    params[@"account_id"] = kGetData(@"account_id");
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
//        NSString *msg = responseObj[@"tip"];
        YWLog(@"getServiceSupport--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            //获取是否收藏
            self.station = [YWMyStations mj_objectWithKeyValues:dict];
            
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@",self.station.assets_name, self.station.station_name]];
            self.titleLab.textColor = [UIColor orangeColor];
//            YWColor(70, 171, 211)
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, self.station.assets_name.length)];
            self.titleLab.attributedText = str;

            
            //属性赋值
            self.is_collection = self.station.is_collection;
            if (self.is_collection == YES) {
                self.collectView.selected = YES;
            } else {
                self.collectView.selected = NO;
            }
        }
        
    } failure:^(NSError *error) {
        /**停止刷新*/
        //[self.tableView.mj_header endRefreshing];
        //[self.tableView.mj_footer endRefreshing];
    }];

    
}

#pragma mark -- 电站点击事件
- (void)titleButtonClicked{

    
    //电站详情
    YWSataionDetilController *stationDetil = [[YWSataionDetilController alloc] init];
    stationDetil.s_id = self.station.s_id;
    stationDetil.station = self.station;
    [self.navigationController pushViewController:stationDetil animated:YES];
    
}

- (void)addChildrenVc
{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    
    CGFloat margin = 20;
    
    // 设置左边色标和名称
    UIImageView *colorView = [[UIImageView alloc] init];
    self.colorView = colorView;

    if (self.colorStatus.length > 0) {
        if ([self.colorStatus isEqualToString:@"0"]) {
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_green_uncheck"];
        } else if ([self.colorStatus isEqualToString:@"1"]){
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_orange_uncheck"];
        }else if ([self.colorStatus isEqualToString:@"2"]){
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_red_uncheck"];
        }else if ([self.colorStatus isEqualToString:@"3"]){
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
        }else{
            self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
            
        }
    }else{
        if ([self.deviceInfo.status isEqualToString:@"0"]) {
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_green_uncheck"];
        } else if ([self.deviceInfo.status isEqualToString:@"1"]){
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_orange_uncheck"];
        }else if ([self.deviceInfo.status isEqualToString:@"2"]){
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_red_uncheck"];
        }else if ([self.deviceInfo.status isEqualToString:@"3"]){
            
            self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
        }else{
            self.colorView.image = [UIImage imageNamed:@"fragment_main_gray_uncheck"];
            
        }
    }
    
    

    
    colorView.layer.cornerRadius = 5;
    colorView.clipsToBounds = YES;
    colorView.y  = 13;
    colorView.x = margin;
    colorView.size = CGSizeMake(16, 16);
    [header addSubview:colorView];
    
    // 设置右边收藏按钮和名称
    UIButton *collectView = [[UIButton alloc] init];
    self.collectView = collectView;
    
    [collectView setImage:[UIImage imageNamed:@"activity_wodedianzhan_yishouchang"] forState:UIControlStateSelected];
    [collectView setImage:[UIImage imageNamed:@"activity_wodedianzhan_shouchang"] forState:UIControlStateNormal];
    
    [collectView addTarget:self action:@selector(collectViewBtnClick:) forControlEvents:UIControlEventTouchDown];
    collectView.y  = 10;
    collectView.x = SCREEN_WIDTH - 35;
    collectView.size = CGSizeMake(20, 20);
    [header addSubview:collectView];
    
    // 设置名称
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.userInteractionEnabled = YES;
    self.titleLab = titleLab;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.numberOfLines = 0;
    if (self.station) {
        titleLab.text = self.station.assets_name;
    } else {
        titleLab.text = self.stationName;
    };
    
    
    CGFloat labX = CGRectGetMaxX(colorView.frame)+15;
    titleLab.y  = 0;
    titleLab.x = labX;
    titleLab.size = CGSizeMake(CGRectGetMinX(self.collectView.frame) - 15 - labX, 40);
    titleLab.textColor = [UIColor orangeColor];
    titleLab.font = [UIFont systemFontOfSize:16];
    [header addSubview:titleLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleButtonClicked)];
    [self.titleLab addGestureRecognizer:tap];


    [self.view addSubview:header];
    
    
    //状态监测
    YWDeviceStatusController *deviceStatus = [[YWDeviceStatusController alloc] init];
    deviceStatus.a_id = self.a_id;
   
    //设备信息
    YWDeviceInfoController *deviceInfo = [[YWDeviceInfoController alloc] init];
    deviceInfo.a_id = self.a_id;
    
    //文档信息
    YWDocInfoController *docInfo = [[YWDocInfoController alloc] init];
    docInfo.a_id = self.a_id;
   
    //趋势分析
//    YWLineHistoryController *lineHistory = [[YWLineHistoryController alloc] init];
//    lineHistory.a_id = self.a_id;
//
    YWDBLineViewController *lineHistory = [[YWDBLineViewController alloc] init];
    lineHistory.a_id = self.a_id;
    
    
    NSArray *childArr = @[deviceStatus,deviceInfo,docInfo,lineHistory];
    /// pageContentView
    CGFloat contentViewHeight = SCREEN_HEIGHT - HEADER_HEIGHT - 84;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0,84, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:childArr];
    
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"状态监测",@"设备信息",@"文档信息",@"趋势分析"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0,40, SCREEN_WIDTH, 44) delegate:self titleNames:titleArr];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isIndicatorScroll = NO;
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeSpecial;
    _pageTitleView.selectedIndex = 0;
    _pageTitleView.indicatorColor = LOGINCLOLOR;
    _pageTitleView.titleColorStateSelected = LOGINCLOLOR;
    _pageTitleView.backgroundColor = [UIColor whiteColor];
    _pageTitleView.isNeedBounces = NO;
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex
{
    
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    
}
//收藏按钮点击状态
- (void)collectViewBtnClick:(UIButton *)button
{
    
//    assets_assets_collect.php
//    token
//    account_id
//    a_id
//    act  "del"删除   "add"收藏
    
    button.selected = !button.selected;
    //组装参数
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *urlStr = @"/assets_assets_collect.php";
    NSString *url = [YWBaseURL stringByAppendingFormat:@"%@",urlStr];
    params[@"token"] = kGetData(@"token");
    params[@"account_id"] = kGetData(@"account_id");
    params[@"a_id"] = self.a_id;
    
    //判断当前电站是否收藏
    if (self.is_collection == YES) {
        params[@"act"] = @"del";
    }else{
        params[@"act"] = @"add";
    }
    //请求数据
    [HMHttpTool post:url params:params success:^(id responseObj) {
        NSDictionary *dict = responseObj[@"data"];
        NSString *status = responseObj[@"code"];
        NSString *msg = responseObj[@"tip"];
        YWLog(@"collectViewBtnClick--%@",responseObj);
        if ([status isEqual:@1]) { // 数据
            //请求成功要做的事
            //属性赋值
            self.is_collection = self.station.is_collection;
            if (self.is_collection) {
                self.collectView.selected = NO;
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
            } else {
                self.collectView.selected = YES;
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        

        
    } failure:^(NSError *error) {
        
        /**停止刷新*/
        //[self.tableView.mj_header endRefreshing];
        //[self.tableView.mj_footer endRefreshing];
    }];
    
}


@end
