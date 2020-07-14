//
//  YWChartGroup.m
//  运维宝
//
//  Created by jiabin on 2017/11/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWChartGroup.h"
#import "YWChartLine.h"

@implementation YWChartGroup

//覆盖属性字段名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{@"chart1":@"1",@"chart2":@"2",@"chart3":@"3",@"chart4":@"4",@"chart5":@"5",@"chart6":@"6", @"chart10":@"10"};
    
    
}

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"chart1" : [YWChartLine class],
             @"chart2" : [YWChartLine class],
             @"chart3" : [YWChartLine class],
             @"chart4" : [YWChartLine class],
             @"chart5" : [YWChartLine class],
             @"chart6" : [YWChartLine class],
             @"chart10" : [YWChartLine class]
            };
}

@end
