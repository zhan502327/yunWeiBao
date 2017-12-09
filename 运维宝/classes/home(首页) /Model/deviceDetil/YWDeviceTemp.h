//
//  YWDeviceTemp.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/3.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YWDeviceTempInfo;

@interface YWDeviceTemp : NSObject

/**上触指*/
@property (nonatomic, strong) YWDeviceTempInfo *up;
/**下触指*/
@property (nonatomic, strong) YWDeviceTempInfo *down;
/**电缆联结*/
@property (nonatomic, strong) YWDeviceTempInfo *connect;

@end
