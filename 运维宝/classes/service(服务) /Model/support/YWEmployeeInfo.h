//
//  YWEmployeeInfo.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWEmployeeInfo : NSObject

/**状态*/
@property (nonatomic, copy) NSString   *mobile;
/** 名称 */
@property (nonatomic, copy) NSString   *Telephone;
/**电站ID*/
@property (nonatomic, copy) NSString   *department;
/** 名称 */
@property (nonatomic, copy) NSString   *customer_id;
/**电站ID*/
@property (nonatomic, copy) NSString   *contact;

@end
