//
//  YWDeviceStatus.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/3.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceStatus.h"
#import "YWDeviceStatusInfo.h"

@implementation YWDeviceStatus

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"close" : [YWDeviceStatusInfo class],
             
             @"open" : [YWDeviceStatusInfo class],
             
             @"storage" : [YWDeviceStatusInfo class],
             
             };
    
}


@end
