//
//  YWUser.h
//  运维宝
//
//  Created by 斌  on 2017/10/30.
//  Copyright © 2017年 com.stlm. All rights reserved.
//{

#import <Foundation/Foundation.h>

@interface YWUser : NSObject

/** 经度 */
@property (nonatomic, copy  ) NSString   *Latitude;
/** 昵称 */
@property (nonatomic, copy  ) NSString   *Longitude;
/** 用户名 */
@property (nonatomic, copy  ) NSString   *account;
/**用户ID */
@property (nonatomic, copy  ) NSString   *account_id;
/** 地址 */
@property (nonatomic, copy  ) NSString   *address;
/** 应用名称 */
@property (nonatomic, copy  ) NSString   *app_title;
/**安全码 */
@property (nonatomic, copy  ) NSString   *token;
/** 微信号昵称 */
@property (nonatomic, copy  ) NSString   *weixin;
/** 电话 */
@property (nonatomic, copy  ) NSString   *tel1;
/**昵称 */
@property (nonatomic, copy  ) NSString   *nick;
/** 工作 */
@property (nonatomic, copy  ) NSString   *job;
/** 工作单位 */
@property (nonatomic, copy  ) NSString   *employee_name;
/** 单位ID */
@property (nonatomic, copy  ) NSString   *employee_id;
/** 图片 */
@property (nonatomic, copy  ) NSString   *photo_path;


/** 是否是新人 */
@property (nonatomic, assign) NSUInteger newStar;
/** 服务器号 */
@property (nonatomic, assign) NSUInteger serverid;
/** 性别 */
@property (nonatomic, assign) NSUInteger sex;
/** 等级 */
@property (nonatomic, assign) NSUInteger starlevel;
/**
"customer_id" = 2;
"department_0" = 20;
"department_1" = 0;
"department_2" = 0;
"department_id" = 20;
"departmet_limits" = "<null>";
"departmet_limits_0" = "20,31,45,52,32,33,53";
"departmet_limits_1" = "<null>";
"departmet_limits_2" = "<null>";
email = "18135880678@189.cn";
"employee_code" = E0002005;
"employee_id" = 17;
"employee_name" = "\U90d1\U5dde\U8fd0\U7ef4";
flags = "<null>";
job = "\U68c0\U4fee\U73ed\U957f";
"job_number" = 1234;
"job_title" = "\U5de5\U7a0b\U5e08";
"last_date" = "2017-10-28 00:17:30.357";
"last_ip" = "223.104.6.32";
"last_user" = admin;
nick = "\U90d1\U5dde\U8fd0\U7ef4";
"photo_id" = 10170;
"photo_path" = "Thumbnail/201709/34a35aae-5ef1-406e-a9c9-fda8cde47ea5";
"photo_path_raw" = "201709/34a35aae-5ef1-406e-a9c9-fda8cde47ea5";
remark = "<null>";
"role_id" = 1;
sex = "\U7537";
"station_limits" = "<null>";
*/
@end
