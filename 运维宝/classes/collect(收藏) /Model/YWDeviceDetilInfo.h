//
//  YWDeviceDetilInfo.h
//  运维宝
//
//  Created by 斌  on 2017/11/6.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YWDeviceDetil;
@interface YWDeviceDetilInfo : NSObject

/**状态*/
@property (nonatomic, assign)  NSInteger status;
/** 名称 */
@property (nonatomic, copy) NSString   *hum;
/**电站ID*/
@property (nonatomic, strong) NSArray *data;
/** 名称 */
@property (nonatomic, copy) NSString   *is_collection;
/**电站ID*/
@property (nonatomic, copy) NSString   *tmp;
@end
