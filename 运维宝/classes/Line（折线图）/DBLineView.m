//
//  DBLineView.m
//  运维宝
//
//  Created by zhandb on 2020/7/9.
//  Copyright © 2020 com.stlm. All rights reserved.
//

#import "DBLineView.h"
#import "YWChartLine.h"



#define kYuanDianX (30)
#define kYuanDianY (self.frame.size.height - 30)

@interface DBLineView ()

{
    //转换倍率
    CGFloat _xScale;
    CGFloat _yScale;
    CGFloat _xlength;
    CGFloat _ylength;
    CGFloat _xMax;
    CGFloat _yMax;
}
/// y轴坐标
@property (nonatomic, strong) NSArray *yLabelTitleArray;
/// y方向分割线条数  默认5
@property (nonatomic, assign) NSInteger ySteps;

@end


@implementation DBLineView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configDefaultSetting];
    }
    return self;
}

- (void)configDefaultSetting{
    
    self.ySteps = 5;
    
    _yMax = 0;
    
}

- (void)drawRect:(CGRect)rect{
    

    //清除原有的坐标label
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
    
    //直接继承UIView 不需要调用  [super drawRect:rect];
    /*******画出坐标轴********/
    _xlength = rect.size.width - kYuanDianX * 2;
    _ylength = kYuanDianY - 30;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextMoveToPoint(context, kYuanDianX, 30);
    CGContextAddLineToPoint(context, kYuanDianX, kYuanDianY);
    CGContextAddLineToPoint(context,rect.size.width - kYuanDianX , kYuanDianY);
    CGContextStrokePath(context);
    
    
    if (self.xLabelTitleArray.count > 0) {
        NSInteger count = self.xLabelTitleArray.count;
        CGFloat y = kYuanDianY;
        CGFloat width = (self.frame.size.width - 2 * kYuanDianX)/(count-1);
        CGFloat height = 20;
        
        for (int i = 0; i<count; i++) {
            
            CGFloat x = kYuanDianX  + i*width;
            //创建x坐标值
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake( x - width*0.5, y, width, height);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.xLabelTitleArray[i];
            CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-30 * (CGFloat)M_PI / 180), 1, 0, 0);
            label.transform = matrix;
            [self addSubview:label];
            //创建x轴分割线
            if (!(i == 0 || i == count - 1)) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, 0.5);
                CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
                CGContextMoveToPoint(context, x, kYuanDianY);
                CGContextAddLineToPoint(context, x, kYuanDianY - 3);
                CGContextStrokePath(context);
            }
        }
    }
    
    
    if (self.yLabelTitleArray.count > 0) {
        
        NSInteger count = self.yLabelTitleArray.count;
        CGFloat width = 25;
        CGFloat height = 20;
        if (count == 1) {
            height = 20;
        }else{
            height = (kYuanDianY - 30)/(count-1);
        }
        for (int i = 0; i<count; i++) {            
            CGFloat y = kYuanDianY - height/2 - i * height ;
            //创建坐标值
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(0, y, width, height);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentRight;
            label.text = self.yLabelTitleArray[i];
            [self addSubview:label];
            //创建辅助线
            if (!(i == 0 || i == count - 1)) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, 0.5);
                CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 1);
                CGContextMoveToPoint(context, kYuanDianX, kYuanDianY - i * height);
                CGContextAddLineToPoint(context, self.frame.size.width - 30, kYuanDianY - i * height);
                CGContextStrokePath(context);
            }
        }
    }
    
    
    [self drawLineWithArray:self.chartData.chart1 type:@"1"];
    [self drawLineWithArray:self.chartData.chart2 type:@"2"];
    [self drawLineWithArray:self.chartData.chart3 type:@"3"];
    [self drawLineWithArray:self.chartData.chart4 type:@"4"];
    [self drawLineWithArray:self.chartData.chart5 type:@"5"];
    [self drawLineWithArray:self.chartData.chart6 type:@"6"];
    [self drawLineWithArray:self.chartData.chart10 type:@"10"];
}

- (void)drawLineWithArray:(NSArray *)array type:(NSString *)type{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    if ([type isEqualToString:@"1"]) {
        CGContextSetRGBStrokeColor(context, 0.996, 0.486, 0, 1);
    }else if ([type isEqualToString:@"2"]){
        CGContextSetRGBStrokeColor(context, 0, 0.392, 0, 1);
    }else if ([type isEqualToString:@"3"]){
        CGContextSetRGBStrokeColor(context, 0.545, 0, 0, 1);
    }else if ([type isEqualToString:@"4"]){
        CGContextSetRGBStrokeColor(context, 0.98, 0.71, 0.102, 1);
    }else if ([type isEqualToString:@"5"]){
        CGContextSetRGBStrokeColor(context, 0.196, 0.804, 0.196, 1);
    }else if ([type isEqualToString:@"6"]){
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    }else if ([type isEqualToString:@"10"]){
        CGContextSetRGBStrokeColor(context, 0.255, 0.412, 0.882, 1);
    }else{
        
    }
    
    
    for (int i = 0; i<array.count; i++) {
        
        YWChartLine *chart  = array[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    CGContextStrokePath(context);
    
    
    
    
}

- (void)setXLabelTitleArray:(NSArray *)xLabelTitleArray{
    _xLabelTitleArray = xLabelTitleArray;
    if (xLabelTitleArray.count > 0) {
        
        CGFloat max = [xLabelTitleArray.lastObject floatValue];
        
        _xMax = max;
        
    }
    
}

- (void)drawLine{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0, 1);
    
    
    for (int i = 0; i<self.chartData.chart1.count; i++) {
        
        YWChartLine *chart  = self.chartData.chart1[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    
    for (int i = 0; i<self.chartData.chart2.count; i++) {
        YWChartLine *chart  = self.chartData.chart2[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    for (int i = 0; i<self.chartData.chart3.count; i++) {
        YWChartLine *chart  = self.chartData.chart3[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    for (int i = 0; i<self.chartData.chart4.count; i++) {
        YWChartLine *chart  = self.chartData.chart4[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    for (int i = 0; i<self.chartData.chart5.count; i++) {
        YWChartLine *chart  = self.chartData.chart5[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    for (int i = 0; i<self.chartData.chart6.count; i++) {
        YWChartLine *chart  = self.chartData.chart6[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    for (int i = 0; i<self.chartData.chart10.count; i++) {
        YWChartLine *chart  = self.chartData.chart10[i];
        if (i == 0) {
            CGContextMoveToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }else{
            CGContextAddLineToPoint(context, (([chart.x floatValue]*_xlength)/530) + kYuanDianX, kYuanDianY - (([chart.y floatValue]*_ylength)/_yMax));
        }
    }
    
    
    CGContextStrokePath(context);
    
}

- (void)setChartData:(YWChartGroup *)chartData{
    _chartData = chartData;
    
    NSArray *chart1 = chartData.chart1;
    NSArray *chart2 = chartData.chart2;
    NSArray *chart3 = chartData.chart3;
    NSArray *chart4 = chartData.chart4;
    NSArray *chart5 = chartData.chart5;
    NSArray *chart6 = chartData.chart6;
    NSArray *chart10 = chartData.chart10;
    
    CGFloat yMax = 0;
    
    for (YWChartLine *model in chart1) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    
    
    for (YWChartLine *model in chart2) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    
    for (YWChartLine *model in chart3) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    
    for (YWChartLine *model in chart4) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    
    for (YWChartLine *model in chart5) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    
    for (YWChartLine *model in chart6) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    
    for (YWChartLine *model in chart10) {
        yMax = yMax > [model.y floatValue] ? yMax : [model.y floatValue];
    }
    _yMax = ceil(yMax/10) * 10;
    
//    if (_yMax == 0) {
//        return;
//    }
//
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<(_yMax/10) + 1; i++) {
        
        [array addObject:[NSString stringWithFormat:@"%d", i*10]];
        
        
    }
    
    _yLabelTitleArray = array;
    
    
}




@end
