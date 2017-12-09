//
//  YWDocsGroup.m
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWDocsGroup.h"
#import "YWDeviceDocs.h"
@implementation YWDocsGroup

//覆盖属性字段名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{@"DocPublic":@"public"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"drawing" : [YWDeviceDocs class],
             
             @"DocPublic" : [YWDeviceDocs class],
             
             @"assets" : [YWDeviceDocs class]
             
             };
    
}

@end
