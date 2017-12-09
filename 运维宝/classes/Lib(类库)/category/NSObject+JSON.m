//
//  实体联盟
//
//  Created by 贾斌 on 2017/6/24.
//  Copyright © 2017年 贾斌. All rights reserved.
#import "NSObject+JSON.h"

@implementation NSObject (JSON)

- (NSString *)JSONString {
    
    NSData *JSONData = nil;
    if ([self isKindOfClass:[NSDictionary class]]) { // 如果self是NSDictionary
        
        JSONData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    } else if ([self isKindOfClass:[NSObject class]]) {        // 如果self是继承NSObject的非字典对象
     
        JSONData = [NSJSONSerialization dataWithJSONObject:self.keyValues options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}

@end 
