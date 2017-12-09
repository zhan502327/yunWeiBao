//
//  YXLineChartView.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXLineChartView;

@protocol YXLineChartViewDataSource <NSObject>

//返回需要绘制线得个数
- (NSUInteger)chartViewNumberOfPlots:(YXLineChartView *)chartView;
/**
 * 返回Y轴坐标数值的数组
 */
- (NSArray *)chartViewYPointArray:(YXLineChartView *)chartView;
/**
 * 返回Y轴坐标数值的字符串
 */
- (NSArray *)chartViewxPointArray:(YXLineChartView *)chartView;
/**
 * 返回需要绘制的曲线的颜色
 */
- (UIColor *)chartViewcolor:(YXLineChartView *)chartView shouldFillPlot:(NSUInteger)plotIndex;
/**
 * 返回x方向的数值
 */
- (NSString *)chartViewGetXinfo:(YXLineChartView *)chartView;

- (void)removeActiveIndictor:(NSString *)aletmsg;

@end


@interface YXLineChartView : UIView {
    
    
    //id<YXLineChartViewDataSource> _dataSource;
    
    BOOL _drawInfo;
    NSString *_info;
    UIColor *_infoColor;
    
    //y方向上最大数值为ymax
    NSInteger ymax;
    //把ymax分为几段
    NSInteger ysteps;
    
    
}

@property (nonatomic, assign) id<YXLineChartViewDataSource>dataSource;
/**
 * 返回x方向的数值
 */
@property (nonatomic, retain) UIColor *xValuesColor;
@property (nonatomic, retain) UIColor *yValuesColor;
/**
 * 返回x方向的数值
 */
@property (nonatomic) BOOL drawInfo;
@property (nonatomic, retain) NSString *info;
@property (nonatomic, retain) UIColor *infoColor;
/**
 * y方向上最大数值为ymax
   把ymax分为几段
 */
@property (nonatomic) NSInteger ymax;
@property (nonatomic) NSInteger ysteps;

//Y轴数组
@property (nonatomic,retain) NSArray *chartXArr;
//Y轴数组
@property (nonatomic,retain) NSArray *chartYArr;



- (void)reloadData;

- (void)refreshData;

- (id)initWithFrame:(CGRect)frame withYarr:(NSArray *)yarr andXarr:(NSArray *)xarr;


@end
