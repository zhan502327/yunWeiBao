//
//  YWCollectViewController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWCollectViewController.h"
#import "YWMyDeviceController.h"
#import "YWPowerStationController.h"

@interface YWCollectViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>


@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation YWCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加子控制器
    [self addChildrenVc];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addChildrenVc
{
    
    YWMyDeviceController *myDevice = [[YWMyDeviceController alloc] init];
    
    YWPowerStationController *powerStation = [[YWPowerStationController alloc] init];
    
    NSArray *childArr = @[myDevice,powerStation];
    /// pageContentView
    CGFloat contentViewHeight = SCREEN_HEIGHT - HEADER_HEIGHT-FOOTER_HEIGHT-44;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"我的设备",@"我的电站"];
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
