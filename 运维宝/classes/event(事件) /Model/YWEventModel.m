//
//  YWEventModel.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWEventModel.h"

@implementation YWEventModel

//+ (NSDictionary *)replacedKeyFromPropertyName{
//    
//    return @{@"notificationID":@"id"};
//    
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"notificationID": @"id"};
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"notificationID":@"id"};
//}


//+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray{
//    NSMutableArray *array = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
//    
//    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    for (YWEventModel *model in array) {
//        model.isLooked = @"0";
//        [resultArray addObject:model];
//    }
//    return resultArray;
//}

@end
