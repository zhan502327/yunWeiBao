//
//  YWDBLineViewController.h
//  运维宝
//
//  Created by zhandb on 2017/12/24.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMyDevice,YXLineChartView;


@interface YWDBLineViewController : UIViewController
/** 我的电站*/
@property (nonatomic, copy) NSString *a_id;

/** 我的电站*/
@property (nonatomic, strong) YWMyDevice *deviceInfo;


@property (nonatomic,retain) UITableView *table;
@property (nonatomic,retain) NSArray *sectionOneArray;
@property (nonatomic,retain) NSArray *itemArray;
@property (nonatomic,retain) NSArray *preItemArray;
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
//@property (nonatomic,retain) NSArray *dateFormaterArray;

@property (nonatomic, retain) NSString *pId;
@property (nonatomic, retain) NSString *dateParams;
@property (nonatomic, retain) NSString *preDateParams;
@property (nonatomic, retain) UIActivityIndicatorView    *loading;
@property (nonatomic, retain) UIView *bg;

@property (nonatomic, retain) NSString *urlInfo;
@property (nonatomic, retain) NSMutableString *paraInfo;
@property (nonatomic, retain) NSMutableData *listData;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic) BOOL parsingError;

@property (nonatomic, retain) NSString *getolddatasign;
@property (nonatomic) NSInteger firststartsign; //启动后，再viewdidload函数里面置为0；第一次进入界面，或者切换timebutton后，begeinconection函数里置为1；在一个timebutton内，再次运行begeinconnection函数，置为2

@property (nonatomic, retain) NSMutableArray *pickviewYearArray;
@property (nonatomic, retain) NSMutableArray *pickviewMonthArray;

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
//+(void)stopLoading;
-(NSString*)getTimeButtonBG:(NSString *)title;
-(NSInteger)getWeek;


//选择日期
//@property (nonatomic,retain) UIPickerView *datePickerView;

@end
