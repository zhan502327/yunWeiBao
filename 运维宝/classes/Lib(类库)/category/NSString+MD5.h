//
//  NSString+MD5.h
//  联盟商城
//
//  Created by 贾斌 on 2017/8/13.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

+ (NSString *)md5To32bit:(NSString *)str;

@end
