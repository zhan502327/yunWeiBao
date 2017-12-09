//
//  NSString+MD5.m
//  联盟商城
//
//  Created by 贾斌 on 2017/8/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

+ (NSString *)md5To32bit:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr),digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}



@end
