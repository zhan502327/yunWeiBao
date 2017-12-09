//
//  YWBrandInfo.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWBrandInfo.h"
#import "YWBrandDetil.h"
#import "YWBrandCoreOne.h"
#import "YWBrandCoreTwo.h"


@implementation YWBrandInfo


+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"brand" : [YWBrandDetil class],
             
             @"core1" : [YWBrandCoreOne class],
             
             @"core2" : [YWBrandCoreTwo class]
             
             };
    
}

@end
