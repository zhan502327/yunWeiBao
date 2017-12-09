//
//  YWSpareMange.h
//  运维宝
//specification = 220VDC/AC,

//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface YWSpareMange : NSObject
/**电站ID*/
@property (nonatomic, copy) NSString   *adaptation_m;
/**电站ID*/
@property (nonatomic, copy) NSString   *parts_model;
/** 名称 */
@property (nonatomic, copy) NSString   *parts_id;
/**电站ID*/
@property (nonatomic, copy) NSString   *parts_name;
/**状态*/
@property (nonatomic, copy) NSString   *place;
/** 名称 */
@property (nonatomic, copy) NSString   *supplier;
/**电站ID*/
@property (nonatomic, copy) NSString   *stock_num;
/**电站ID*/
@property (nonatomic, copy) NSString   *parts_code;
/**电站ID*/
@property (nonatomic, copy) NSString   *brand_name;
/** 名称 */
@property (nonatomic, copy) NSString   *stock_location;
/**电站ID*/
@property (nonatomic, copy) NSString   *brand_owner;


@end
