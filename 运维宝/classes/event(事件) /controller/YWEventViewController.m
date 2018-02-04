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
#import "DBDataBaseManager.h"



@interface YWEventViewController ()<SGPageTitleViewDelegate,SGPageContentViewDelegate, UIAlertViewDelegate>
{
    //预警事件
    YWWarningEventController *_warningEvent;
    //操作事件
    YWOperationEventController *_operationEvent;
    //服务事件
    YWServiceEventController *_serviceEvent;
    
}
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
    
    for (UIButton *btn in _pageTitleView.pageButtonArray) {
        if (btn.tag == 0) {
        
            //button长按事件
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnOneLong:)];
            
            longPress.minimumPressDuration = 1.5; //定义按的时间
            
            [btn addGestureRecognizer:longPress];
        }
        
        if (btn.tag == 1) {
            //button长按事件
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnTwoLong:)];
            
            longPress.minimumPressDuration = 1.5; //定义按的时间
            
            [btn addGestureRecognizer:longPress];
        }
        
        if (btn.tag == 2) {
            //button长按事件
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnThreeLong:)];
            
            longPress.minimumPressDuration = 1.5; //定义按的时间
            
            [btn addGestureRecognizer:longPress];
        }
    }
    
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

    __weak typeof(self) weakSelf = self;
    
//    预警事件
    _warningEvent = [[YWWarningEventController alloc] init];
    [_warningEvent setKNotificationOneCountBlock:^(NSInteger count) {
        if (count == 0) {
            weakSelf.firstLabel.hidden = YES;
        }else{
            weakSelf.firstLabel.hidden = NO;
            weakSelf.firstLabel.text = [NSString stringWithFormat:@"%ld",count];
        }

        //添加事件页的角标
        NSInteger firstEventCount = [kGetData(@"kNotificationOneIsLookedCount") integerValue];
        NSInteger secondEventCount = [kGetData(@"kNotificationTwoIsLookedCount") integerValue];
        NSInteger thirdEventCount = [kGetData(@"kNotificationThreeIsLookedCount") integerValue];
        
        NSInteger allCount = firstEventCount + secondEventCount + thirdEventCount;
        
        if (allCount > 0) {
            NSString *str = [NSString stringWithFormat:@"%ld",allCount];
            [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:str];
        }else{
            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
        
        
    }];
//    操作事件
    _operationEvent = [[YWOperationEventController alloc] init];
    [_operationEvent setKNotificationTwoCountBlock:^(NSInteger count) {
        if (count == 0) {
            weakSelf.secondLabel.hidden = YES;
        }else{
            weakSelf.secondLabel.hidden = NO;
            weakSelf.secondLabel.text = [NSString stringWithFormat:@"%ld",count];
        }
        
        //添加事件页的角标
        NSInteger firstEventCount = [kGetData(@"kNotificationOneIsLookedCount") integerValue];
        NSInteger secondEventCount = [kGetData(@"kNotificationTwoIsLookedCount") integerValue];
        NSInteger thirdEventCount = [kGetData(@"kNotificationThreeIsLookedCount") integerValue];
        
        NSInteger allCount = firstEventCount + secondEventCount + thirdEventCount;
        
        if (allCount > 0) {
            NSString *str = [NSString stringWithFormat:@"%ld",allCount];
            [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:str];
        }else{
            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
    }];
//    服务事件
    _serviceEvent = [[YWServiceEventController alloc] init];
    [_serviceEvent setKNotificationThreeCountBlock:^(NSInteger count) {
        if (count == 0) {
            weakSelf.thirdLabel.hidden = YES;
        }else{
            weakSelf.thirdLabel.hidden = NO;
            weakSelf.thirdLabel.text = [NSString stringWithFormat:@"%ld",count];
        }
        
        //添加事件页的角标
        NSInteger firstEventCount = [kGetData(@"kNotificationOneIsLookedCount") integerValue];
        NSInteger secondEventCount = [kGetData(@"kNotificationTwoIsLookedCount") integerValue];
        NSInteger thirdEventCount = [kGetData(@"kNotificationThreeIsLookedCount") integerValue];
        
        NSInteger allCount = firstEventCount + secondEventCount + thirdEventCount;
        
        if (allCount > 0) {
            NSString *str = [NSString stringWithFormat:@"%ld",allCount];
            [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:str];
        }else{
            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
    }];
    NSArray *childArr = @[_warningEvent,_operationEvent,_serviceEvent];
    
    
    /// pageContentView
    CGFloat contentViewHeight = SCREEN_HEIGHT - HEADER_HEIGHT-FOOTER_HEIGHT-44;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    

    
}
-(void)btnOneLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    

    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
            NSLog(@"长按事件");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否标记为已读？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 100;
        [alert show];

        
    }

}

-(void)btnTwoLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        NSLog(@"长按事件");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否标记为已读？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 101;

        [alert show];

        
        
    }
}

-(void)btnThreeLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        NSLog(@"长按事件");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否标记为已读？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 102;

        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {//第一个
        if (buttonIndex == 1) {
            [self setEventIsLookedWithEventType:@"1"];
            self.firstLabel.hidden = YES;
            [_warningEvent autoRefresh];
            
        }
        
        
    }
    if (alertView.tag == 101) {//第二个
        if (buttonIndex == 1) {
            [self setEventIsLookedWithEventType:@"2"];
            self.secondLabel.hidden = YES;
            [_operationEvent autoRefresh];
        
        }
    }
    if (alertView.tag == 102) {//第三个
        if (buttonIndex == 1) {
            [self setEventIsLookedWithEventType:@"3"];
            self.thirdLabel.hidden = YES;
            [_serviceEvent autoRefresh];

        }
    }
}


- (void)setEventIsLookedWithEventType:(NSString *)eventType{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    NSString *tableName = nil;
    NSString *isLookedCountKey = nil;
    NSString *otherKeyOne = nil;
    NSString *otherKeyTwo = nil;
    
    if ([eventType isEqualToString:@"1"]) {
        tempArray = _warningEvent.warningEvents;
        tableName = kNotificationOne;
        isLookedCountKey = @"kNotificationOneIsLookedCount";
        otherKeyOne = @"kNotificationTwoIsLookedCount";
        otherKeyTwo = @"kNotificationThreeIsLookedCount";
    }
    
    if ([eventType isEqualToString:@"2"]) {
        tempArray = _operationEvent.operationEvents;
        tableName = kNotificationTwo;
        isLookedCountKey = @"kNotificationTwoIsLookedCount";
        otherKeyOne = @"kNotificationOneIsLookedCount";
        otherKeyTwo = @"kNotificationThreeIsLookedCount";
    }
    
    if ([eventType isEqualToString:@"3"]) {
        tempArray = _serviceEvent.serviceEvents;
        tableName = kNotificationThree;
        isLookedCountKey = @"kNotificationThreeIsLookedCount";
        otherKeyOne = @"kNotificationOneIsLookedCount";
        otherKeyTwo = @"kNotificationTwoIsLookedCount";
    }
    
    for (YWEventModel *model in tempArray) {
        
        [[DBDataBaseManager shareDataBaseManager] updateNotificationModel:model tableName:tableName WithIsLooked:@"1"];
    }

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: isLookedCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //添加事件页的角标
    NSInteger secondEventCount = [kGetData(otherKeyOne) integerValue];
    NSInteger thirdEventCount = [kGetData(otherKeyTwo) integerValue];
    
    NSInteger allCount = 0 + secondEventCount + thirdEventCount;
    
    if (allCount > 0) {
                    NSString *str = [NSString stringWithFormat:@"%ld",allCount];
                    [self.tabBarController.tabBar showBadgeOnItemIndex:3 withTitleNum:str];
        
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }

}



- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex{
    
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
}

- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

 @end
