//
//  YWDeviceDetilController.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMyDevice;
@interface YWDeviceDetilController : UIViewController
/** 我的电站*/
@property (nonatomic, copy) NSString *a_id;
/** 我的电站*/
@property (nonatomic, assign) NSInteger colorStatus;
/** 我的电站*/
@property (nonatomic, copy) NSString *stationName;
/** 我的电站*/
@property (nonatomic, strong) YWMyDevice *deviceInfo;


@end
