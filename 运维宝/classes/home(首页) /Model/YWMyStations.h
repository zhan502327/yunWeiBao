//
//  YWMyStations.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/2.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMyStations : NSObject

/**状态*/
@property (nonatomic, copy) NSString *status;
/** 名称 */
@property (nonatomic, copy) NSString *station_name;
/**电站ID*/
@property (nonatomic, copy) NSString *station_id;
/** 名称 */
@property (nonatomic, copy) NSString *s_id;
/**电站ID*/
@property (nonatomic, copy) NSString *a_id;
/**是否收藏 */
@property (nonatomic, assign) BOOL  is_collection;
/** 名称 */
@property (nonatomic, copy) NSString *assets_name;

@end
