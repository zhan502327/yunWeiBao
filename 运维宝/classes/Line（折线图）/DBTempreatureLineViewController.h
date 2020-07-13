//
//  DBTempreatureLineViewController.h
//  运维宝
//
//  Created by zhandb on 2020/7/9.
//  Copyright © 2020 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMyDevice,YXLineChartView;

NS_ASSUME_NONNULL_BEGIN

@interface DBTempreatureLineViewController : UIViewController



/** 我的电站*/
@property (nonatomic, copy) NSString *a_id;

/** 我的电站*/
@property (nonatomic, strong) YWMyDevice *deviceInfo;


@property (nonatomic,retain) NSArray *sectionOneArray;

@property (nonatomic,retain) NSMutableArray *bOpenArray;

@property (nonatomic) BOOL landspace;
@property (nonatomic) BOOL comeinonesign;

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (nonatomic,retain) NSMutableArray *timeArray;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, retain) YXLineChartView *chartView;;

@property (nonatomic,retain) NSMutableDictionary *dataserver;
@property (nonatomic,retain) NSArray *timekey;
@property (nonatomic,retain) NSMutableArray *temperature;

@property (nonatomic,retain) UIPickerView *datePickerView;

@property (nonatomic, retain) NSString *pId;
@property (nonatomic, retain) UIActivityIndicatorView    *loading;
@property (nonatomic, retain) UIView *bg;

@property (nonatomic, retain) NSString *urlInfo;
@property (nonatomic, retain) NSMutableString *paraInfo;
@property (nonatomic, retain) NSMutableData *listData;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic) BOOL parsingError;


@property (nonatomic, retain) NSMutableArray *pickviewYearArray;
@property (nonatomic, strong) NSArray *pickviewMonthArray;

@property (nonatomic) NSInteger pick0compentfocusIndex;
@property (nonatomic) NSInteger pick1compentfocusIndex;
@property (nonatomic) NSInteger pick2compentfocusIndex;
@property (nonatomic) NSInteger pick3compentfocusIndex;

@property (nonatomic,retain) NSString *NewbaseUrl;

-(void)begeinNetConnection:(NSString *)unit;
-(void)removeActiveIndictor:(NSString *)aletmsg;
- (void)showMessage:(NSString *)msg title:(NSString *)title leftButtonText:(NSString *)button1 rightButtonText:(NSString *)button2;
-(void)resetWhenLoadPickview;
-(void)reloadsectionOne;
-(void)setTimeButtonInfo:(UIButton *)cell;
-(NSString*)getTimeButtonBG:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
