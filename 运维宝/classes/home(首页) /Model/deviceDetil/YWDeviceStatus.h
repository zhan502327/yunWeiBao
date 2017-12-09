//
//  YWDeviceStatus.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/3.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YWDeviceStatusInfo;

@interface YWDeviceStatus : NSObject

/**合闸*/
@property (nonatomic, strong) YWDeviceStatusInfo *close;
/**分闸*/
@property (nonatomic, strong) YWDeviceStatusInfo *open;
/**储能*/
@property (nonatomic, strong) YWDeviceStatusInfo *storage;


@end
