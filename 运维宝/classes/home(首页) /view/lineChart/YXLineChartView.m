//
//  YXLineChartView.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YXLineChartView.h"

@implementation YXLineChartView
//初始化表格控件同时传入两个数组数据
- (id)initWithFrame:(CGRect)frame withYarr:(NSArray *)yarr andXarr:(NSArray *)xarr
{
    if (self == [super initWithFrame:frame]) {
        self.chartYArr = yarr;
        self.chartXArr = xarr;
        
    }
    self.clearsContextBeforeDrawing = YES;
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self == [super initWithCoder:decoder]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"begin drawRect");
    self.ymax = 125;
    self.ysteps =5;
    
    CGFloat scale = (self.frame.size.width-60)/530;
    NSLog(@"scale:%f", scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [UIColor clearColor].CGColor);
    CGContextFillRect(c, rect);
    //曲线的条数
    NSUInteger numberOfPlots = [self.dataSource chartViewNumberOfPlots:self];
    if (!numberOfPlots) {
        return;
    }
    CGFloat offsetX = 40.0f;
    CGFloat offsetY = 0;
    
    CGFloat offsetYbottom = 20.0f;
    CGFloat offsetYtop = 10.0f;
    
    UIFont *stringfont = FONT_9;
    //每个阶段的数据为多少
    CGFloat stepvaule = self.ymax / self.ysteps;
    //屏幕的纵向与数据的纵向比列
    CGFloat stepY = (self.frame.size.height - offsetYtop -offsetYbottom)/ self.ymax;
    
    //画x和y两个大坐标
    CGContextSetRGBStrokeColor(c, 0.6, 0.6, 0.6, 0.6);
    CGContextSetLineWidth(c, 1.0);
    CGPoint xyLines[3] = {CGPointMake(offsetX,offsetYtop),
        CGPointMake(offsetX, self.frame.size.height -offsetYbottom),
        CGPointMake(self.frame.size.width-20, self.frame.size.height -offsetYbottom)};
    CGContextAddLines(c, xyLines, sizeof(xyLines)/sizeof(xyLines[0]));
    CGContextStrokePath(c);
    
    //画steps的虚线和纵向的数据
    for (NSUInteger i = 1; i <=self.ysteps; i++) {
        NSUInteger y = (i * stepvaule) * stepY + offsetY;
        NSUInteger value = i * stepvaule;
        CGContextSetRGBStrokeColor(c, 0.8, 0.8, 0.8, 0.3);
        CGContextSetLineWidth(c, 1.0);
        //CGContextSetLineDash(c,0.0, lineDash, 1);
        CGPoint startPoint = CGPointMake(offsetX, self.frame.size.height- y - offsetYbottom);
        CGPoint endPoint = CGPointMake(self.frame.size.width -20, self.frame.size.height - y - offsetYbottom);
        
        CGContextMoveToPoint(c, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
        CGContextStrokePath(c);
        
        if (i > 0 ) {
            
            NSNumber *valueToFormat = [NSNumber numberWithInt:value];
            NSString *valueString;
            
            valueString = [valueToFormat stringValue];
            [self.yValuesColor set];
            CGRect valueStringRect = CGRectMake(0.0f, self.frame.size.height- y - offsetYbottom-3, 30.0f, 20.0f);
            [valueString drawInRect:valueStringRect withFont:stringfont
                      lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        }
    }
    
    
    //x方向的虚线和info
    NSString *xstring = [self.dataSource chartViewGetXinfo:self];
    NSLog(@"xstring %@",xstring);
    if ([xstring isEqualToString:@""]) {
        
    }
    else {
        NSArray *xdrawinfo = [xstring componentsSeparatedByString:@","];
        if (xdrawinfo!=NULL&&[xdrawinfo count]>0) {
            CGFloat stepX = (self.frame.size.width-offsetX-20)/([xdrawinfo count]-1);
            for (NSUInteger i = 0; i <[xdrawinfo count]; i++) {
                float xv =offsetX +i*stepX;
                if (i !=0) {
                    //CGFloat lineDash[2] = {1.0,1.0};
                    CGContextSetRGBStrokeColor(c, 1.0, 1.0, 1.0, 0.5);
                    CGContextSetLineWidth(c, 1.0);
                    //CGContextSetLineDash(c,0.0, lineDash, 2);
                    //CGContextSetLineWidth(c, 1.0);
                    CGPoint startPoint = CGPointMake(xv, offsetYtop);
                    CGPoint endPoint = CGPointMake(xv, self.frame.size.height -offsetYbottom);
                    
                    CGContextMoveToPoint(c, startPoint.x, startPoint.y);
                    CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
                    CGContextStrokePath(c);
                    
                }
                
                NSString *valueString =[xdrawinfo objectAtIndex:i];
                
                [self.yValuesColor set];
                CGSize strsize =[valueString sizeWithFont:stringfont];
                [valueString drawInRect:CGRectMake(xv-5, self.frame.size.height - offsetYbottom, strsize.width, strsize.height) withFont:stringfont
                          lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
            }
        }
    }
    
    CGContextSetLineDash(c, 0, NULL, 0);
    //取得保存坐标的数组，为6个单元，每个单元中又是数据，表示几条y坐标的数组
    //NSArray *values = [self.dataSource chartViewYPointArray:self];
    //取得x轴方向对应的y轴方向的坐标
    //NSArray *xvaules = [self.dataSource chartViewxPointArray:self];
    NSString *xStr = [self.chartXArr.lastObject componentsJoinedByString:@","];
    NSLog(@"chartXArr--- %@",xStr);
    NSArray *xVaulues = [xStr componentsSeparatedByString:@","] ;
     NSLog(@"xVaulues--- %@",xVaulues);
    for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
        if ([[self.chartYArr objectAtIndex:plotIndex] isEqual:@""]) {
            continue;
        }
        CGColorRef plotColor = ((UIColor *)[self.dataSource  chartViewcolor:self shouldFillPlot:plotIndex]).CGColor;
        NSArray *linearray = [self.chartYArr objectAtIndex:plotIndex];
        
        if ([linearray count] == [xVaulues count]) {
            
            NSInteger valucount  = linearray.count;
            CGPoint addLines[valucount];
            for (NSUInteger w = 0; w < valucount;w++) {
                
                CGFloat x = [[xVaulues objectAtIndex:w] floatValue] * scale;;
                CGFloat y = [[linearray objectAtIndex:w] floatValue] * stepY;;
                
                addLines[w] = CGPointMake(x+offsetX+1, self.frame.size.height- y - offsetYbottom);
                
                NSLog(@"w = %d,x=%f,y=%f",w,x,y);
            }
            CGContextSetStrokeColorWithColor(c,plotColor);
            CGContextSetLineWidth(c, 1.0);
            CGContextAddLines(c, addLines, sizeof(addLines)/sizeof(addLines[0]));
            CGContextStrokePath(c);
        }
       
        //某个arm中的三条线或者一条线
        for (NSInteger linecount = 0; linecount<[linearray count]; linecount++) {
            //if (linecount>0) break;
           NSArray *yarray = [(NSString *)[linearray objectAtIndex:linecount] componentsSeparatedByString:@","];
        }
        
//        CGPoint addLines[200];
//         for (NSUInteger w = 0; w < 200;w++) {
//
//         CGFloat x = 0+w/3.8;
//         CGFloat y = 70;
//
//         addLines[w] = CGPointMake(x+offsetX+1, self.frame.size.height- y - offsetYbottom);
//
//         NSLog(@"w = %d,x=%f,y=%f",w,x,y);
//         }
//         CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
//         CGContextSetLineWidth(c, 2.0);
//         CGContextAddLines(c, addLines, sizeof(addLines)/sizeof(addLines[0]));
//         CGContextStrokePath(c);

    }
    NSLog(@"end drawRect");
    [self.dataSource removeActiveIndictor:nil];
 }

- (void)reloadData {
    [self setNeedsDisplay];
}

- (void)refreshData {
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self 
                                   selector:@selector(timerEvent:) 
                                   userInfo:0 
                                    repeats:NO];
}



- (void)setChartXArr:(NSArray *)chartXArr
{
    _chartXArr = chartXArr;
}

- (void)setChartYArr:(NSArray *)chartYArr
{
    _chartYArr = chartYArr;
}

-(void)timerEvent:(id)timer {
    [self setNeedsDisplay];
}


@end
