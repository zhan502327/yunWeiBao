//
//  YWServiceDetilController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWServiceDetilController.h"
#import "YWDeviceDetilController.h"
#import "YWServiceSuportController.h"
#import "YWTroubleController.h"
#import "YWSpareMangeController.h"
#import "YWMaintenanceLogController.h"
#import "YWSercice.h"


@interface YWServiceDetilController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation YWServiceDetilController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务";
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem itemWithImageName:@"service" highImageName:nil target:self action:@selector(serviceDetil)];

    self.automaticallyAdjustsScrollViewInsets = NO;

    //添加子控制器
    [self addChildrenVc];
}


//跳转到我的设备
- (void)serviceDetil
{
   
    for (UIViewController *vc in self.navigationController.viewControllers) {
       
        if ([vc isKindOfClass:[YWDeviceDetilController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    
    YWDeviceDetilController *deviceDetil = [[YWDeviceDetilController alloc] init];
    deviceDetil.a_id = self.deviceSercice.a_id;
    deviceDetil.stationName = self.deviceSercice.name;
    [self.navigationController pushViewController:deviceDetil animated:YES];
    
    
}

- (void)addChildrenVc
{
    //添加子控制器

    //-----
    YWServiceSuportController *serviceSuport = [[YWServiceSuportController alloc] init];
    serviceSuport.deviceSercice = self.deviceSercice;
    serviceSuport.a_id = self.a_id;
 
    //-----
    YWSpareMangeController *spareMange = [[YWSpareMangeController alloc] init];
    spareMange.deviceSercice = self.deviceSercice;
    spareMange.a_id = self.a_id;
    
    //-----
    YWTroubleController *trouble = [[YWTroubleController alloc] init];
    trouble.deviceSercice = self.deviceSercice;

    //-----
    YWMaintenanceLogController *maintenanceLog = [[YWMaintenanceLogController alloc] init];
    maintenanceLog.deviceSercice = self.deviceSercice;
    maintenanceLog.a_id = self.a_id;
  
    
    
    NSArray *childArr = @[serviceSuport,spareMange,trouble,maintenanceLog];
    /// pageContentView
    CGFloat contentViewHeight = SCREEN_HEIGHT - HEADER_HEIGHT - 44;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"热线支持",@"备件管理",@"缺陷报修",@"维护日志"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:titleArr];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 @end
