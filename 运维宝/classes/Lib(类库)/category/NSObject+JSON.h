//
//  NSObject+JSON.h
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.

//  字典或对象转成JSON字符串数据

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

/**
 *  字典或对象转成JSON字符串数据
 */
@property (nonatomic, copy, readonly) NSString *JSONString;

@end
 
