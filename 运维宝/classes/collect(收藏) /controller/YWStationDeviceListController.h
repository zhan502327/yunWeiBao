//
//  YWStationDeviceListController.h
//  运维宝
//
//  Created by 斌  on 2017/11/6.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMyStations;

@interface YWStationDeviceListController : UITableViewController
/** 我的电站*/
@property (nonatomic, strong) YWMyStations *station;
/**状态*/
@property (nonatomic, assign) int status;
/**状态*/
@property (nonatomic, copy) NSString   *deviceCode;
/**状态*/
@property (nonatomic, copy) NSString   *s_id;

@end
