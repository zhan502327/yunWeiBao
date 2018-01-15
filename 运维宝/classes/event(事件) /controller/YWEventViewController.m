//
//  YWEventViewController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWEventViewController.h"
#import "YWWarningEventController.h"
#import "YWOperationEventController.h"
#import "YWServiceEventController.h"
#import "UITabBar+Badge.h"



@interface YWEventViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation YWEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加子控制器
    [self addChildrenVc];

}

- (void)addChildrenVc
{
//    预警事件
    YWWarningEventController *warningEvent = [[YWWarningEventController alloc] init];
//    操作事件
    YWOperationEventController *operationEvent = [[YWOperationEventController alloc] init];
//    服务事件
    YWServiceEventController *serviceEvent = [[YWServiceEventController alloc] init];
    NSArray *childArr = @[warningEvent,operationEvent,serviceEvent];
    
    
    /// pageContentView
    CGFloat contentViewHeight = SCREEN_HEIGHT - HEADER_HEIGHT-FOOTER_HEIGHT-44;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    NSArray *titleArr = @[@"预警事件",@"操作事件",@"服务事件"];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) delegate:self titleNames:titleArr];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isIndicatorScroll = NO;
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeSpecial;
    _pageTitleView.selectedIndex = 0;
    _pageTitleView.indicatorColor = LOGINCLOLOR;
    _pageTitleView.titleColorStateSelected = LOGINCLOLOR;
    _pageTitleView.backgroundColor = [UIColor whiteColor];
    _pageTitleView.isNeedBounces = NO;
    
    for (UIButton *button in self.pageTitleView.scrollView.subviews) {
        
        CGFloat labelWH = 12;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetWidth(button.frame) - 30, 10, labelWH, labelWH);
        label.backgroundColor = [UIColor redColor];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = labelWH / 2;
        [button addSubview:label];
    }
    
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
