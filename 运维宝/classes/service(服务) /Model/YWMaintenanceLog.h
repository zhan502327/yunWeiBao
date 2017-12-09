//
//  YWMaintenanceLog.h
//  运维宝
//
//  Created by 贾斌 on 2017/11/4.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMaintenanceLog : NSObject

/** 88 */
@property (nonatomic, copy) NSString   *r_id;
/**一般*/
@property (nonatomic, copy) NSString   *status;
/**新测试*/
@property (nonatomic, copy) NSString   *title;
/**日期*/
@property (nonatomic, copy) NSString   *date;
/**机械故障*/
@property (nonatomic, copy) NSString   *type;
/** 姓名 */
@property (nonatomic, copy) NSString   *customer;
/**未完成*/
@property (nonatomic, copy) NSString   *is_dispose;


@end
