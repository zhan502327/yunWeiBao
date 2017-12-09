//
//  YWDeviceStatusNum.h
//  运维宝
//
//  Created by 斌  on 2017/11/2.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWDeviceStatusNum : NSObject

/** 设备数量*/
@property (nonatomic, copy  ) NSString   *asset;
/** 危险数量 */
@property (nonatomic, copy  ) NSString   *danger;
/** 关注数量*/
@property (nonatomic, copy  ) NSString   *attention;
/**正常数量 */
@property (nonatomic, copy  ) NSString   *normal;
/** 离线数量 */
@property (nonatomic, copy  ) NSString   *offline;
/** 通知数量 */
@property (nonatomic, copy  ) NSString   *notice;

@end
