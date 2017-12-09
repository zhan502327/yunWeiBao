//
//  YWSupportGroup.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWSupportGroup.h"
#import "YWEmployeeInfo.h"
#import "YWBrandInfo.h"
#import "YWOnlineInfo.h"

@implementation YWSupportGroup



+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"employee" : [YWEmployeeInfo class],
             
             @"brand" : [YWBrandInfo class],
             
             @"online" : [YWOnlineInfo class]
             
             };
    
}


@end
