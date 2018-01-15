//
//  YWEventModel.h
//  运维宝
//
//  Created by 贾斌 on 2017/10/20.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWEventModel : NSObject


//id
@property (nonatomic, copy) NSString   *notificationID;
//数据库 是否被查看
@property (nonatomic, copy) NSString   *isLooked;
/**状态*/
@property (nonatomic, copy) NSString   *alert_id;
/** 名称 */
@property (nonatomic, copy) NSString   *explain;
/**电站ID*/
@property (nonatomic, copy) NSString   *device_id;
/** 名称 */
@property (nonatomic, copy) NSString   *station;
/**电站ID*/
@property (nonatomic, copy) NSString   *alert_type_name;
/** 名称 */
@property (nonatomic, copy) NSString   *happen_time;
/**电站ID*/
@property (nonatomic, copy) NSString   *a_id;
/** 名称 */
@property (nonatomic, copy) NSString   *asset;





@end
