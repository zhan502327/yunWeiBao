//
//  YWPowerStationController.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMyStations;

@interface YWPowerStationController : UITableViewController

/** 我的电站*/
@property (nonatomic, strong) YWMyStations *station;

@end
