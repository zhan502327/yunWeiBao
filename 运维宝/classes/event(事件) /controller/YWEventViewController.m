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

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;

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
    

    
    for (UILabel *label in _pageTitleView.badgeLabelArray) {
        if (label.tag == 100) {
            self.firstLabel = label;
            if ([kGetData(@"kNotificationOneIsLookedCount") integerValue] > 0) {
                NSString *str = [NSString stringWithFormat:@"%@",kGetData(@"kNotificationOneIsLookedCount")];
                self.firstLabel.hidden = NO;
                self.firstLabel.text = str;
            }else{
                self.firstLabel.hidden = YES;
            }
        }
        
        if (label.tag == 101) {
            self.secondLabel = label;
            
            if ([kGetData(@"kNotificationTwoIsLookedCount") integerValue] > 0) {
                NSString *str = [NSString stringWithFormat:@"%@",kGetData(@"kNotificationTwoIsLookedCount")];
                self.secondLabel.hidden = NO;
                self.secondLabel.text = str;
            }else{
                self.secondLabel.hidden = YES;
            }
        }
        
        if (label.tag == 102) {
            self.thirdLabel = label;
            
            if ([kGetData(@"kNotificationThreeIsLookedCount") integerValue] > 0) {
                NSString *str = [NSString stringWithFormat:@"%@",kGetData(@"kNotificationThreeIsLookedCount")];
                self.thirdLabel.hidden = NO;
                self.thirdLabel.text = str;
            }else{
                self.thirdLabel.hidden = YES;
            }
        }
        
        
    }

    
    
//    预警事件
    YWWarningEventController *warningEvent = [[YWWarningEventController alloc] init];
    [warningEvent setKNotificationOneCountBlock:^(NSInteger count) {
        if (count == 0) {
            self.firstLabel.hidden = YES;
        }else{
            self.firstLabel.text = [NSString stringWithFormat:@"%ld",count];
        }

    }];
//    操作事件
    YWOperationEventController *operationEvent = [[YWOperationEventController alloc] init];
    [operationEvent setKNotificationTwoCountBlock:^(NSInteger count) {
        if (count == 0) {
            self.secondLabel.hidden = YES;
        }else{
            self.secondLabel.text = [NSString stringWithFormat:@"%ld",count];
        }
    }];
//    服务事件
    YWServiceEventController *serviceEvent = [[YWServiceEventController alloc] init];
    [serviceEvent setKNotificationThreeCountBlock:^(NSInteger count) {
        if (count == 0) {
            self.thirdLabel.hidden = YES;
        }else{
            self.thirdLabel.text = [NSString stringWithFormat:@"%ld",count];
        }
    }];
    NSArray *childArr = @[warningEvent,operationEvent,serviceEvent];
    
    
    /// pageContentView
    CGFloat contentViewHeight = SCREEN_HEIGHT - HEADER_HEIGHT-FOOTER_HEIGHT-44;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    

    
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex{
    
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

 @end
