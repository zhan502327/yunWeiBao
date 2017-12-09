//
//  YWDeviceDetilInfo.m
//  运维宝
//
//  Created by 斌  on 2017/11/6.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDeviceDetilInfo.h"
#import "YWDeviceDetil.h"
@implementation YWDeviceDetilInfo

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data" : [YWDeviceDetil class]};
}

@end
